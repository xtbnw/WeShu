import PreferencesUtil from "../../util/PreferencesUtil";

@Preview
@Component
export struct MineContent {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
  }
  @Builder item(msg:string,img:ResourceStr,page:string){
    Column(){
      Row(){
        Row(){
          Image(img)
            .width(25)
            .height(25)
            .margin({ left: 10 })
          Text(msg)
            .fontSize(18+this.fontSizeOffset)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 6 })
        }
        Text(">")
          .fontColor(Color.Gray)
          .fontSize(20+this.fontSizeOffset)
          .margin({ right: 6 })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(36)
      .width('94%')
      .borderRadius(16)
      .backgroundColor('#ebebeb')
      .margin({ left: 6, right: 6 })
    }
    .width('100%')
    .margin({ top: 10 })
    .onClick(() => {
      console.log("11111")
      this.pageInfos.pushPathByName(page,null);
    })
  }
  build() {
    Navigation(this.pageInfos){//这里一定要传入页面栈！！！
      Column() {
        Row() {
          Row() {
            Image($r('app.media.user_icon'))
              .height(60)
              .width(60)
              .margin({ left: 6 })
              .objectFit(ImageFit.Contain)
            Column() {
              Text("Admin")
                .fontSize(20+this.fontSizeOffset)
                .fontColor(Color.Black)
              Text("id:123456")
                .fontSize(16+this.fontSizeOffset)
                .fontColor(Color.Gray)
            }
            .margin({ left: 10 })
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height(120)

        Column(){
          this.item("个人资料",$r('app.media.personal_info'),'PersonalInfo')
          this.item("检查更新",$r('app.media.check_update'),'CheckUpdate')
          this.item("设置",$r('app.media.setting'),'Setting')
          this.item("关于",$r('app.media.about'),'About')
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }
  }
}