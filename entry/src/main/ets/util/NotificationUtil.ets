import { notificationManager } from '@kit.NotificationKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class NotificationUtil {
  text:string="提醒"
  ids:number=0;
  // wantAgentObj!:WantAgent

  constructor(T:string,ids:number) {
    this.text=T
    this.ids=ids
  }
  publishNotification() {
    let notificationRequest: notificationManager.NotificationRequest = {
      // 描述通知的请求
      id: this.ids, // 通知ID
      notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
      content: {
        // 通知内容
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
        normal: {
          // 基本类型通知内容
          title: '提醒',
          text: this.text
        }
      },
      // wantAgent: wantAgentObj
    }
    /*wantAgent.getWantAgent({
      wants: [
        {
          bundleName: "com.xtbn.WeShu",
          abilityName: "EntryAbility"
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 100
    })
      .then((data) => {
        this.wantAgentObj = data;
      })*/
    notificationManager.publish(notificationRequest).then(() => { // 发布通知
      console.info('publish success');
    }).catch((err: Error) => {
      console.error(`publish failed,message is ${err}`);
    });
  }
  CancelNotification(){
    const cancelCallback = (err: BusinessError): void => {
      if (err) {
        console.error(`cancel failed, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info("cancel success");
      }
    }
    notificationManager.cancel(this.ids, cancelCallback);
  }
}

/*todo 点击通知跳转到应用

let wantAgentInfo : wantAgent.WantAgentInfo= {
  wants: [
    {
      bundleName: "com.example.notification",
      abilityName: "EntryAbility"
    }
  ],
  operationType: wantAgent.OperationType.START_ABILITY,
  requestCode: 100
}
let wantAgentObj : WantAgent;
wantAgent.getWantAgent(wantAgentInfo)
  .then((data) => {
    wantAgentObj = data;
  })
  .catch((err: Error) => {
    console.error(`get wantAgent failed because ${JSON.stringify(err)}`);
  })*/
