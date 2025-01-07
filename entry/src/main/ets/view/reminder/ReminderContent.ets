import { Addbutton } from './Addbutton'
import { ReminderItem } from './ReminderItem'
import PreferencesUtil from '../../util/PreferencesUtil';
import { ReminderItemModel } from '../../viewmodel/ReminderItemModel';
import RDBStoreUtil from '../../util/RDBStoreUtil';
import { Fliter } from './Fliter'
import { NotificationUtil } from '../../util/NotificationUtil';

@Component
export struct ReminderContent {
  @Provide('update') update: NavPathStack = new NavPathStack();
  @StorageLink('plans') @Watch('sort') PlansSet: Array<ReminderItemModel> = [];
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0; //全局变量：字体大小偏移量
  @State isShow: boolean = false; //显示已完成事项
  @State curToDeleteId: number = -1; //当前要删除的id
  @State text: string = "Today";
  @State isAll: boolean = false;

  sort() { //通过@Watch监听，列表按时间排序
    this.PlansSet.sort((a, b) => {
      if (a.isCompleted && !b.isCompleted) {
        return 1;
      } else if (!a.isCompleted && b.isCompleted) {
        return -1;
      } else {
        return a.remindDateTime >= b.remindDateTime ? 1 : -1
      }
    })
  }

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
    this.isShow = PreferencesUtil.getChangeDisplayCompleted()
    this.isAll = PreferencesUtil.getChangeDisplayAll()
    RDBStoreUtil.createTODOTable();
    await RDBStoreUtil.queryAllPlans().then((value) => {
      this.PlansSet = value;
    });
  }

  build() {
    Navigation(this.update) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Column() {
            Row() {
              Text(this.isAll ? "All" : "Today")
                .fontColor('#3c80d3')
                .fontSize(25 + this.fontSizeOffset)
                .fontWeight(FontWeight.Bold)
                .padding({ left: 20, top: 10 })
                .fontStyle(FontStyle.Italic)
              Fliter({ isAll: this.isAll, text: this.text, isShow: this.isShow })
                .margin({ top: 10, right: 15 })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)


            List({ space: 11 }) {
              ForEach(this.PlansSet, (item: ReminderItemModel) => {
                if ((!item.isCompleted || this.isShow) &&
                  (new Date(item.remindDateTime).getDay() === new Date().getDay() || this.isAll)) {
                  ListItem() {
                    ReminderItem({
                      Id: item.id,
                      content: item.content,
                      isCompleted: item.isCompleted,
                      remindDateTime: item.remindDateTime,
                      repeatType: item.repeatType,
                      isAll: this.isAll
                    })
                  }
                  .height(50 + this.fontSizeOffset) //不知道哪一步操作后每个item高度占一页了，只能这样先限定高度
                  .swipeAction({
                    end: {
                      builder: () => {
                        this.itemEnd()
                      },
                      actionAreaDistance: 50, //触发删除区域需要的滑动距离
                      onEnterActionArea: () => {
                        this.curToDeleteId = item.id
                      }
                    }
                  })
                }
              })
            }
            .padding({ top: 10, bottom: 30 })
            .width('100%')
            .height('96%')
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('100%')

        Addbutton()
          .margin({ bottom: 30, right: 25 })
      }
    }
  }
}