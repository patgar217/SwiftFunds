import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  final databaseName = "swiftfunds.db";

  String userTable = '''
   CREATE TABLE user (
   userId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT UNIQUE,
   username TEXT UNIQUE,
   password TEXT,
   swiftpoints REAL
   )
   ''';

  String categoryTable = '''
   CREATE TABLE category (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   name TEXT,
   logo TEXT
   )
   ''';

  String billerTable = '''
   CREATE TABLE biller (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   categoryId INTEGER REFERENCES category(id),
   name TEXT,
   logo TEXT
   )
   ''';

  String currentBillerTable = '''
   CREATE TABLE currentBiller (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   userId INTEGER REFERENCES user(userId),
   billerId INTEGER REFERENCES biller(id),
   nickname TEXT,
   acctName TEXT,
   acctNumber TEXT,
   logo TEXT
   )
   ''';

  String billTable = '''
   CREATE TABLE bill (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   userId INTEGER REFERENCES user(userId),
   currentBillerId INTEGER REFERENCES currentBiller(id),
   dueDate TEXT,
   amount REAL,
   status TEXT,
   isRepeating BOOLEAN,
   frequency TEXT,
   noOfPayments INTEGER,
   noOfPaidPayments INTEGER
   )
   ''';

  String paymentTable = '''
   CREATE TABLE payment (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   userId INTEGER REFERENCES user(userId),
   totalAmount REAL,
   pointsEarned REAL,
   pointsRedeemed REAL,
   paymentDate TEXT,
   status TEXT,
   totalAmountWithPoints REAL
   )
   ''';

  String paymentBillTable = '''
   CREATE TABLE paymentBill (
   paymentId INTEGER REFERENCES payment(id),
   billId INTEGER REFERENCES bill(id),
   PRIMARY KEY (paymentId, billId)
   )
   ''';

  String notificationSettingTable = '''
   CREATE TABLE notificationSetting (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   userId INTEGER REFERENCES user(userId),
   sendNotifications INTEGER,
   scheduledHour INTEGER,
   scheduledMinute INTEGER,
   scheduledDays INTEGER
   )
   ''';

  //Our connection is ready
  Future<Database> initDB ()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path,version: 1 , onCreate: (db,version)async{
      await db.execute(userTable);
      await db.execute(categoryTable);
      await db.execute(billerTable);
      await db.execute(currentBillerTable);
      await db.execute(billTable);
      await db.execute(paymentTable);
      await db.execute(paymentBillTable);
      await db.execute(notificationSettingTable);
      await insertDefaultUser(db);
      await insertDefaultCategories(db);
      await insertDefaultBillers(db);
      await insertDefaultCurrentBillers(db);
      await insertDefaultBills(db);
      await insertDefaultPayments(db);
      await insertNotificationSettings(db);
    });
  }

  Future<void> insertDefaultUser(Database db) async {
    final Map<String, dynamic> userData = {
      "fullName": "Administrator",
      "email": "admin@swiftfunds.com",
      "username": "admin",
      "password": "admin",
      "swiftpoints": 0.10,
    };

    try {
      await db.insert('user', userData);
      debugPrint('Default user inserted successfully!');
    } catch (e) {
      debugPrint('Error inserting default user: $e');
    }
  }

  Future<void> insertNotificationSettings(Database db) async {
    final Map<String, dynamic> notificationSettings = {
      "userId": 1,
      "sendNotifications": 1,
      "scheduledHour": 10,
      "scheduledMinute": 0,
      "scheduledDays": 3,
    };

    try {
      await db.insert('notificationSetting', notificationSettings);
      debugPrint('Default notificationSetting inserted successfully!');
    } catch (e) {
      debugPrint('Error inserting default notificationSetting: $e');
    }
  }

  Future<void> insertDefaultCategories(Database db) async {
    final categories = [
      {
        "name": "Electrical Utilities",
        "logo": "0xe37b"
      },
      {
        "name": "Water Utilities",
        "logo": "0xf05a2"
      },
      {
        "name": "Internet",
        "logo": "0xe542"
      },
      {
        "name": "Cable",
        "logo": "0xe11e"
      },
      {
        "name": "Credit Card",
        "logo": "0xe19f"
      },
      {
        "name": "Loans",
        "logo": "0xe50b"
      },
      {
        "name": "Telecoms",
        "logo": "0xe5b7"
      },
      {
        "name": "Mobile Load",
        "logo": "0xe4a9"
      },
    ];

    for (final category in categories) {
      await db.insert('category', category);
    }

    debugPrint('Default categories inserted successfully!');
  }

  Future<void> insertDefaultBillers(Database db) async {
    final billers = [
      {
          "categoryId": 1,
          "logo": "assets/electricalUtilities/akelco.jpeg",
          "name":"Aklan Electric Cooperative, Inc. (AKELCO)"
      },
      {
          "categoryId": 1,
          "logo": "assets/electricalUtilities/anteco.jpeg",
          "name":"Antique Electric Cooperative, Inc. (ANTECO)"
      },
      {
          "categoryId": 1,
          "logo": "assets/electricalUtilities/capelco.jpeg",
          "name":"Capiz Electric Cooperative, Inc. (CAPELCO)"
      },
      {
          "categoryId": 1,
          "logo": "assets/electricalUtilities/ileco1.jpeg",
          "name":"Iloilo I Electric Cooperative, Inc. (ILECO I)"
      },
      {
          "categoryId": 1,
          "logo": "assets/electricalUtilities/ileco2.jpeg",
          "name":"Iloilo II Electric Cooperative, Inc. (ILECO II)"
      },
      {
          "categoryId": 1,
          "logo": "assets/electricalUtilities/ileco3.jpeg",
          "name":"Iloilo III Electric Cooperative, Inc. (ILECO III)"
      },
      {
          
          "categoryId": 1,
          "logo": "assets/electricalUtilities/guimelco.jpeg",
          "name":"Guimaras Electric Cooperative, Inc. (GUIMELCO)"
      },
      {
          
          "categoryId": 1,
          "logo": "assets/electricalUtilities/noneco.jpeg",
          "name":"Northern Negros Electric Cooperative, Inc. (NONECO)"
      },
      {
          
          "categoryId": 1,
          "logo": "assets/electricalUtilities/ceneco.jpeg",
          "name":"Central Negros Electric Cooperative, Inc. (CENECO)"
      },
      {
          
          "categoryId": 1,
          "logo": "assets/electricalUtilities/noceco.jpeg",
          "name":"Negros Occidental Electric Cooperative, Inc. (NOCECO)"
      },
      {
          
          "categoryId": 2,
          "logo": "assets/waterUtilities/bacolod.jpeg",
          "name":"Bacolod City Water District"
      },
      {
          
          "categoryId": 2,
          "logo": "assets/waterUtilities/buenavista.jpeg",
          "name":"Buenavista Water District"
      },
      {
          
          "categoryId": 2,
          "logo": "assets/waterUtilities/iloilo.png",
          "name":"Metro Iloilo Water District"
      },
      {
          
          "categoryId": 2,
          "logo": "assets/waterUtilities/kalibo.jpeg",
          "name":"Metro Kalibo Water District"
      },
      {
          
          "categoryId": 2,
          "logo": "assets/waterUtilities/roxas.png",
          "name":"Metro Roxas Water District"
      },
      {
          
          "categoryId": 2,
          "logo": "assets/waterUtilities/numancia.jpeg",
          "name":"Numancia Water District"
      },
      {
          
          "categoryId": 2,
          "logo": "",
          "name":"Zarraga Water District"
      },
      {
          
          "categoryId": 3,
          "logo": "assets/internet/converge.png",
          "name":"CONVERGE ICT"
      },
      {
          
          "categoryId": 3,
          "logo": "assets/internet/globe.png",
          "name":"GLOBE AT HOME"
      },
      {
          
          "categoryId": 3,
          "logo": "assets/internet/pldt.png",
          "name":"PLDT"
      },
      {
          
          "categoryId": 3,
          "logo": "assets/internet/pldt.png",
          "name":"PLDT HOME FIBER"
      },
      {
          
          "categoryId": 3,
          "logo": "assets/internet/sky.png",
          "name":"SKY FIBER"
      },
      {
          
          "categoryId": 3,
          "logo": "assets/internet/smart.png",
          "name":"SMART"
      },
      {
          
          "categoryId": 4,
          "logo": "assets/cable/cignal.png",
          "name":"Cignal"
      },
      {
          
          "categoryId": 4,
          "logo": "assets/cable/kalibo.jpeg",
          "name":"Kalibo Cable TV"
      },
      {
          
          "categoryId": 4,
          "logo": "assets/cable/satlite.png",
          "name":"SatLite"
      },
      {
          
          "categoryId": 4,
          "logo": "assets/cable/sky.png",
          "name":"SKY Cable"
      },
      {
          
          "categoryId": 4,
          "logo": "assets/cable/usatv.png",
          "name":"USATV"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/aub.jpeg",
          "name":"AUB Credit Cards"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/boc.jpeg",
          "name":"Bank of Commerce"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/bdo.jpeg",
          "name":"BDO Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/bpi.jpeg",
          "name":"BPI Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/chinabank.jpeg",
          "name":"Chinabank Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/citibank.png",
          "name":"Citibank Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/eastwest.jpeg",
          "name":"EastWest Bank"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/maybank.png",
          "name":"Maybank Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/metrobank.png",
          "name":"Metrobank or PSB Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/pnb.png",
          "name":"PNB Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/robinsons.png",
          "name":"Robinsons Credit Card"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/securitybank.png",
          "name":"Security Bank Mastercard"
      },
      {
          
          "categoryId": 5,
          "logo": "assets/cc/unionbank.jpeg",
          "name":"Unionbank Visa or MC"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/asialink.png",
          "name":"Asialink"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/banko.png",
          "name":"Banko"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/bdo.jpeg",
          "Name":"BDO Network Bank"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/bpi.jpeg",
          "name":"BPI Auto and Housing - Loan Payment"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/cashalo.png",
          "name":"Cashalo"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/dragonloans.png",
          "name":"Dragon Loans"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/homecredit.png",
          "name":"Home Credit"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/imperial.png",
          "name":"Imperial Appliance Plaza"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/jmarketing.png",
          "name":"J Marketing Corp"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/motorstar.png",
          "name":"Motorstar"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/skypay.jpeg",
          "name":"Sky Pay"
      },
      {
          
          "categoryId": 6,
          "logo": "assets/loan/tala.png",
          "name":"Tala"
      },
      {
          
          "categoryId": 7,
          "logo": "assets/telecom/bayantel.jpeg",
          "name":"Bayantel"
      },
      {
          
          "categoryId": 7,
          "logo": "assets/telecom/globehome.png",
          "name":"Globe At Home"
      },
      {
          
          "categoryId": 7,
          "logo": "assets/telecom/globe.jpeg",
          "name":"Globe Postpaid"
      },
      {
          
          "categoryId": 7,
          "logo": "assets/telecom/globe.jpeg",
          "name":"Globelines"
      },
      {
          
          "categoryId": 7,
          "logo": "assets/telecom/pldt.png",
          "name":"PLDT"
      },
      {
          
          "categoryId": 7,
          "logo": "assets/telecom/smart.png",
          "name":"Smart Communications"
      },
      {
          "categoryId": 8,
          "logo": "assets/load/dito.png",
          "name":"DITO"
      },
      {
          "categoryId": 8,
          "logo": "assets/load/globe.jpeg",
          "name":"Globe"
      },
      {
          "categoryId": 8,
          "logo": "assets/load/smart.png",
          "name":"Smart"
      },
      {
          "categoryId": 8,
          "logo": "assets/load/tm.png",
          "name":"TM"
      },
      {
          "categoryId": 8,
          "logo": "assets/load/tnt.png",
          "name":"TNT"
      }

    ];

    for (final biller in billers) {
      await db.insert('biller', biller);
    }

    debugPrint('Default billers inserted successfully!');
  }

  Future<void> insertDefaultCurrentBillers(Database db) async {
    final currentBillers = [
      {
          "userId": 1,
          "billerId": 3,
          "nickname":"CAPELCO",
          "acctName": "Juan Dela Cruz",
          "acctNumber": "123456789",
          "logo": "assets/electricalUtilities/capelco.jpeg",
      },
      {
          
          "userId": 1,
          "billerId": 15,
          "nickname":"Water",
          "acctName": "Juan Dela Cruz",
          "acctNumber": "000111222",
          "logo": "assets/waterUtilities/roxas.png",
      },
      {
          
          "userId": 1,
          "billerId": 19,
          "nickname":"Internet",
          "acctName": "Juan Dela Cruz",
          "acctNumber": "444555666",
          "logo": "assets/internet/globe.png",
      }
    ];

    for (final currentBiller in currentBillers) {
      await db.insert('currentBiller', currentBiller);
    }

    debugPrint('Default current billers inserted successfully!');
  }

  Future<void> insertDefaultBills(Database db) async {
    final bills = [
      {
          "userId": 1,
          "currentBillerId": 1,
          "dueDate":"03-20-2024",
          "amount": 1000.00,
          "status": "PAID",
          "isRepeating": 0,
          "frequency": null,
          "noOfPayments": null,
          "noOfPaidPayments": 1
      },
      {
          "userId": 1,
          "currentBillerId": 1,
          "dueDate":"05-15-2024",
          "amount": 2500.00,
          "status": "PENDING",
          "isRepeating": 0,
          "frequency": null,
          "noOfPayments": null,
          "noOfPaidPayments": 0
      },
      {
          
          "userId": 1,
          "currentBillerId": 2,
          "dueDate":"05-13-2024",
          "amount": 500.00,
          "status": "PENDING",
          "isRepeating": 0,
          "frequency": null,
          "noOfPayments": null,
          "noOfPaidPayments": 0
      },
      {
          
          "userId": 1,
          "currentBillerId": 3,
          "dueDate":"05-12-2024",
          "amount": 1000.00,
          "status": "PENDING",
          "isRepeating": 1,
          "frequency": "MONTHLY",
          "noOfPayments": 3,
          "noOfPaidPayments": 0
      },
    ];

    for (final bill in bills) {
      await db.insert('bill', bill);
    }

    debugPrint('Default bills inserted successfully!');
  }

  Future<void> insertDefaultPayments(Database db) async {
    final Map<String, dynamic> payment = {
          "userId": 1,
          "totalAmount": 1000.00,
          "pointsEarned": 0.10,
          "pointsRedeemed": 0.00,
          "paymentDate": "03-12-2024 10:00 AM",
          "status": "SUCCESS",
          "totalAmountWithPoints": 1000.00
      };

    try {
      await db.insert('payment', payment);
      debugPrint('Default payment inserted successfully!');
    } catch (e) {
      debugPrint('Error inserting default user: $e');
    }

    final Map<String, dynamic> paymentBill = {
          "paymentId": 1,
          "billId": 1,
      };

    try {
      await db.insert('paymentBill', paymentBill);
      debugPrint('Default payment bill inserted successfully!');
    } catch (e) {
      debugPrint('Error inserting default user: $e');
    }
  }
}