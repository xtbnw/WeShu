import { Addbutton } from './Addbutton'
import { ReminderItem } from './ReminderItem'
import PreferencesUtil from '../../util/PreferencesUtil';
import { ReminderItemModel } from '../../viewmodel/ReminderItemModel';
import RDBStoreUtil from '../../util/RDBStoreUtil';
import {Fliter} from './Fliter'
@Preview
@Component
export struct ReminderContent {
  @Provide('update') update: NavPathStack = new NavPathStack();
  @State PlansSet: Array<ReminderItemModel> = [];
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0; //全局变量：字体大小偏移量
  @State isShow: boolean = false; //显示已完成事项 TODO 首选项持久化
  @State curToDeleteId: number = -1; //当前要删除的id
  @State text:string="Today";
  @State isAll:boolean=false;

  @Builder
  itemEnd() {
    Row() {
      Image($r('app.media.delete'))
        .width(45)
        .height(45)
        .onClick(async () => {
          console.log("delete")
          if (this.curToDeleteId != -1) {
            await RDBStoreUtil.deletePlan(this.curToDeleteId);
            this.PlansSet = await RDBStoreUtil.queryAllPlans();
            this.curToDeleteId = -1;
          }
        })
    }.padding("4vp").justifyContent(FlexAlign.SpaceEvenly)
  }

  async aboutToAppear(): Promise<void> {
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize(); //获取字体大小偏移量
    RDBStoreUtil.createTODOTable();
    //RDBStoreUtil.initTODOTable();
    await RDBStoreUtil.queryAllPlans().then((value) => {
      this.PlansSet = value;
    });
  }

  build() {
    Navigation(this.update) {
      Stack({ alignContent:Alignment.BottomEnd}) {
        Column() {
          Column() {
            Row() {
              Text(this.isAll ? "All" :"Today")
                .fontColor('#3c80d3')
                .fontSize(25 + this.fontSizeOffset)
                .fontWeight(FontWeight.Bold)
                .padding({ left: 20, top: 10 })
                .fontStyle(FontStyle.Italic)
              Fliter({ isAll: this.isAll, text: this.text, isShow: this.isShow,PlansSet: this.PlansSet})
                .margin({ top: 10, right: 15})
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            List({ space: 12 }) {
              ForEach(this.PlansSet, (item: ReminderItemModel) => {
                if (!item.isCompleted || this.isShow) {
                  ListItem() {
                    ReminderItem({
                      PlansSet: this.PlansSet,
                      Id: item.id,
                      content: item.content,
                      isCompleted: item.isCompleted,
                      remindDateTime: item.remindDateTime,
                      repeatType: item.repeatType
                    })
                  }
                  .height(50 + this.fontSizeOffset) //TODO 不知道哪一步操作后每个item高度占一页了，只能这样先限定高度
                  .swipeAction({
                    end: {
                      builder: () => {
                        this.itemEnd()
                      },
                      actionAreaDistance: 50, //触发删除区域需要的滑动距离
                      onEnterActionArea: () => {
                        this.curToDeleteId = item.id
                      },
                      /*onExitActionArea: () => {
                      }*/
                    }
                  })
                }
              })
            }
            .padding({ top: 10, bottom: 30 })
            .height('95%')
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('100%')
        Addbutton({PlansSet: this.PlansSet})
          .margin({bottom:30,right:25})
      }
    }
  }
}