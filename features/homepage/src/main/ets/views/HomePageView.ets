import { AppBreakPoint, AppSafeArea, BreakPointEnum, BreakPointType, CategoryItem, GoodsItem } from "basic";
import { DiscountGoods, Goods } from "../components";
import { Banner, Params, DiscountType } from "../models";
import { AppStorageV2 } from "@kit.ArkUI";
import { getBannerApi, getCategoryApi, getHomePageNewApi, getHotRecommendApi, getInVogueApi,
  getOneStopApi } from "../apis";

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

  /**
   * 获取接口数据
   */
  async getHomePageData() {
    this.banners = await getBannerApi()
    this.categories = await getCategoryApi()
    const result = await getHotRecommendApi()
    this.saleGoods = result.subTypes?.[0]?.goodsItems?.items ?? []
    this.hotGoods = (await getInVogueApi()).subTypes?.[0]?.goodsItems?.items ?? []
    this.oneGoods = (await getOneStopApi()).subTypes?.[0]?.goodsItems?.items ?? []
    this.newGoods = await getHomePageNewApi()
  }

  aboutToAppear(): void {
    this.getHomePageData() // 请求接口数据
  }

  build() {
    Scroll() {
      Column() {
        // 轮播图+搜索
        Stack({ alignContent: Alignment.Top }) {
          Swiper() {
            ForEach(this.banners, (item: Banner) => {
              Image(item.imgUrl)
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
              .width(150)
              .height(20)
            Row() {
              Image($r('app.media.home_cmd_inner'))
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

          // 推荐商品
          WaterFlow() {
            ForEach(this.recommendGoods, (item: GoodsItem) => {
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
}