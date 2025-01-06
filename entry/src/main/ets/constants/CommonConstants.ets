export default class CommonConstants {

  static readonly CREATE_TODOLIST_TABLE_SQL: string=
    "CREATE TABLE IF NOT EXISTS TODOLIST  (id INTEGER PRIMARY KEY AUTOINCREMENT,content TEXT NOT NULL,isCompleted BOOLEAN NOT NULL DEFAULT FALSE,remindDateTime DATETIME,repeatType TEXT CHECK(repeatType IN ('Hourly','Daily', 'Monthly')))";

  static readonly QUERY_ALL_PLANS_SQL: string=
    "SELECT id, content, isCompleted, remindDateTime, repeatType FROM TODOLIST";

  static readonly QUERY_ISNOTCOMPLETED_SQL: string=
    "SELECT * FROM TODOLIST WHERE isCompleted = FALSE";

  static readonly QUERY_ISCOMPLETED_SQL: string=
    "SELECT * FROM TODOLIST WHERE isCompleted = TRUE";
}

/*
*
 * The sql of querying all durations.
static readonly QUERY_ALL_DURATIONS_SQL: string =
  'SELECT DISTINCT DURATION FROM PLANS';

*/
/**
 * The sql of query all plans.
 *//*

static readonly QUERY_ALL_PLANS_SQL: string =
  'SELECT p.id AS ID,s.NAME AS NAME,s.type AS TYPE,p.DURATION AS DURATION,p.STATUS AS STATUS FROM SPORTS AS s ' +
    'JOIN PLANS AS p WHERE s.ID = P.SPORT_ID';

*/
/**
 * The sql of querying plans by duration.
 *//*

static readonly QUERY_PLANS_BY_DURATION_SQL: string =
  'SELECT p.id AS ID,s.NAME AS NAME,s.type AS TYPE,p.DURATION AS DURATION,p.STATUS AS STATUS FROM SPORTS AS s' +
    ' JOIN PLANS AS p WHERE s.ID = P.SPORT_ID AND p.DURATION = ';

*/
/**
 * The sql of querying plans by status.
 *//*

static readonly QUERY_PLANS_BY_STATUS_SQL: string =
  'SELECT p.id AS ID,s.NAME AS NAME,s.type AS TYPE,p.DURATION AS DURATION,p.STATUS AS STATUS FROM SPORTS AS s' +
    ' JOIN PLANS AS p WHERE s.ID = P.SPORT_ID AND p.STATUS = "';*/
