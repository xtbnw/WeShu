import PreferencesUtil from "../../util/PreferencesUtil";

@Component
export struct About {
  @Consume('pageInfos') pageInfos: NavPathStack; //父子组件传递
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0; //全局变量：字体大小偏移量

  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize(); //获取字体大小偏移量
  }

  build() {
    NavDestination() {
      Column({ space: 2 }) {
        Text("By xtbn")
          .fontColor(Color.Gray)
          .fontSize(16 + this.fontSizeOffset)
          .margin({ top: 30 })
        Text("2025-1-4")
          .fontColor(Color.Gray)
          .fontSize(16 + this.fontSizeOffset)
        Text("Developing")
          .fontColor(Color.Gray)
          .fontSize(16 + this.fontSizeOffset)
      }
      .width('100%')
      .height('100%')
    }
    .title('关于')
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
  }
}

@Builder
export function AboutBuilder() {
  About()
}