import PreferencesUtil from "../../util/PreferencesUtil";

//TODO 页面渲染时向应用商店发送网络请求检查版本号是否最新
@Component
export struct CheckUpdate {
  @Consume('pageInfos') pageInfos: NavPathStack; //父子组件传递
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
  }
  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text('已是最新版本！')
            .fontSize(20+this.fontSizeOffset)
            .margin({ bottom: 80 })
          Button("Close").onClick(() => {
            this.pageInfos.pop()
          }).width('30%')
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(20)
        .height('30%')
        .width('80%')
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
export function CheckUpdateBuilder() {
  CheckUpdate()
}