import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/quote_model.dart';

class Quote_DB_Helper
{
  static Quote_DB_Helper quote_db_helper = Quote_DB_Helper._();
  Quote_DB_Helper._();

  Database? database;

  final dbFile = "dbFile.db";
  final dbCategoryTable = "categoryTable";
  final dbQuoteTable = "quoteTable";

  Future<Database?> checkDB()
  async {
    if(database!= null)
    {
      return database ;
    }
    else
    {
      return await builtDB();
    }
  }

  Future<Database> builtDB()
  async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path,dbFile);
    String catQuery = 'CREATE TABLE $dbCategoryTable (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT)' ;
    String quoteQuery = 'CREATE TABLE $dbQuoteTable (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, author TEXT, quote TEXT, fav TEXT)' ;

    return await openDatabase(path,version:1,
      onCreate: (db, version) async {
        await db.execute(catQuery);
        await db.execute(quoteQuery);
      },);
  }


  Future<void> insertCategory(String category)
  async {
    database = await checkDB();
    await database!.insert(dbCategoryTable, {"category":category});
  }

  Future<void> insertQuote(QuoteModel model)
  async {
    database = await checkDB();

    await database!.insert(dbQuoteTable,
        {
          "category":model.category,
          "author":model.author,
          "quote": model.quote,
          'fav':model.fav
        }
    );

    print("insert in DB");
  }


  Future<List<Map>> readCategoryTABLE()
  async {
    database = await checkDB();
    String query = 'SELECT * FROM $dbCategoryTable';
    List<Map> list = await database!.rawQuery(query);
    print("list ==== $list");
    return list;
  }

  Future<List<Map>> readQuoteTABLE()
  async {
    database = await checkDB();
    String query = 'SELECT * FROM $dbQuoteTable';
    List<Map> list = await database!.rawQuery(query);
    return list;
  }

  Future<void> deleteInCategoryTABLE(int delID)
  async {
    database = await checkDB();

    database!.delete(dbCategoryTable , where: "id=?", whereArgs:[delID] );
  }

  Future<void> deleteInQuoteTABLE(int delID)
  async {
    database = await checkDB();

    database!.delete(dbQuoteTable , where: "id=?", whereArgs:[delID] );
  }

  Future<void> updateInCategoryTABLE({id, category})
  async {
    database = await checkDB();
    database!.update(dbCategoryTable,{'category':category}, where: "id=?",whereArgs: [id]);

    // List<QuoteModel> tempList = list;
    // QuoteModel model = QuoteModel();
    // for(int  i = 0 ; i<tempList.length ;  i++ )
    //   {
    //     model = tempList[i];
    //
    //     database!.update(dbQuoteTable,{
    //       "category":model.category,
    //       "author":model.author,
    //       "quote": model.quote,
    //       'fav':model.fav
    //     }, where: "id=?",whereArgs: [model.id]);
    //   }

  }

  Future<void> updateInQuoteTABLE(QuoteModel model)
  async {
    database = await checkDB();
    database!.update(dbQuoteTable,{
      "category":model.category,
      "author":model.author,
      "quote": model.quote,
      'fav':model.fav
    }, where: "id=?",whereArgs: [model.id]);
  }


  Future<List<Map>> fetchDATAFromDatabase({category,author})
  async {
    database = await checkDB();
    String query = "";

    if(category != null && author == null)
    {
      print("-----------category selected...........");
      query = 'SELECT * FROM $dbQuoteTable WHERE category = "$category" ';
    }
    else if(author != null && category == null)
    {
      print("-----------author selected...........");
      query = 'SELECT * FROM $dbQuoteTable WHERE author = "$author" ';
    }

    List<Map> list = await database!.rawQuery(query);
    print("list ==== $list");
    return list;
  }

  Future<List> fetchDISTINCTAuthors()
  async {
    database = await checkDB();
    String query = 'SELECT DISTINCT author FROM $dbQuoteTable ' ;
    List list = await database!.rawQuery(query);
    print("authorlist ==== $list");
    return list;

  }
  //SELECT DISTINCT Country FROM Customers;


  Future<void> deleteQuotes(int id)
  async {
    print("============== pressed delete--------------- ${id}");
    database = await checkDB();
    database!.delete(dbQuoteTable,where: "id=?" ,whereArgs:[id] );
  }
}
