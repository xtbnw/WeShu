import { Router } from '@ohos.arkui.UIContext'
import router from '@ohos.router';
import PreferencesUtil from '../util/PreferencesUtil';

@Entry
@Component
struct SplashIndex {
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0;//全局变量：字体大小偏移量
  build() {
    Column(){
      Text("WeShu")
        .fontSize(30+this.fontSizeOffset)
        .fontColor('#182431')
        .fontWeight(700)
        .letterSpacing(0.1)
        .opacity(0.7)
        .margin({top: 100})
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.welcomeBg'))
    .backgroundImageSize({width: '100%', height: '100%'})
    .backgroundImagePosition({x:0, y:0})
  }
  aboutToAppear(){
    this.fontSizeOffset = PreferencesUtil.getChangeFontSize();//获取字体大小偏移量
    setTimeout(()=>{
      router.replaceUrl({
        url: 'pages/MainIndex'
      });
    },1000);
  }
}