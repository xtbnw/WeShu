import RDBStoreUtil from "../../util/RDBStoreUtil";
import { ReminderItemModel } from "../../viewmodel/ReminderItemModel";

@Component
export struct UpdatePlan {
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0; //全局变量：字体大小偏移量
  @Consume('update') update!: NavPathStack;
  plan: ReminderItemModel = this.update.getParamByIndex(0) as ReminderItemModel
  @State content: string = this.plan.content;
  @State remindDate: Date = new Date();
  @State remindTime: Date = new Date();
  @State repeatText: string = "Never";

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) { //堆叠
        Column({ space: 10 }) {
          Row() {
            Text("Cancel")
              .fontSize(20 + this.fontSizeOffset)
              .fontColor('#2185ed')
              .margin({ left: 6 })
              .onClick(() => {
                this.update.pop()
              })
            Text("Details")
              .fontWeight(FontWeight.Bold)
              .fontSize(22 + this.fontSizeOffset)
            Text("Done")
              .fontColor('#2185ed')
              .fontSize(20 + this.fontSizeOffset)
              .margin({ right: 6 })
              .onClick(() => {
                this.update.pop({ result: this.content }) //TODO 同步 存储
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .margin({ top: 5 })

          Row() {
            TextInput({ text: this.content })
              .textAlign(TextAlign.Start)
              .fontSize(18 + this.fontSizeOffset)
              .backgroundColor(Color.Transparent)
              .width('100%')
              .onChange(async (value) => {
                this.content = value
              })
          }
          .width('94%')
          .backgroundColor(Color.White)
          .borderRadius(10)

          Row() {
            Image($r('app.media.calender'))
              .width(24)
              .height(24)
              .margin({ left: 10 })
            CalendarPicker({ hintRadius: 10, selected: this.remindDate })
              .edgeAlign(CalendarAlign.END)
              .textStyle({ color: "#ff182431", font: { size: 20, weight: FontWeight.Normal } })
              .borderColor(Color.Transparent)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('94%')
          .backgroundColor(Color.White)
          .borderRadius(10)

          Row() {
            Image($r('app.media.time'))
              .width(26)
              .height(26)
              .margin({ left: 10 })
            TimePicker({
              selected: this.remindTime,
            })
              .useMilitaryTime(true)
          }
          .width('94%')
          .backgroundColor(Color.White)
          .borderRadius(10)

          Row() {
            Image($r('app.media.rotation'))
              .width(24)
              .height(24)
              .margin({ left: 10 })
            Select([{ value: 'Never' },
              { value: 'Hourly' },
              { value: 'Daily' },
              { value: 'Mouthly' }])
              .value(this.repeatText)
              .backgroundColor(Color.Transparent)
              .onSelect((index: number, text: string) => {
                this.repeatText = text;
              })
          }
          .width('94%')
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .justifyContent(FlexAlign.Start)
        .backgroundColor('#e9ebec')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .height('80%')
        .width('100%')
      }
      .height("100%")
      .width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.5)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}

@Builder
export function UpdateBuilder() {
  UpdatePlan()
}