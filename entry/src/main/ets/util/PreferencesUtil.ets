import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const KEY_APP_FONT_SIZE = 'appFontSize';
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

  /**
   *The method of getting fontsize offset.
   */
  getChangeFontSize() {
    let fontSizeOffset: number = 0;
    fontSizeOffset = this.preference?.getSync(KEY_APP_FONT_SIZE, 0) as number;
    return fontSizeOffset;
  }

}

export default new PreferencesUtil();