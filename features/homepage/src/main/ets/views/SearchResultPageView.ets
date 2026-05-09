import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppBreakPoint, AppSafeArea, BreakPointType, Goods, GoodsItem, LazyForEachDataSource, PAGE_PATH, SearchParams, SearchRouterParam, SortComponentOptions, SortField, SortMethod} from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { SearchSortItem } from "../components";
import { getSearchResultApi } from "../apis";

@HMRouter({ pageUrl: PAGE_PATH.SEARCH_RESULT_PAGE })
@ComponentV2
export struct SearchResultPageView {
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())! // 断点对象
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())! // 安全区避让对象
  searchDataSource: LazyForEachDataSource<GoodsItem> = new LazyForEachDataSource() // 查询数据源
  searchParams: SearchParams = new SearchParams() // 查询参数
  sortList: SortComponentOptions[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  scroller = new Scroller() // 滚动控制器
  @Local searchResultList: GoodsItem[] = []
  @Local loadingData: boolean = false // 正在加载数据
  @Local loadFinished: boolean = false // 是否加载完成

  aboutToAppear(): void {
    const params = HMRouterMgr.getCurrentParam() as SearchRouterParam
    this.searchParams.keyword = params.keyword
    this.getSearchResult()
  }

  /**
   * 获取搜索结果
   */
  async getSearchResult() {
    const result = await getSearchResultApi(this.searchParams)
    this.searchResultList.push(...result.pageData.items)
    if (this.searchParams.page >= result.pageData.pages) {
      this.loadFinished = true // 此时认为已经加载完成 没有更多内容了
    } else {
      this.searchParams.page++ // 请求下一页数据
    }
  }

  /**
   * 重刷数据
   */
  refreshData() {
    this.searchParams.page = 1
    this.searchResultList = [] // 置空便于刷新数据
    this.loadFinished = false
    this.getSearchResult()
  }

  build() {
    Column() {
      // SearchBox({ keyword: this.searchParams?.keyword, onSearchSubmit: (value: string): void => this.refreshData()})
      Row() {
        Image($r('[basic].media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('[basic].color.white'))
          .margin(13)
          .onClick(() => {
            HMRouterMgr.pop()
          })
        Search({ placeholder: '请输入商品关键字', value: $$this.searchParams.keyword })
          .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .backgroundColor($r('[basic].color.white'))
          .textFont({ size: 14 })
          .layoutWeight(1)
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('[basic].color.red') })
          .onSubmit(() => {
            this.searchParams.page = 1
            this.searchResultList = [] // 重新赋值为空
            this.loadFinished = false
            this.getSearchResult()
          })
      }
      .padding({ top: this.safeAreaObject.topHeight, right: 16 })
      .linearGradient({
        angle: 135,
        colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
      })

      // list
      Row() {
        ForEach(this.sortList, (item: SortComponentOptions) => {
          SearchSortItem({
            label: item.label,
            field: item.field,
            sortField: this.searchParams.sortField,
            sortMethod: this.searchParams.sortMethod,
            onSortChange: (field: SortField, method: SortMethod) => {
              this.searchParams.sortField = field // 相当于重新加载数据 排序字段
              this.searchParams.sortMethod = method // 排序方式
              this.refreshData()
            }
          })
        })
        Text('筛选').fontSize(14).fontColor($r('[basic].color.gray'))
      }
      .padding({ left: 16, right: 16 })
      .height(50)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: { bottom: 0.5 }, color: $r('[basic].color.border') })

      // item
      WaterFlow({ scroller: this.scroller, footer: this.getFootBuilder() }) {
        // LazyForEach(this.searchDataSource, (item: GoodsItem) => {
        //   FlowItem() {
        //     Goods({ goodsItem: item, smallImage: true })
        //   }
        // })
        Repeat<GoodsItem>(this.searchResultList).each((object: RepeatItem<GoodsItem>) => {
          FlowItem() {
            Goods({ goodsItem: object.item, smallImage: true })
          }
        })
          .virtualScroll() // 开启虚拟化
          .key((item: GoodsItem, index: number) => `${index}_${JSON.stringify(item)}`)
      }
      .columnsTemplate(
        new BreakPointType({
          sm: '1fr 1fr',
          md: '1fr 1fr 1fr',
          lg: '1fr 1fr 1fr 1fr'
        }).getValue(this.breakObject.breakPoint))
      .columnsGap(0.5)
      .rowsGap(0.5)
      .layoutWeight(1)
      .onReachEnd(async () => {
        // 触底加载更多
        if (!this.loadingData && !this.loadFinished) {
          this.loadingData = true
          await this.getSearchResult()
          this.loadingData = false // 通过阀门控制避免在加载中继续请求
        }
      })
    }
  }

  @Builder getFootBuilder() {
    Row({ space: 10 }) {
      if (this.loadingData) {
        Text("正在加载中...")
          .fontSize(12)
          .fontColor($r("[basic].color.gray"))
        LoadingProgress()
          .width(20)
          .aspectRatio(1)
      } else {
        if (this.loadFinished) {
          Text("加载完成，暂无更多内容")
            .fontSize(12)
            .fontColor($r("[basic].color.gray"))
        }
      }
    }
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height(50)
    .padding({
      bottom: this.safeAreaObject.bottomHeight
    })
  }
}