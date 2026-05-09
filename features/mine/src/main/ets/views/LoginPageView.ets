import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { NavigationBar, PAGE_PATH } from "basic";
import { promptAction } from "@kit.ArkUI";

@HMRouter({ pageUrl: PAGE_PATH.LOGIN_PAGE })
@ComponentV2
export struct LoginPageView {
  @Local accountId: string = 'admin'
  @Local password: string = 'admin'
  @Local agreeChick: boolean = false // 同意按鈕檢查

  @Styles form() {
    .width('100%')
    .height(42)
    .padding({
      left: 16,
      right: 16,
      top: 0,
      bottom: 0
    })
  }

  build() {
    Column() {
      NavigationBar({
        title: 'LoginPage',
        showLeftIcon: true,
        onLeftClick: () => {
          HMRouterMgr.pop()
        }
      })

      Column({ space: 16 }) {
        Text('账号密码登录')
          .fontSize(18)
          .fontColor($r('[basic].color.black'))
          .width('100%')
          .fontWeight(500)
          .margin({ bottom: 10 })
        TextInput({ placeholder: '请输入账号', text: $$this.accountId })
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .form()
        TextInput({ placeholder: '请输入密码', text: $$this.password })
          .type(InputType.Password)
          .showPasswordIcon(false)
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .form()

        Row({ space: 4 }) {
          Checkbox()
            .select($$this.agreeChick)
            .width(12)
            .aspectRatio(1)
            .selectedColor($r('[basic].color.black'))
            .mark({ size: 10, strokeWidth: 1 })
          Text() {
            Span('查看并同意')
            Span('《隐私条款》')
              .fontColor('#007DFB')
            Span('和')
            Span('《用户协议》')
              .fontColor('#007DFB')
          }
          .width('100%')
          .fontSize(12)
          .fontColor($r('[basic].color.gray'))
        }

        Button('登录')
          .enabled(!!this.agreeChick ?? false)
          .fontColor($r('[basic].color.white'))
          .form()
          .backgroundColor($r("[basic].color.black"))
          .onClick(() => {})

        Row() {
          Blank()
          Text('忘记密码')
            .fontColor('#007DFB')
            .fontSize(12)
        }
        .width('100%')

        Column({ space: 16 }) {
          Stack() {
            Text()
              .width(200)
              .height(1)
              .backgroundColor($r('[basic].color.under'))
            Text('其他登录方式')
              .width(100)
              .fontSize(12)
              .backgroundColor($r('[basic].color.white'))
              .fontColor($r('[basic].color.text'))
              .textAlign(TextAlign.Center)
          }

          Row() {
            // 华为登录 數字身份證 QQ微信登錄
          }
        }
        .margin({ top: 200 })
      }
      .padding(30)
    }
    .width('100%')
    .height('100%')
  }
}