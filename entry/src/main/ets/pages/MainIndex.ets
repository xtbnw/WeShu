import PreferencesUtil from '../util/PreferencesUtil';
import { CourseTable } from '../view/coursetable/CourseTable';
import { MineContent } from '../view/mine/MineContent';
import { ReminderContent } from '../view/reminder/ReminderContent';
@Entry
@Component
struct MainIndex {
  @State selectIndex:number= 0;
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  @Builder TabBarBuilder(index:number,icon:ResourceStr,text:string){
    Column(){
      Image(icon)
        .width(this.selectIndex===index?30:25)
      Text(text)
        .fontSize(15+this.fontSizeOffset)
        .fontColor(this.selectIndex===index?Color.Blue:Color.Black)
        .fontWeight(20)
    }
  }
  aboutToAppear() {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
  }

  build() {
    Tabs({
      barPosition:BarPosition.End,//底部
      index: this.selectIndex
    }){
      //提醒
      TabContent(){
        ReminderContent()
      }
        .tabBar(this.TabBarBuilder(0,$r('app.media.reminder_icon'),'提醒'))
      //课表
      TabContent(){
        CourseTable()
      }
        .tabBar(this.TabBarBuilder(1,$r('app.media.course_icon'),'课表'))
      //个人页
      TabContent(){
        MineContent()
      }
        .tabBar(this.TabBarBuilder(2,$r('app.media.mine_icon'),'我的'))
    }
    .onChange((index:number)=>{
      this.selectIndex=index;
    })
  }
}