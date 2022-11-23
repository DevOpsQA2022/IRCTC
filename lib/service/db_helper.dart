import 'package:irctc/model/train_track_request.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "TGK.db";
  static final _databaseVersion = 1;

  static final table = 'TrainRecords';

  static final columnTrainRecordID = 'TrainRecordId';
  static final columnLoginId = 'LoginId';
  static final columnTrainId = 'TrainId';
  static final columnStationId = 'StationId';
  static final columnReachedTime = 'ReachedTime';
  static final columnDepartureTime = 'DepartureTime';
  static final columnStatus = 'Status';
  static final columnReason = 'Reason';
  static final columnLatitude = 'Latitude';
  static final columnLongitude = 'Longitude';
  static final columnUserID = 'UserId';
  static final columnCreatedDate = 'CreatedDate';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<void> delete()async {
    Database? db = await instance.database;
db!.delete(table);
    // String path = join(await getDatabasesPath(), _databaseName);
    // deleteDatabase(path);
  }
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnTrainRecordID INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnLoginId INTEGER NULL,
            $columnTrainId INTEGER NULL,
            $columnStationId INTEGER NULL,
            $columnReachedTime TEXT NULL,
            $columnDepartureTime TEXT NULL,
            $columnStatus TEXT NULL,
            $columnReason TEXT NULL,
            $columnLatitude TEXT NULL,
            $columnLongitude TEXT NULL,
            $columnUserID INTEGER NULL,
            $columnCreatedDate TEXT NULL
          )
          ''');
    // $columnStationId INTEGER NULL UNIQUE,

  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(TrainTrackRequest car) async {
    Database? db = await instance.database;
    return await db!.insert(table, {columnLoginId: car.loginId, columnTrainId: car.trainId, columnStationId: car.stationId, columnReachedTime: car.reachedTime, columnDepartureTime: car.departureTime, columnStatus: car.status, columnReason: car.reason, columnLatitude: car.latitude, columnLongitude: car.longitude, columnUserID: car.userId, columnCreatedDate: DateTime.now().toString()});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String lastSync) async {
    Database? db = await instance.database;
    if(lastSync != null && lastSync != "null"){
      return await db!.query(table,where: "$columnCreatedDate > '$lastSync'");
    }else{
      return await db!.query(table);

    }
  }

  Future<void> close() async {
    Database? db = await instance.database;
db!.close();
  }

  // // Queries rows based on the argument received
  // Future<List<Map<String, dynamic>>> queryRows(name) async {
  //   Database? db = await instance.database;
  //   return await db!.query(table, where: "$columnName LIKE '%$name%'");
  // }





}