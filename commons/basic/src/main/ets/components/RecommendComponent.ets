import { AppBreakPoint, AppSafeArea, BreakPointType, GoodsItem, GuessParams } from "../models";
import { AppStorageV2 } from "@kit.ArkUI";
import { getGlobalRecommendApi } from "../apis";
import { LoadingProgressComponent } from "./LoadingProgressComponent";
import { Goods } from "./Goods";

@ComponentV2
export struct RecommendComponent {
  @Local list: GoodsItem[] = []
  @Local loadingData: boolean = false
  @Local loadFinished: boolean = false
  params: GuessParams = {
    page: 1,
    pageSize: 10
  }
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())! // 断点对象
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())! // 安全区避让对象

  aboutToAppear(): void {
    this.getGuessList()
  }

  /**
   * 獲取猜喜列表
   */
  async getGuessList() {
    const result = await getGlobalRecommendApi(this.params)
    this.list.push(...result.items)
    if (result.pages <= this.params.page) {
      this.loadFinished = true
    } else {
      this.params.page++
    }
  }

  build() {
    Column() {
      WaterFlow({ footer: this.getFootBuilder() }) {
        Repeat(this.list).each((object: RepeatItem<GoodsItem>) => {
          FlowItem() {
            Goods({ goodsItem: object.item })
          }
        })
          .virtualScroll()
          .key((item: GoodsItem, index: number) => `${index}_${JSON.stringify(item)}`)
      }
      .columnsTemplate(
        new BreakPointType({
          sm: '1fr 1fr',
          md: '1fr 1fr 1fr',
          lg: '1fr 1fr 1fr 1fr'
        }).getValue(this.breakObject.breakPoint)
      )
      .columnsGap(10)
      .rowsGap(10)
      .padding(10)
      .onReachEnd(async () => {
        if (!this.loadingData && !this.loadFinished) {
          this.loadingData = true
          await this.getGuessList()
          this.loadingData = false
        }
      })
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
    }
    .width("100%")
    .height("100%")
  }

  @Builder getFootBuilder() {
    Row({ space: 10 }) {
      if (this.loadingData) {
        Text("正在加载中...")
          .fontColor($r("app.color.gray"))
          .fontSize(12)
        LoadingProgressComponent({
          progressWidth: 20,
          strokeWidth: 3
        })
      } else {
        if (this.loadFinished) {
          Text("加載完成，暫無更多内容")
            .fontColor($r("app.color.gray"))
            .fontSize(12)
        }
      }
    }
    .width("100%")
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
}