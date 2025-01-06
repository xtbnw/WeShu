import PreferencesUtil from "../../util/PreferencesUtil";

//TODO 头像昵称持久化存储查改，id生成算法
@Component
export struct PersonalInfo {
  @Consume('pageInfos') pageInfos: NavPathStack;//父子组件传递
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
  }

  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.user_icon'))
          .height(70)
          .width(70)
          .objectFit(ImageFit.Contain)
        Row(){
          Text("昵称：Admin")
            .fontSize(20+this.fontSizeOffset)
            .fontColor(Color.Black)
        }
        Row(){
          Text("id：123456")
            .fontSize(20+this.fontSizeOffset)
            .fontColor(Color.Black)
        }
      }
      .width('100%')
      .height('100%')
    }
    .title('个人资料')
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
  }
}
@Builder
export function PersonalInfoBuilder(){
  PersonalInfo()
}