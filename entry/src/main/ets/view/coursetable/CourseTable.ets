import { Course } from "./Course"
import {WebView} from "./WebView"
import router from '@ohos.router';

@Preview
@Component
export struct CourseTable {
  @Provide('web') webs: NavPathStack = new NavPathStack()
  courseList: Array<number> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  build() {
    Column() {
      Navigation(this.webs){
        Row() {
          Text("第 8 周")
            .fontColor('#3c80d3')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .padding({ left: 20, top: 10 })
            .fontStyle(FontStyle.Italic)
          Image($r('app.media.load'))
            .width(26)
            .height(24)
            .margin({ right: 20,top: 10 })
            .onClick(()=>{
              this.webs.pushPathByName('WebView',null)
            })
        }
        .height(50)
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text("周一")
            .width("20%")
          Text("周二")
            .width("20%")
          Text("周三")
            .width("20%")
          Text("周四")
            .width("20%")
          Text("周五")
            .width("20%")
        }
        .width("100%")
        .height(80)

        Grid() {
          ForEach(this.courseList, (item: number, index: number) => {
            GridItem() {
              Course()
            }
            .width("20%")
          })
        }
      }
      .width("100%")
      .height("100%")
      }
  }
}