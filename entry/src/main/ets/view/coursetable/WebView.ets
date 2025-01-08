import { webview } from '@kit.ArkWeb';
@Component
export struct WebView {
  @Consume('web') webs:NavPathStack;
  webController: webview.WebviewController = new webview.WebviewController();
  build() {
    NavDestination(){
      Column() {
        Web({
          src: "https://oauth.shu.edu.cn/login/eyJ0aW1lc3RhbXAiOjE3Mjg2OTQ4MjExODU5MDI5ODAsInJlc3BvbnNlVHlwZSI6ImNvZGUiLCJjbGllbnRJZCI6IkU0MjJPQmsyNjExWTRiVUVPMjFnbTFPRjFSeGtGTFE2Iiwic2NvcGUiOiIxIiwicmVkaXJlY3RVcmkiOiJodHRwczovL2p3eGsuc2h1LmVkdS5jbi94c3hrL29hdXRoL2NhbGxiYWNrIiwic3RhdGUiOiIifQ==",
          controller: this.webController
        })
          .width("100%")
          .height("100%")
      }
      .width("100%")
      .height("100%")
    }
  }
}
@Builder
export function WebViewBuilder(){
  WebView();
}