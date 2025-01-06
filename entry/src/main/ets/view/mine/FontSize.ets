import PreferencesUtil from "../../util/PreferencesUtil";

@Component
export struct FontSize {
  @Consume('pageInfos') pageInfos: NavPathStack; //父子组件传递
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  @State currentValue: number = 0;
  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
    this.currentValue = this.fontSizeOffset;
  }

  build() {
    NavDestination() {//TODO 目前用的是 NavDestination，也可以改成弹窗@CustomDialog
      Stack({ alignContent: Alignment.Bottom }) {//堆叠
        Column() {
          Row(){
            Text("Done")
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#2185ed')
              .margin({right:12})
              .onClick(() => {
                PreferencesUtil.saveChangeFontSize(this.currentValue);
                this.fontSizeOffset = this.currentValue;
                this.pageInfos.pop()
              })
              .fontStyle(FontStyle.Italic)
          }
          .justifyContent(FlexAlign.End)
          .width('100%')
          Row(){
            Text("你好！")
              .fontSize(30+this.currentValue)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Black)
              .margin({ top: 5 ,bottom: 10})
          }
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.Center)
          Slider({
            value: this.fontSizeOffset,
            min:-4,
            max: 4,
          })
            .onChange((value: number) => {
              this.currentValue = value;
            })
            .margin({ top: 10, bottom: 10 ,left: 5, right: 5})
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .height(170)
        .width('96%')
        .margin({ bottom: 3 })
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
export function FontSizeBuilder() {
  FontSize()
}