import { AppBreakPoint, AppSafeArea, AppSharedData, BreakPointEnum, BreakPointType, CategoryItem, Constants, GoodsItem, LazyForEachDataSource, LoadingComponent, LoadingProgressComponent, PAGE_PATH, SoundPoolPlayer} from "basic";
import { DiscountGoods, Goods } from "../components";
import { Banner, Params, DiscountType } from "../models";
import { AppStorageV2, promptAction } from "@kit.ArkUI";
import { getBannerApi, getCategoryApi, getHomePageNewApi, getHotRecommendApi, getInVogueApi, getOneStopApi, getRecommendApi} from "../apis";
import { HMRouterMgr } from "@hadss/hmrouter";

@ComponentV2
export struct HomePageView {
  @Local banners: Banner[] = [] // 轮播图
  @Local categories: CategoryItem[] = [] // 分类
  @Local saleGoods: GoodsItem[] = [] // 特惠推荐
  @Local hotGoods: GoodsItem[] = [] // 爆款推荐
  @Local oneGoods: GoodsItem[] = [] // 一站买全
  @Local newGoods: GoodsItem[] = [] // 新鲜好物
  @Local recommendGoods: GoodsItem[] = [] // 猜喜
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())! // 断点对象
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())! // 安全区避让对象
  @Local offsetY: number = 0 // 页面滚动距离
  @Local searchOpacity: number = 0 // 搜索框的透明度
  @Local recommendPage: number = 1 // 请求猜喜的页码
  @Local isReachLoad: boolean = false // 是否已经请求完成
  @Local isFinished: boolean = false // 是否已经没有数据了
  recommendDataSource: LazyForEachDataSource<GoodsItem> = new LazyForEachDataSource() // 实例化猜喜LazyForEach数据源
  @Local loadingView: boolean = false // 页面正在加载中
  @Local isRefreshing: boolean = false // 是否正在刷新
  @Local refreshStatus: RefreshStatus = RefreshStatus.Inactive // 记录当前下拉的状态

  /**
   * 获取接口数据
   */
  async getHomePageData(firstLoading?: boolean) {
    this.loadingView = !!firstLoading // 显示loading
    /** 获取到数据一次性渲染 创建一个微队列 无论成功还是失败 等待所有执行完毕 **/
    const homePageData = await Promise.allSettled([getBannerApi(), getCategoryApi(), getHotRecommendApi(), getInVogueApi(), getOneStopApi(), getHomePageNewApi()])
    if (homePageData[0].status == "fulfilled") {
      this.banners = homePageData[0].value
    }
    if (homePageData[1].status == "fulfilled") {
      this.categories = homePageData[1].value
      const appSharedData = AppStorageV2.connect(AppSharedData, () => new AppSharedData())!
      appSharedData.category = homePageData[1].value // 将获取到的分类数据送给随机存取存储器
    }
    if (homePageData[2].status == "fulfilled") {
      this.saleGoods = homePageData[2].value?.subTypes?.[0]?.goodsItems?.items ?? []
    }
    if (homePageData[3].status == "fulfilled") {
      this.hotGoods = homePageData[3].value?.subTypes?.[0]?.goodsItems?.items ?? []
    }
    if (homePageData[4].status == "fulfilled") {
      this.oneGoods = homePageData[4].value?.subTypes?.[0]?.goodsItems?.items ?? []
    }
    if (homePageData[5].status === "fulfilled") {
      this.newGoods = homePageData[5].value
    }
    this.loadingView = false // 加载完毕 隐藏loading
  }

  /**
   * 获取猜喜数据
   */
  async getRecommendData() {
    const recommendList = await getRecommendApi({ limit: 8 * this.recommendPage })
    if (recommendList.length == this.recommendPage * 8) {
      // 内容没有结束 还可以加载下一页
      this.recommendPage++
    } else {
      this.isFinished = true // 加载完成了
      promptAction.showToast({ message: '没有下一页了' })
    }
    this.recommendDataSource.loadDataSource(recommendList) // 重新赋值
  }

  aboutToAppear(): void {
    this.getHomePageData(true) // 请求接口数据
    this.getRecommendData()
  }

  build() {
    RelativeContainer() {
      if (this.loadingView) {
        LoadingComponent()
      } else {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshHeader }) {
          Column() {
            Scroll() {
              Column() {
                // 轮播图+搜索
                Stack({ alignContent: Alignment.Top }) {
                  Swiper() {
                    ForEach(this.banners, (item: Banner) => {
                      Image(item.imgUrl).draggable(false)
                    })
                  }
                  .displayCount(new BreakPointType({
                    sm: 1,
                    md: 2,
                    lg: 3
                  }).getValue(this.breakObject.breakPoint)) // 设置Swiper视窗内元素显示个数
                  .itemSpace(new BreakPointType({
                    sm: 0,
                    md: 10,
                    lg: 20
                  }).getValue(this.breakObject.breakPoint)) // 轮播图视窗内元素间距
                  .indicator(
                    this.breakObject.breakPoint == BreakPointEnum.SM ? DotIndicator.dot()
                      .itemWidth(8)
                      .itemHeight(4)
                      .color('#33191919')
                      .selectedItemWidth(24)
                      .selectedItemHeight(4)
                      .selectedColor('#191919') : false
                  ) // 轮播图指示器

                  Row() {
                    Row({ space: 4 }) {
                      Image($r('[basic].media.ic_public_search'))
                        .draggable(false)
                        .width(16)
                        .height(16)
                        .fillColor($r('[basic].color.white'))
                      Text('搜索...')
                        .fontSize(14)
                        .fontColor($r('[basic].color.white'))
                    }
                    .backgroundColor('#33191919')
                    .width('100%')
                    .height(40)
                    .borderRadius(20)
                    .padding({ left: 12 })
                    .onClick(() => HMRouterMgr.push({ pageUrl: PAGE_PATH.SEARCH_PAGE }))
                  }
                  .padding({ left: 16, right: 16, top: this.safeAreaObject.topHeight })
                }
                .width('100%')


                // 分类
                Column({ space: 10 }) {
                  // 分类
                  List({ space: new BreakPointType({
                    sm: 14,
                    md: 36,
                    lg: 72
                  }).getValue(this.breakObject.breakPoint) }) {
                    ForEach(this.categories, (item: CategoryItem) => {
                      ListItem() {
                        Column() {
                          Image(item.picture)
                            .draggable(false)
                            .width(56)
                            .aspectRatio(1)
                          Text(item.name)
                            .fontSize(10)
                            .fontColor('#CC191919')
                        }
                        .width(60)
                        .height(80)
                        .borderRadius(30)

                        .clip(true)
                        .backgroundImage(item.picture)
                        .backgroundImageSize(ImageSize.Contain)
                        .backgroundImagePosition(Alignment.Center)
                        .backgroundBlurStyle(
                          BlurStyle.BACKGROUND_ULTRA_THICK,
                          { scale: 0.25 }
                        )
                      }
                    })
                  }
                  .width('100%')
                  .height(92)
                  .scrollBar(BarState.Off)
                  .listDirection(Axis.Horizontal)
                  .alignListItem(ListItemAlign.Center)

                  // 特惠推荐
                  Column({ space: 10 }) {
                    Image($r('app.media.home_cmd_title'))
                      .draggable(false)
                      .width(150)
                      .height(20)
                    Row() {
                      Image($r('app.media.home_cmd_inner'))
                        .draggable(false)
                        .width(86)
                        .height(116)
                      List({ space: 10 }) {
                        ForEach(this.saleGoods, (item: GoodsItem) => {
                          ListItem() {
                            DiscountGoods({ goodsItem: item })
                          }
                        })
                      }
                      .layoutWeight(1)
                      .width('100%')
                      .height(116)
                      .backgroundColor($r('[basic].color.white'))
                      .borderRadius({
                        topRight: 8,
                        bottomRight: 8
                      })
                      .padding({ right: 10, left: 10 })
                      .scrollBar(BarState.Off)
                      .listDirection(Axis.Horizontal)
                    }
                  }
                  .width('100%')
                  .height(166)
                  .backgroundImage($r('app.media.home_cmd_sm'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(8)
                  .padding(10)
                  .alignItems(HorizontalAlign.Start)

                  // 爆款推荐+一站买全
                  Row({ space: 10 }) {
                    this.DiscountBuilder({
                      title: '爆款推荐',
                      subTitle: '最受欢迎',
                      bg: '#EDF1FB',
                      list: this.hotGoods
                    })
                    this.DiscountBuilder({
                      title: '一站买全',
                      subTitle: '精心优选',
                      bg: '#FCF6EA',
                      list: this.oneGoods
                    })
                  }

                  // 新鲜好物
                  Column({ space: new BreakPointType({
                    sm: 14,
                    md: 36,
                    lg: 72
                  }).getValue(this.breakObject.breakPoint) }) {
                    Image($r('app.media.home_new'))
                      .draggable(false)
                      .width(146)
                      .height(19)
                    List({ space: 10 }) {
                      ForEach(this.newGoods, (item: GoodsItem) => {
                        ListItem() {
                          DiscountGoods({ type: DiscountType.NEW, goodsItem: item })
                        }
                      })
                    }
                    .width('100%')
                    .height(116)
                    .scrollBar(BarState.Off)
                    .listDirection(Axis.Horizontal)
                  }
                  .width('100%')
                  .height(156)
                  .padding(10)
                  .backgroundColor('#F7EFF5')
                  .borderRadius(8)
                  .alignItems(HorizontalAlign.Start)

                  // 猜喜
                  WaterFlow() {
                    // ForEach(this.recommendGoods, (item: GoodsItem) => {
                    LazyForEach(this.recommendDataSource, (item: GoodsItem) => {
                      FlowItem() {
                        Goods({ goodsItem: item })
                      }
                    })
                  }
                  .columnsTemplate('1fr 1fr')
                  .columnsGap(8)
                  .rowsGap(10)
                }
                .padding({
                  left: 8,
                  right: 8,
                  bottom: 10,
                  top: 10
                })
              }
            }
            .scrollBar(BarState.Off)
            .onDidScroll((_: number, offsetY: number) => {
              this.offsetY += offsetY // 计算总共往上移动的距离
              if (this.offsetY < this.safeAreaObject.topHeight) {
                this.searchOpacity = 0
                // 40搜索框的高度
              } else if (this.offsetY > this.safeAreaObject.topHeight && this.offsetY < (this.safeAreaObject.topHeight + 40)) {
                this.searchOpacity = (this.offsetY - this.safeAreaObject.topHeight) / 40
              } else {
                this.searchOpacity = 1
              }
            })
            .onReachEnd(async () => {
              if (!this.isReachLoad && !this.isFinished) {
                // 此时认为没有请求且还有数据
                this.isReachLoad = true // 避免在请求中继续请求
                await this.getRecommendData() // 等待请求数据
                this.isReachLoad = false // 请求完成 便于下次请求
              }
            })
            // 搜索框元素
            Row() {
              Row({ space: 4 }) {
                Image($r('[basic].media.ic_public_search'))
                  .draggable(false)
                  .width(16)
                  .height(16)
                  .fillColor($r('[basic].color.white'))
                Text('搜索...')
                  .fontSize(14)
                  .fontColor($r('[basic].color.white'))
              }
              .backgroundColor('#33999797')
              .width('100%')
              .height(40)
              .borderRadius(20)
              .padding({ left: 12 })
            }
            .opacity(this.searchOpacity)
            .padding({
              left: 16,
              right: 16,
              top: this.safeAreaObject.topHeight,
              bottom: this.safeAreaObject.topHeight,
            })
            .linearGradient({
              direction: GradientDirection.Bottom,
              colors: [["#ff949dec", 0], ["#fff", 1]]
            })
          }
        }
        .onStateChange(async (state) => {
          this.refreshStatus = state
          if (this.refreshStatus == RefreshStatus.Refresh) {
            // 此时完成下拉刷新
            await this.onRefresh()
            this.isRefreshing = false
            SoundPoolPlayer.getInstance().play(Constants.TIP_SOUND) // 刷新完成播放提示音
          }
        })
      }
    }
  }

  @Builder DiscountBuilder(params: Params) {
    Column() {
      Row({ space: 10 }) {
        Text(params.title)
          .fontColor($r('[basic].color.black'))
          .fontSize(14)
        Text(params.subTitle)
          .fontColor($r('[basic].color.text'))
          .fontSize(11)
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: 10 }) {
        ForEach(params.list, (item: GoodsItem) => {
          ListItem() {
            DiscountGoods({ type: DiscountType.DISCOUNT, goodsItem: item })
          }
        })
      }
      .width('100%')
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .height(160)
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(params.bg)
    .borderRadius(8)
  }

  @Builder refreshHeader() {
    Row({ space: 10 }) {
      Text(this.DisplayText).fontSize(12)
      LoadingProgressComponent({ progressWidth: 20, strokeWidth: 2 })
    }
    .width("100%")
    .height(180)
    .justifyContent(FlexAlign.Center)
  }

  @Computed get DisplayText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return "下拉刷新"
      case RefreshStatus.OverDrag:
        return "松手刷新"
      case RefreshStatus.Refresh:
        return "刷新中"
      case RefreshStatus.Done:
        return "刷新完成"
      default:
        return ""
    }
  }

  async onRefresh() {
    this.recommendPage = 1
    this.isFinished = false // 回归到开始阶段
    await this.getHomePageData()
    await this.getRecommendData()
  }
}