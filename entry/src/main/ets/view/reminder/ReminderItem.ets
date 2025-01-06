import PreferencesUtil from '../../util/PreferencesUtil';
import RDBStoreUtil from '../../util/RDBStoreUtil';
import { ReminderItemModel } from '../../viewmodel/ReminderItemModel';

@Component
export struct ReminderItem {
  @Consume('update') update!:NavPathStack;
  @Link PlansSet: Array<ReminderItemModel>;
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0; //全局变量：字体大小偏移量
  @State Id: number = 0;
  @State content: string = "";
  @State isCompleted: boolean = false;
  @State remindDateTime: string = "";
  @State repeatType: string = "";
  @State isFocused: boolean = false;

  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize(); //获取字体大小偏移量
  }

  build() {
      Row({ space: 10 }) {
        Checkbox()
          .select(this.isCompleted)
          .selectedColor(Color.Blue)
          .unselectedColor(Color.Gray)
          .opacity(0.7)
          .onClick(() => { //这里用onchange会出错，一直重复修改状态
            const newStatus = !this.isCompleted; //保存当前状态到变量再修改，否则直接原地修改会出现异步操作的错误
            this.isCompleted = newStatus;
            RDBStoreUtil.updatePlan(this.Id, newStatus).then(() => {
              RDBStoreUtil.queryAllPlans().then((plans) => {
                this.PlansSet = plans; //TODO 延迟消失
              }).catch(() => {
                console.error('更新失败');
              });
            })
          });
        Column() {
          Stack({ alignContent: Alignment.End }) {
            Column() {
              TextInput({ text: this.content })
                .opacity(this.isCompleted ? 0.5 : 1)
                .decoration({ type: this.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None })
                .textAlign(TextAlign.Start)
                .padding({ left: 6 })
                .fontSize(18 + this.fontSizeOffset)
                .backgroundColor(Color.Transparent)
                .width('100%')
                .onFocus(() => {
                  this.isFocused = true;
                })
                .onBlur(() => {
                  this.isFocused = false;
                })
                .onChange(async (value) => {
                  RDBStoreUtil.updateContent(this.Id, value).then(() => {
                    this.content = value;
                  })
                })
              Row() {
                if (this.remindDateTime) {
                  Text(this.remindDateTime)
                    .opacity(0.5)
                    .fontSize(10 + this.fontSizeOffset)
                }
                if (this.repeatType) {
                  Text(this.repeatType)
                    .opacity(0.5)
                    .fontSize(10 + this.fontSizeOffset)
                }
              }
            }
            .width('100%')

            if (this.isFocused) {
              Image($r('app.media.update'))
                .width(25 + this.fontSizeOffset)
                .height(25 + this.fontSizeOffset)
                .onClick(async () => {
                  console.log('update!!!');
                  this.update.pushPathByName('Update',new ReminderItemModel(this.Id,this.content,this.isCompleted,this.remindDateTime,this.repeatType),(popInfo: PopInfo)=>{
                    this.content=JSON.parse(JSON.stringify(popInfo.result)).result//获取返回值
                  })
                })
                .margin({ right: 55 })
            }
          }
          .width('100%')

          Divider()
            .strokeWidth(1)
            .width('100%')
            .padding({ top: 6 })
        }
        .width('100%')
      }
      .width('100%')
    }
}