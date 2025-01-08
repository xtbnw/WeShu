@Component
@Preview
export struct Course {
  courseName: string= '数据结构';
  teacherName: string= '王老师';
  className:string="EJ206"
  build() {
    Column({space: 10}){
      Row(){
        Text(this.courseName)
      }
      Row(){
        Text(this.teacherName)
      }
      Row(){
        Text(this.className)
      }
    }
    .height(100)
    .width(70)
    .borderRadius(10)
    .backgroundColor(Color.Gray)
    .justifyContent(FlexAlign.Center)
  }
}