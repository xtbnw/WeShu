import { notificationManager } from '@kit.NotificationKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
//todo reminderAgentManager (后台代理提醒)
export class NotificationUtil {
  text:string="提醒"
  ids:number=0;

  constructor(T:string,ids:number) {
    this.text=T
    this.ids=ids
  }
  publishNotification() {
    let wantAgentInfo : wantAgent.WantAgentInfo= {
      wants: [
        {
          bundleName: "com.xtbn.Weshu",
          abilityName: "EntryAbility"
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 100
    }
    wantAgent.getWantAgent(wantAgentInfo)
      .then((wantAgentObj:WantAgent) => {
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
          wantAgent: wantAgentObj
        }
        notificationManager.publish(notificationRequest).then(() => { // 发布通知
          console.info('publish success');
        }).catch((err: Error) => {
          console.error(`publish failed,message is ${err}`);
        });
      })
      .catch((err: Error) => {
        console.error(`get wantAgent failed because ${JSON.stringify(err)}`);
      })
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
