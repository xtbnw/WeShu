import { relationalStore } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import CommonConstants from '../constants/CommonConstants';
import { ReminderItemModel } from '../viewmodel/ReminderItemModel';

const TAG: string = 'RDBStoreUtil';

/**
 *The RDBStoreUtil provides rdbStore of create, save and query.
 */
export class RDBStoreUtil {
  objectiveRDB?: relationalStore.RdbStore;

  /**
   *The method of creating an RDBStore Instance.
   */
  createObjectiveRDB(context: Context) {//创建数据库实例
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'Objective.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    relationalStore.getRdbStore(context, STORE_CONFIG, (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
      this.objectiveRDB = rdbStore;
      if (err) {
        hilog.error(0x0000, TAG, `Get RdbStore failed, code is ${err.code},message is ${err.message}`);
        return;
      }
      hilog.error(0x0000, TAG, 'Get RdbStore successfully.');
    })
  }

  createTODOTable() {//创建表
    this.objectiveRDB?.execute(CommonConstants.CREATE_TODOLIST_TABLE_SQL)
      .then(() => {
        hilog.info(0x0000, TAG, `execute create table sql success`);
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `execute sql failed, code is ${err.code},message is ${err.message}`);
      });
  }

  initTODOTable() {//初始化数据
    const DataOne: relationalStore.ValuesBucket = {
      'id': 0,
      'content': '吃饭',
      'isCompleted': false
    };
    const DataTwo: relationalStore.ValuesBucket = {
      'id': 1,
      'content': '买菜',
      'isCompleted': false
    };
    const DataThree: relationalStore.ValuesBucket = {
      'id': 2,
      'content': '开会',
      'isCompleted': true
    };
    const DataFour: relationalStore.ValuesBucket = {
      'id': 3,
      'content': '锻炼',
      'isCompleted': false
    };
    const DataFive: relationalStore.ValuesBucket = {
      'id': 4,
      'content': '读书',
      'isCompleted': false
    };
    let valueBuckets = new Array(DataOne, DataTwo, DataThree, DataFour, DataFive);
    this.objectiveRDB?.batchInsert('TODOLIST', valueBuckets).then((insertNum: number) => {
      hilog.info(0x0000, TAG, `batchInsert is successful, the number of values that were inserted = ${insertNum}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `batchInsert is failed, code is ${err.code},message is ${err.message}`);
    })
  }

  async insertPlan(ID: null, ct: string, status: boolean,remindTime:string=new Date().toISOString(),repeat?:string) {//插入数据
    const Data: relationalStore.ValuesBucket = {
      'id': ID,
      'content': ct,
      'isCompleted': status,
      'remindDateTime':remindTime,
    };
    if(remindTime)Data.remindTime=remindTime;
    if(repeat)Data.repeat=repeat;
    await this.objectiveRDB?.insert('TODOLIST', Data,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE).then((rowId: number) => {
      hilog.info(0x0000, TAG, `Insert is successful, rowId = ${rowId}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Insert is failed, code is ${err.code},message is ${err.message}`);
    })
  }
  async queryAllPlans(): Promise<ReminderItemModel[]> {//查询所有数据
    let plansSet: Array<ReminderItemModel> = [];
    await this.objectiveRDB?.querySql(CommonConstants.QUERY_ALL_PLANS_SQL)
      .then((resultSet: relationalStore.ResultSet) => {
        while (resultSet.goToNextRow()) {
          const id = resultSet.getValue(resultSet.getColumnIndex('id')) as number;
          const content=resultSet.getValue(resultSet.getColumnIndex('content')) as string;
          const isCompleted=resultSet.getValue(resultSet.getColumnIndex('isCompleted')) as boolean;
          const remindDateTime=resultSet.getValue(resultSet.getColumnIndex('remindDateTime')) as string||undefined;//TODO 如果为空
          const repeatType=resultSet.getValue(resultSet.getColumnIndex('repeatType')) as string||undefined;
          plansSet.push(new ReminderItemModel(id,content,isCompleted,remindDateTime,repeatType));
        }
        resultSet.close();
      }).catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `Query failed, code is ${err.code},message is ${err.message}`);
      })
    return plansSet;
  }

  async updatePlan(planID: number, status: boolean) {//更新数据
    const planData: relationalStore.ValuesBucket = {
      'isCompleted': status
    };
    let predicates = new relationalStore.RdbPredicates('TODOLIST');
    predicates.equalTo('id', planID);
    await this.objectiveRDB?.update(planData, predicates,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE).then(async (rows: Number) => {
      hilog.info(0x0000, TAG, `Updated row count: ${rows}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Updated failed, code is ${err.code},message is ${err.message}`);
    })
  }

  async updateContent(planID: number, ct: string) {//更新数据
    const planData: relationalStore.ValuesBucket = {
      'content': ct
    };
    let predicates = new relationalStore.RdbPredicates('TODOLIST');
    predicates.equalTo('id', planID);
    await this.objectiveRDB?.update(planData, predicates,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE).then(async (rows: Number) => {
      hilog.info(0x0000, TAG, `Updated row count: ${rows}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Updated failed, code is ${err.code},message is ${err.message}`);
    })
  }
  async deletePlan(planID: number) {//删除数据
    let predicates = new relationalStore.RdbPredicates('TODOLIST');
    predicates.equalTo('id', planID);
    await this.objectiveRDB?.delete(predicates).then((rows: Number) => {
      hilog.info(0x0000, TAG, `Delete rows: ${rows}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Delete failed, code is ${err.code},message is ${err.message}`);
    })
  }
  async deleteCompletedPlan() {//删除已完成数据
    let predicates = new relationalStore.RdbPredicates('TODOLIST');
    predicates.equalTo('isCompleted', 1);
    await this.objectiveRDB?.delete(predicates).then((rows: Number) => {
      hilog.info(0x0000, TAG, `Delete rows: ${rows}`);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Delete failed, code is ${err.code},message is ${err.message}`);
    })
  }
}

export default new RDBStoreUtil();