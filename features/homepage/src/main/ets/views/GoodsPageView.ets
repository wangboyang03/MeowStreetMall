import { HMLifecycleState, HMRouter, HMRouterMgr } from "@hadss/hmrouter"
import { AppSafeArea, CustomDialogHelper, NavigationBar, PAGE_PATH, RecommendComponent, SkuType, Sku, Auth, addShoppingCartApi, ShoppingCartAuth, AppShoppingCart, AppUserCenter} from "basic"
import { Goods, StoreType } from "../models"
import { AppStorageV2, PersistenceV2 } from "@kit.ArkUI"
import { GoodsInformation } from "../components/GoodsInformation"
import { GoodsComment } from "../components/GoodsComment"
import { GoodsDetail } from "../components"
import { getGoodsDetailApi } from "../apis"

@HMRouter({ pageUrl: PAGE_PATH.GOODS_PAGE })
@ComponentV2
export struct GoodsPageView {
  @Local goods: Goods = {} as Goods
  @Local activeIndex: number = 0
  @Local loading: boolean = false
  @Local showSheet: boolean = false
  @Local sku: SkuType = {} as SkuType
  @Local goodsCount: number = 1 // 商品默认数量
  scroller = new Scroller() // 滚动控制器
  tabsList: string[] = ["商品", "评价", "详情", "推荐"]
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象
  appShoppingCart?: AppShoppingCart = AppStorageV2.connect(AppShoppingCart, () => new AppShoppingCart())

  aboutToAppear(): void {
    const goods = HMRouterMgr.getCurrentParam() as Goods
    goods.mainPictures = [goods.picture as string] // 轮播图 有数据
    this.goods = goods
    this.getGoodsDetail()
    // HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onShown, () => AlertDialog.show({ message: '获取数据' }))
  }

  /**
   * 获取商品详情
   */
  async getGoodsDetail() {
    const loadingTips = CustomDialogHelper.getInstance().showLoading({ title: '详情加载中...' })
    this.goods = await getGoodsDetailApi({
      id: this.goods.id
    })
    loadingTips() // 封装CustomDialogHelper时返回值为异步回调函数 调用关闭弹窗
  }

  /**
   * 计算库存数量
   */
  @Computed get showCountType() {
    if (!this.goods.inventory) {
      return {
        text: '沽清',
        color: $r("[basic].color.red"),
        canBuy: false
      } as StoreType
    } else if (this.goods.inventory > 1000) {
      return {
        text: '库存充足',
        color: $r("[basic].color.gray"),
        canBuy: true
      } as StoreType
    } else {
      return {
        text: '库存紧张',
        color: $r("[basic].color.yellow"),
        canBuy: true
      } as StoreType
    }
  }

  /**
   * 添加到购物袋
   */
  async addShoppingCart() {
    const user = Auth.getInstance().getUser()
    if (!!user?.token) {
      if (this.sku.id) {
        const loadingTips = CustomDialogHelper.getInstance().showLoading({
          title: '正在加入中...'
        })
        await addShoppingCartApi({
          skuId: this.sku.id,
          count: this.goodsCount
        }) // 前端没有理由直接带入商品价格
        ShoppingCartAuth.getInstance().updateCartCount() // 更新购物袋数量
        this.showSheet = false
        CustomDialogHelper.getInstance().showToast({
          message: '添加成功'
        })
        loadingTips()
      } else {
        CustomDialogHelper.getInstance().showToast({
          message: '请先选择商品规格'
        })
      }
    } else {
      this.showSheet = false
      CustomDialogHelper.getInstance().showToast({
        message: '请先登录'
      })
      HMRouterMgr.push({
        pageUrl: PAGE_PATH.LOGIN_PAGE
      })
    }
  }


