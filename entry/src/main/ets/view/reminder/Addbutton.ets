import RDBStoreUtil from "../../util/RDBStoreUtil"
import { ReminderItemModel } from "../../viewmodel/ReminderItemModel";

@Component
export struct Addbutton{
  @StorageLink('plans') PlansSet: Array<ReminderItemModel>=[];//子组件用@link双向绑定
  clickAction:Function = async () =>{
    console.log("1234321");
    await RDBStoreUtil.insertPlan( null, "新待办事项",false)//await等待插入完成后再进行下面的查询
    await RDBStoreUtil.queryAllPlans().then((value) => {
      console.log("insertandquery");
      this.PlansSet = value;//TODO 自动聚焦到新增事项
    });
  }
  build() {
    Button(){
      Image($r("app.media.addbtn"))
        .width(70)
        .height(70)
    }
    .backgroundColor(Color.Transparent)
    .onClick(()=>{console.log("我靠");this.clickAction()})
  }
}