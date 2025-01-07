import { NotificationUtil } from '../../util/NotificationUtil';
import PreferencesUtil from '../../util/PreferencesUtil';
import RDBStoreUtil from '../../util/RDBStoreUtil';
import { ReminderItemModel } from '../../viewmodel/ReminderItemModel';

@Component
export struct ReminderItem {
  @Consume('update') update: NavPathStack;
  @StorageLink('plans') PlansSet: Array<ReminderItemModel> = [];
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0; //全局变量：字体大小偏移量
  @State Id: number = 0;
  @State content: string = "";
  @State isCompleted: boolean=true;
  @State remindDateTime: string = "";
  @State repeatType: string = "";
  @State isFocused: boolean = false;
  @State time1:string="";
  @State time2:string="";
  @Link isAll:boolean;
  @State @Watch('notionFuc')overDue:boolean=false;

  notionFuc(){
    if(!this.isCompleted&&this.overDue){
      const notion2=new NotificationUtil(this.content,this.Id);
      notion2.publishNotification()
    }
  }
  aboutToAppear() {
    this.FormatDate()
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize(); //获取字体大小偏移量
    this.isOverDued();
  }
  FormatDate(){
    if(this.remindDateTime){
      const temp1=this.remindDateTime.split("T");
      const temp2=temp1[1].split(":");
      const hour=parseInt(temp2[0])+8;
      const timeOffset=hour/24;
      const temp3=temp1[0].split("-")
      const day=temp3[0]+'-'+temp3[1]+'-'+(timeOffset>=1?(parseInt(temp3[2])+1).toString().padStart(2, '0'):temp3[2]);
      const newHour=(hour%24).toString().padStart(2, '0')
      const minute=parseInt(temp2[1]).toString().padStart(2, '0');
      this.time1=day+' '+newHour+':'+minute;
      this.time2=newHour+':'+minute;
    }
  }
  isOverDued(){
    const remindTime=new Date(this.remindDateTime)
    const nowTime=new Date();
    const timeOut=remindTime.getTime()-nowTime.getTime();
    setTimeout(() => {
      this.overDue=true;
    },timeOut)
  }

  build() {
    Row({ space: 10 }) {
      Checkbox()
        .select(this.isCompleted)
        .selectedColor(Color.Blue)//todo 初始化颜色不正确
        .unselectedColor(Color.Gray)
        .opacity(0.7)
        .onClick(() => { //这里用onchange会出错，一直重复修改状态
          const newStatus = !this.isCompleted; //保存当前状态到变量再修改，否则直接原地修改会出现异步操作的错误
          this.isCompleted = newStatus;
          if(this.isCompleted){
            const notion=new NotificationUtil(this.content,this.Id);
            notion.CancelNotification()
          }
          setTimeout(() => {
            RDBStoreUtil.updatePlan(this.Id, newStatus).then(() => {
              if(this.repeatType!='Never'&&this.isCompleted==true){
                const newDateTime=new Date(this.remindDateTime);
                if(this.repeatType=='Hourly')newDateTime.setHours(newDateTime.getHours()+1);
                else if(this.repeatType=='Daily')newDateTime.setDate(newDateTime.getDate()+1);
                // else if(this.repeatType=='Weekly')
                else if(this.repeatType=='Monthly')newDateTime.setMonth(newDateTime.getMonth()+1);
                RDBStoreUtil.insertPlan(null, this.content, false, newDateTime.toISOString(), this.repeatType).then(()=>{
                  RDBStoreUtil.queryAllPlans().then((plans) => {
                    this.PlansSet = plans;
                  })
                })
              }
              else{
                RDBStoreUtil.queryAllPlans().then((plans) => {
                  this.PlansSet = plans;
                })
              }
            })
          },500)
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
            Row({ space: 20}) {
              Text(this.isAll? this.time1:this.time2)
                .opacity(0.5)
                .fontColor(!this.isCompleted&&this.overDue?Color.Red:Color.Black)
                .fontSize(14 + this.fontSizeOffset)
              if(this.repeatType!='Never'){
                Row({space: 5}){
                  Image($r('app.media.rotation2'))
                    .width(10)
                    .height(10)
                    .opacity(0.6)
                  Text(this.repeatType)
                    .opacity(0.5)
                    .fontSize(14 + this.fontSizeOffset)
                }
              }
            }
            .margin({left: 6})
            .width('100%')
          }
          .width('100%')
          if (this.isFocused) {
            Image($r('app.media.update'))
              .width(25 + this.fontSizeOffset)
              .height(25 + this.fontSizeOffset)
              .onClick(async () => {
                console.log('update!!!');
                this.update.pushPathByName('Update', new ReminderItemModel(this.Id, this.content, this.isCompleted, this.remindDateTime, this.repeatType))
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