import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, CardPushManager, CustomDialogHelper, GoodsItem, NavigationBar, PAGE_PATH } from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { getHotRecommendApi } from "../apis/homepage";
import { emitter } from "@kit.BasicServicesKit";

@HMRouter({ pageUrl: PAGE_PATH.RECOMMEND_PAGE })
@ComponentV2
export struct RecommendPageView {
  @Local list: GoodsItem[] = []
  @Local loading: boolean = false
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  /**
   * 获取推荐数据
   */
  async getRecommendData() {
    const loading = CustomDialogHelper.getInstance().showLoading({ title: '加载中' })
    const res = await getHotRecommendApi()
    this.list = res.subTypes?.[0]?.goodsItems?.items ?? []
    loading()
  }

  aboutToAppear() {
    this.getRecommendData()
    emitter.on("updateRecommend", async () => {
      await this.getRecommendData()
      CardPushManager.getInstance().pushImageList(this.list.map(item => item.picture as string).slice(0,3))

    })
  }

  build() {
    RelativeContainer() {
      NavigationBar({
        bgColor: 'transparent',
        onLeftClick: () => HMRouterMgr.pop()
      })

      Column() {
        Swiper() {
          Repeat(this.list).each((obj: RepeatItem<GoodsItem>) => {
            Column({ space: 20 }) {
              Image(obj.item.picture)
                .width("100%")
                .layoutWeight(1)
              Text() {
                Span("¥" + ' ')
                Span(obj.item.price)
              }
              .fontWeight(FontWeight.Bold)
              .fontSize(18)

            }
            .width("100%")
            .height("100%")
          })
        }
        .indicator(false)
      }
      .borderRadius(10)
      .height(400)
      .width(280)
      .padding(20)
      .backgroundColor($r("[basic].color.white"))
      .alignRules({
        center: {
          anchor: '__container__',
          align: VerticalAlign.Center
        },
        middle: {
          anchor: '__container__',
          align: HorizontalAlign.Center
        }
      })

      Row() {
        Text("换一张看看").fontColor($r("[basic].color.white"))
      }
      .backgroundColor($r("[basic].color.teal"))
      .justifyContent(FlexAlign.Center)
      .height(50)
      .width("100%")
      .alignRules({
        bottom: {
          anchor: '__container__',
          align: VerticalAlign.Bottom
        }
      })
      .onClick(async () => {
        if (!this.loading) {
          this.loading = true
          await this.getRecommendData()
          // 把这个页面的推荐数据图片推给所有的卡片
          CardPushManager.getInstance().pushImageList(this.list.map(item => item.picture as string).slice(0, 3))
          this.loading = false
        }
      })
    }
    .linearGradient({
      colors: [[$r('[basic].color.white'), 0], [$r('[basic].color.teal'), 1]],
      direction: GradientDirection.Top
    })
    .width("100%")
    .height("100%")
    .padding({
      bottom: this.safeAreaObject?.bottomHeight
    })
  }
}