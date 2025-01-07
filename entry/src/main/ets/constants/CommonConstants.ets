export default class CommonConstants {

  static readonly CREATE_TODOLIST_TABLE_SQL: string=
    "CREATE TABLE IF NOT EXISTS TODOLIST  (id INTEGER PRIMARY KEY AUTOINCREMENT,content TEXT NOT NULL,isCompleted BOOLEAN NOT NULL DEFAULT FALSE,remindDateTime DATETIME,repeatType TEXT CHECK(repeatType IN ('Never','Hourly','Daily', 'Monthly')))";

  static readonly QUERY_ALL_PLANS_SQL: string=
    "SELECT id, content, isCompleted, remindDateTime, repeatType FROM TODOLIST";

  static readonly QUERY_ISNOTCOMPLETED_SQL: string=
    "SELECT * FROM TODOLIST WHERE isCompleted = FALSE";

  static readonly QUERY_ISCOMPLETED_SQL: string=
    "SELECT * FROM TODOLIST WHERE isCompleted = TRUE";
}