import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Context } from '@kit.AbilityKit';

const KEY_APP_FONT_SIZE = 'appFontSize';
const KEY_DISPLAY_ALL='displayAll'
const KEY_DISPLAY_COMPLETED='displayCompleted'
const TAG = 'PreferencesUtil';

/**
 * The PreferencesUtil provides preferences of create, save and query.
 */
export class PreferencesUtil {
  preference?: preferences.Preferences;

  /**
   *The method of creating a preferences Instance.
   */
  getFontPreferences(context: Context) {
    this.preference = preferences.getPreferencesSync(context, { name: 'FontPreferences' });
    hilog.info(0x0000, TAG, 'create success');
  }
  getAllPreferences(context:Context){
    this.preference = preferences.getPreferencesSync(context, { name: 'AllPreferences' });
  }
  getCompletedPreferences(context:Context){
    this.preference = preferences.getPreferencesSync(context, { name: 'CompletedPreferences' });
  }

  /**
   *The method of saving fontsize offset change.
   */
  saveChangeFontSize(fontSizeOffset: number) {
    this.preference?.putSync(KEY_APP_FONT_SIZE, fontSizeOffset);
    this.preference?.flush(
      (err: BusinessError) => {
        if (err) {
          hilog.error(0x0000, TAG, 'Failed to flush. code =' + err.code + ',' +
            ' message =' + err.message);
          return;
        }
        hilog.info(0x0000, TAG, 'Succeeded in flushing.');
      });
  }
  saveChangeDisplayAll(isAll:boolean){
    this.preference?.putSync(KEY_DISPLAY_ALL, isAll);
    this.preference?.flush();
  }
  saveChangeDisplayCompleted(isCompleted:boolean){
    this.preference?.putSync(KEY_DISPLAY_COMPLETED, isCompleted);
    this.preference?.flush();
  }

  /**
   *The method of getting fontsize offset.
   */
  getChangeFontSize() {
    let fontSizeOffset: number = 0;
    fontSizeOffset = this.preference?.getSync(KEY_APP_FONT_SIZE, 0) as number;
    return fontSizeOffset;
  }
  getChangeDisplayAll(){
    let isAll:boolean=false;
    isAll=this.preference?.getSync(KEY_DISPLAY_ALL, false) as boolean;
    return isAll;
  }
  getChangeDisplayCompleted(){
    let isShow:boolean=false;
    isShow=this.preference?.getSync(KEY_DISPLAY_COMPLETED, false) as boolean;
    return isShow;
  }
}

export default new PreferencesUtil();