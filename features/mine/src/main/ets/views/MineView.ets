import { AppSafeArea, AppUserCenter, NavigationColumnComponent, PAGE_PATH, RecommendComponent } from "basic"
import { AppStorageV2, PersistenceV2 } from "@kit.ArkUI"
import { HMRouterMgr } from "@hadss/hmrouter"

@ComponentV2
export struct MineView {
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象
  appUserCenter?: AppUserCenter = PersistenceV2.connect(AppUserCenter, () => new AppUserCenter()) // 用户信息
  build() {
    Column() {
      Scroll() {
        Column() {
          this.HeaderView()
          this.NavigationItem()
          // this.GuessView()
          RecommendComponent()
        }
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('[basic].color.under'))
  }

  @Builder HeaderView() {
    Column() {
      Row() {
        Blank()
        if (!!(this.appUserCenter?.user.token && this.appUserCenter?.user.account)) {
          Image($r('[basic].media.ic_public_settings'))
            .width(24)
            .aspectRatio(1)
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: PAGE_PATH.SETTING_PAGE
              })
            })
        }
      }
      .width('100%')
      .height(50)

      Row({ space: 16 }) {
        if (!!this.appUserCenter?.user.token) {
          Image(this.appUserCenter?.user.avatar ?? $r('app.media.ic_user_avatar'))
            .width(40)
            .aspectRatio(1)
            .borderRadius(20)
          Text(this.appUserCenter?.user.nickname ?? 'null')
            .fontColor($r('[basic].color.black'))
            .fontWeight(500)
        } else {
          Text('立即登录')
            .fontColor($r('[basic].color.black'))
            .fontWeight(500)
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: PAGE_PATH.LOGIN_PAGE
              })
            })
        }
      }
      .width('100%')
      .height(72)

      Row({ space: 8 }) {
        Image($r('app.media.ic_user_vip'))
          .width(24)
          .aspectRatio(1)
        Text('升级喵街商城会员，尊享包郵特權')
          .fontSize(12)
          .fontColor('#7E2C1A')
          .layoutWeight(1)
        Button('立即开通')
          .width(64)
          .height(24)
          .fontSize(10)
          .padding(0)
          .backgroundColor('#7E2C1A')
      }
      .padding({ left: 8, right: 8 })
      .width('100%')
      .height(40)
      .borderRadius({ topLeft: 10, topRight: 10 })
      .linearGradient({
        angle: 110,
        colors: [['#F9D8AB', 0], ['#F9E3CC', 1]]
      })

    }
    .padding({ left: 16, right: 16, top: this.safeAreaObject?.topHeight })
    .linearGradient({
      angle: 180,
      colors: [['#FFF1E5', 0], [$r('[basic].color.under'), 1]]
    })
  }

  @Builder NavigationItem() {
    Column({ space: 8 }) {
      GridRow({ columns: 3 }) {
        GridCol() {
          NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_collect'), label: '我的收藏', labelColor: $r('[basic].color.text') })
        }
        GridCol() {
          NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_history'), label: '我的足迹', labelColor: $r('[basic].color.text') }).onClick(() => {})
        }
        GridCol() {
          NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_service'), label: '我的客服', labelColor: $r('[basic].color.text') })
        }
      }
      .width('100%')
      .linearGradient({
        angle: 180,
        colors: [['#FFF1E5', 0], [$r('[basic].color.white'), 0.15], [$r('[basic].color.white'), 1]]
      })
      .borderRadius(10)

      Column() {
        Text('我的订单')
          .fontSize(14)
          .width('100%')
          .padding({ left: 8, top: 8 })
          .lineHeight(22)
          .fontWeight(500)
          .fontColor($r('[basic].color.black'))
        GridRow({ columns: 5 }) {
          GridCol() {
            NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_order'), label: '全部订单' }).onClick(() => {})
          }
          GridCol() {
            NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_obligation'), label: '待付款' }).onClick(() => {})
          }
          GridCol() {
            NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_unreceived'), label: '待发货' }).onClick(() => {})
          }
          GridCol() {
            NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_unshipped'), label: '待收货' }).onClick(() => {})
          }

          GridCol() {
            NavigationColumnComponent({ itemIcon: $r('app.media.ic_user_unevaluated'), label: '待评价' }).onClick(() => {})
          }
        }
        .width('100%')
      }
      .backgroundColor($r('[basic].color.white'))
      .borderRadius(10)
    }
    .padding({ left: 8, right: 8 })
  }
}