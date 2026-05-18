import {AppUserCenter, CellComponent, CellGroupComponent, CustomDialogHelper, HuaweiAuthManager, NavigationBar, PAGE_PATH,
  ShoppingCartAuth,
  UserInformation } from "basic";
import { PersistenceV2 } from "@kit.ArkUI";
import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";

@HMRouter({ pageUrl: PAGE_PATH.SETTING_PAGE })
@ComponentV2
export struct SettingPageView {
  appUserCenter?: AppUserCenter = PersistenceV2.connect(AppUserCenter, () => new AppUserCenter()) // 用户信息

  build() {
    Column() {
      NavigationBar({
        title: '设置',
        onLeftClick: () => HMRouterMgr.pop() // 点击返回
      })
      Column({ space: 8 }) {
        // 個人信息區域
        CellGroupComponent() {
          this.getProfileBuilder()
        }
        Blank()
        CellGroupComponent() {
          CellComponent({
            leftLabel: '收货地址管理', onRightClick: () => {
              HMRouterMgr.push({
                pageUrl: PAGE_PATH.ADDRESS_PAGE
              })
            }
          })
          CellComponent({ leftLabel: '账号安全' })
          CellComponent({ leftLabel: '消息设置' })
          CellComponent({ leftLabel: '隐私设置' })
          CellComponent({ leftLabel: '通用设置' })
        }
        Blank()

        Row() {
          Text("退出登录").fontColor($r("[basic].color.red"))
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .height(50)
        .gesture(
          TapGesture()
            .onAction(() => {
              CustomDialogHelper.getInstance().showConfirmDialog({
                message: '您确认要退出登录吗?',
                onRightClick: () => {
                  if (!!this.appUserCenter) {
                    this.appUserCenter.user.token = ""
                    this.appUserCenter.user.avatar = ""
                    HuaweiAuthManager.getInstance().exitAuth() // 退出华为登录
                    ShoppingCartAuth.getInstance().updateCartCount() // 登出时更新购物车数量
                    HMRouterMgr.pop()
                  }
                }
              })
            })
        )
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('[basic].color.under'))
  }

  @Builder getProfileBuilder() {
    RelativeContainer() {
      Image($r("[basic].media.ic_public_right"))
        .fillColor($r("[basic].color.gray"))
        .width(30)
        .aspectRatio(1)
        .alignRules({
          center: {
            anchor: '__container__',
            align: VerticalAlign.Center
          },
          right: {
            anchor: '__container__',
            align: HorizontalAlign.End
          }
        })
        .onClick(() => {
          HMRouterMgr.push({
            pageUrl: PAGE_PATH.USER_CENTER_PAGE
          })
        })

      Image(this.appUserCenter?.user.avatar ?? $r("app.media.ic_user_avatar"))
        .alt($r("app.media.ic_user_avatar"))
        .width(50)
        .aspectRatio(1)
        .borderRadius(25)
        .alignRules({
          center: {
            anchor: '__container__',
            align: VerticalAlign.Center
          }
        })
        .id("avatar")
      Column({ space: 4 }) {
        Text(this.appUserCenter?.user.nickname ?? this.appUserCenter?.user.account)
          .fontColor($r('[basic].color.black'))
          .fontWeight(500)
        Text('账号：' + this.appUserCenter?.user.account)
          .fontColor($r('[basic].color.gray'))
          .fontSize(12)
      }
      .alignRules({
        center: {
          anchor: '__container__',
          align: VerticalAlign.Center
        },
        left: {
          anchor: 'avatar',
          align: HorizontalAlign.End
        }
      })
      .alignItems(HorizontalAlign.Start)
      .margin({
        left: 10
      })
    }
    .constraintSize({
      maxHeight: 100
    })
    .padding({ top: 16, bottom: 16 })
  }
}