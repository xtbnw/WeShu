import PreferencesUtil from "../../util/PreferencesUtil";

//TODO 修改主题（选择深浅、跟随系统）
@Component
export struct Setting {
  @Consume('pageInfos') pageInfos: NavPathStack; //父子组件传递
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
  }

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        Row() {
          Text('字体大小')
            .fontSize(20+this.fontSizeOffset)
            .fontColor(Color.Black)
            .margin({ left: 20 })
          Text(">")
            .fontSize(20+this.fontSizeOffset)
            .margin({ right: 10 })
            .fontColor(Color.Gray)
        }
        .width('94%')
        .borderRadius(12)
        .backgroundColor('#ebebeb')
        .justifyContent(FlexAlign.SpaceBetween)
        .height(30+this.fontSizeOffset)
        .onClick(() => {
          this.pageInfos.pushPathByName('FontSize', null)
        })

        Row() {
          Text("页面主题")
            .fontSize(20+this.fontSizeOffset)
            .fontColor(Color.Black)
            .margin({ left: 20 })
          Text(">")
            .fontSize(20+this.fontSizeOffset)
            .fontColor(Color.Gray)
            .margin({ right: 10 })
        }
        .width('94%')
        .borderRadius(12)
        .justifyContent(FlexAlign.SpaceBetween)
        .height(30+this.fontSizeOffset)
        .backgroundColor('#ebebeb')
        .onClick(() => {//TODO 主题更改持久化
          TextPickerDialog.show({
            range: ['深色', '浅色', '跟随系统'],
            onAccept: (value: TextPickerResult) => {
            },
            canLoop: false
          })
        })
      }
      .width('100%')
      .height('90%')
      .margin({ top: 20 })
    }
    .title('设置')
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
  }
}

@Builder
export function SettingBuilder() {
  Setting()
}