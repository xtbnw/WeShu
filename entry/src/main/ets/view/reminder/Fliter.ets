import RDBStoreUtil from "../../util/RDBStoreUtil";
import { ReminderItemModel } from "../../viewmodel/ReminderItemModel";
import { SymbolGlyphModifier } from "@kit.ArkUI";
import PreferencesUtil from "../../util/PreferencesUtil";

@Component
export struct Fliter {
  @Link isAll: boolean;
  @Link isShow: boolean;
  @StorageLink('plans') PlansSet: Array<ReminderItemModel>=[];
  @Link text: string;
  @State startIconModifier: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.ohos_trash')).fontSize('24vp');

  @Builder
  MyMenu() {
    MenuItemGroup() {
      MenuItem({ content: "显示全部" })
        .selected(this.isAll)
        .selectIcon($r('app.media.selected'))
        .onClick(() => {
          const status = this.isAll;
          this.isAll = !status;
          PreferencesUtil.saveChangeDisplayAll(this.isAll)
        })
      MenuItem({ content: "显示已完成" })
        .selected(this.isShow)
        .selectIcon($r('app.media.selected'))
        .onClick(() => {
          const status = this.isShow;
          this.isShow = !status;
          PreferencesUtil.saveChangeDisplayCompleted(this.isShow)
        })
      MenuItem({ content: "清空已完成" ,symbolStartIcon:this.startIconModifier})
        .onClick(() => {
          RDBStoreUtil.deleteCompletedPlan().then(() => {
            RDBStoreUtil.queryAllPlans().then((plans) => {
              this.PlansSet = plans;
            })
          })
        })
    }
  }

  build() {
    Column() {
      Image($r('app.media.more'))
        .width(32)
        .height(32)
        .bindMenu(this.MyMenu())
    }
  }
}