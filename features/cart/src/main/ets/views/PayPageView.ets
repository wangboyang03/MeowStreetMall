import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, Constants, NavigationBar, PAGE_PATH } from "basic";
import { webview } from "@kit.ArkWeb";
import { AppStorageV2 } from "@kit.ArkUI";

@HMRouter({ pageUrl: PAGE_PATH.PAY_PAGE_NESTED_H5 })
@ComponentV2
export struct PayPageView {
  controller: webview.WebviewController = new webview.WebviewController() // ArkTS嵌套H5控制器
  @Local orderId: string = "" // 通过路由传参的订单id
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  aboutToAppear(): void {
    this.orderId = HMRouterMgr.getCurrentParam() as string
  }

  build() {
    Column() {
      NavigationBar({
        title: "支付页"
      })
      Web({
        src: `${Constants.BASE_URL}/pay/wap/aliPay?orderId=${this.orderId}`,
        controller: this.controller,
      })
        .width("100%")
        .height("100%")
        .padding({
          top: this.safeAreaObject?.topHeight
        })
    }
  }
}