  build() {
    Column() {
      NavigationBar({
        showLeftIcon: true,
        showRightIcon: true,
        customTitle: (): void => this.CustomTitleBuilder(),
        onLeftClick: () => HMRouterMgr.pop()
      })

      Column() {
        List({ scroller: this.scroller }) {
          ListItem() {
            // 商品信息
            GoodsInformation({ goods: this.goods }).geometryTransition(this.goods.id)
          }

          ListItem() {
            // 评论
            GoodsComment({ goods: this.goods })
          }

          ListItem() {
            // 商品详情
            GoodsDetail({ goods: this.goods })
          }

          ListItem() {
            // 猜喜
            RecommendComponent()
          }
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .onScrollIndex((index) => {
          this.activeIndex = index
        })
      }
      .layoutWeight(1)
      .backgroundColor($r('[basic].color.under'))

      Row() {
        Image($r('[basic].media.ic_public_like')).iconButton()
        Image($r('[basic].media.ic_public_comment')).iconButton()
        Badge({
          count: this.appShoppingCart?.count ?? 0,
          style: {},
          position: { x: 30, y: 4 }
        }) {
          Image($r('[basic].media.ic_public_cart'))
            .iconButton()
            .onClick(() => {
              // const user = Auth.getInstance().getUser()
              const user = PersistenceV2.connect(AppUserCenter, () => new AppUserCenter())
              if (!!user?.user.token) {
                HMRouterMgr.push({
                  pageUrl: PAGE_PATH.SHOPPING_CART_PAGE,
                  param: true
                })
              } else {
                CustomDialogHelper.getInstance().showToast({
                  message: '请先登录'
                })
                HMRouterMgr.push({
                  pageUrl: PAGE_PATH.LOGIN_PAGE
                })
              }
            })
        }

        Row() {
          Button('加入购物袋')
            .buyButton($r('[basic].color.black'), true)
            .onClick(() => {
              this.showSheet = true
            })
          Button('立即购买')
            .buyButton($r('[basic].color.red'), false)
            .onClick(async () => {
              this.showSheet = true
            })
        }
        .layoutWeight(1)
        .padding({ right: 16, left: 6 })
      }
      .width('100%')
      .height(54)
      .margin({ bottom: this.safeAreaObject?.topHeight })
    }
    .height('100%')
    .bindSheet($$this.showSheet, this.AddCartBuilder(),
      {
        height: SheetSize.FIT_CONTENT,
        backgroundColor: $r('[basic].color.white'),
        preferType: SheetType.CENTER
      })
  }

  @Builder CustomTitleBuilder() {
    // 楼层切换
    Row() {
      Row({ space: 10 }) {
        Repeat<string>(this.tabsList).each((object: RepeatItem<string>) => {
          Text(object.item)
            .fontColor(this.activeIndex == object.index ? $r("[basic].color.black") : $r("[basic].color.gray"))
            .onClick(() => {
              this.activeIndex = object.index // 默认选中第一个
              this.scroller.scrollToIndex(object.index) // 滚动到指定位置
            })
        })
      }
      Image($r('[basic].media.ic_public_shared')).iconButton()
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .height("100%")
    .padding({
      left: 50,
      right: 50
    })
  }

  @Builder AddCartBuilder() {
    Column() {
      Text(`已选:${this.sku.specsText}`)
        .fontWeight(300)
        .width('100%')
        .fontColor($r('[basic].color.black'))
        .fontSize(14)
        .padding({ bottom: 10, right: 50 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .visibility(this.sku.id ? Visibility.Visible : Visibility.Hidden)
      Row({ space: 10 }) {
        Image(this.sku.picture ?? this.goods.mainPictures?.[0])
          .alt($r('app.media.ic_sku_img'))
          .width(80)
          .height(80)
          .backgroundColor($r('[basic].color.under'))
          .borderRadius(4)
        Column() {
          Row() {
            Text('现价¥'+' ')
              .fontSize(14)
              .fontColor($r('[basic].color.black'))
              .offset({ y: -4 })
            Text(this.sku.price ?? this.goods.price)
              .fontSize(24)
              .fontColor($r('[basic].color.black'))
              .fontWeight(500)
            Text('原价¥' + (this.sku.oldPrice ?? this.goods.price))
              .fontSize(12)
              .fontColor($r('[basic].color.gray'))
              .margin({ left: 10 })
              .offset({ y: -4 })
              .decoration({
                type: TextDecorationType.LineThrough,
                color: $r('[basic].color.gray')
              })
          }
          .alignItems(VerticalAlign.Bottom)

          Row({ space: 10 }) {
            // 计数器
            Counter() {
              Text(this.goodsCount.toString())
            }.enableDec(this.goodsCount > 1) // 限定最小数量
            .onInc(() => this.goodsCount++) // 增加数量
            .onDec(() => this.goodsCount--) // 减少数量
            // Text(this.goods.inventory > 1000 ? '库存充足' : "库存紧张")
            Text(this.showCountType.text)
              .fontSize(12)
              // .fontColor(this.goods.inventory > 1000 ? $r('[basic].color.gray') : $r('[basic].color.red'))
            .fontColor(this.showCountType.color)
          }
        }
        .height(80)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Divider()
        .strokeWidth(4)
        .color($r('[basic].color.under'))
        .margin({ left: -8, right: -8, top: 13 })

      List() {
        ListItem() {
          // Sku 组件
          Sku({
            skus: this.goods.skus,
            specs: this.goods.specs,
            onSkuChange: (sku) => this.sku = sku // 用于接收Sku组件传递过来的规格商品
          })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Row() {
        Button(this.loading ? '加入中...' : '加入购物袋')
          .buyButton($r('[basic].color.black'), true)
          .onClick(() => this.addShoppingCart())
        Button('立即购买')
          .buyButton($r('[basic].color.red'), false)
          .onClick(async () => {})
      }
      .width('100%')
    }
    .height(600)
    .padding({
      left: 16,
      right: 16,
      top: 16,
      bottom: this.safeAreaObject?.bottomHeight ?? 16
    })
  }
}

@Extend(Image) function iconButton() {
  .width(24)
  .aspectRatio(1)
  .margin(13)
  .fillColor($r('[basic].color.black'))
}

@Extend(Button) function buyButton(color: ResourceStr, isLeft: boolean) {
  .fontSize(14)
  .height(36)
  .type(ButtonType.Normal)
  .layoutWeight(1)
  .backgroundColor(color)
  .borderRadius({
    topLeft: isLeft ? 18 : 0,
    bottomLeft: isLeft ? 18 : 0,
    topRight: isLeft ? 0 : 18,
    bottomRight: isLeft ? 0 : 18
  })
  .pixelRound({
    end: PixelRoundCalcPolicy.FORCE_CEIL,
    start: PixelRoundCalcPolicy.FORCE_FLOOR
  })
}