import { AppBreakPoint, AppSafeArea,
  AppShoppingCart,
  BreakPointType, Constants, PAGE_PATH, ShoppingCartAuth, TabItem } from 'basic'
import { CartView } from 'cart'
import { CategoryView } from 'category'
import { HomePageView } from 'homepage'
import { MineView } from 'mine'
import { AppStorageV2, AttributeUpdater } from '@kit.ArkUI'
import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@ComponentV2
struct Index {
  @Local activeIndex: number = 0 // 默认选中TabContent
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())! // 断点对象
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, ()=> new AppSafeArea())! // 安全区避让对象
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]
  modifierObject: MyModifier = new MyModifier() // 修改Navigation特性对象实例
  appSHoppingCart?: AppShoppingCart = AppStorageV2.connect(AppShoppingCart, ()=> new AppShoppingCart())

  /**
   * 统一注册广播事件监听
   */
  registerEvent() {
    ShoppingCartAuth.getInstance().updateCartCount() // 初始化时更新数量
    // 切换底Tab到首页
    emitter.on(Constants.SWITCH_TAB, (event) => {
      if (event.data) {
        this.activeIndex = event.data["index"] as number
      }
    })
  }

  aboutToAppear(): void {
    this.registerEvent()
  }

  build() {
    Column() {
      HMNavigation({
        navigationId: PAGE_PATH.MAIN_PAGE_ID,
        homePageUrl: PAGE_PATH.MAIN_PAGE,
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifierObject
        }
      }) {
        Tabs({ barPosition: new BreakPointType({
          sm: BarPosition.End,
          md: BarPosition.End,
          lg: BarPosition.Start,
        }).getValue(this.breakObject?.breakPoint), index: $$this.activeIndex }) {
          ForEach(this.list, (item: TabItem, index: number) => {
            TabContent() {
              if (index == 0) {
                HomePageView()
              } else if (index == 1) {
                CategoryView()
              } else if (index == 2) {
                CartView()
              } else if (index == 3) {
                MineView()
              }
            }
            .tabBar(this.getFullTabItemBuilder(item, index))
          })
        }
        .barHeight(new BreakPointType({
          sm: 60,
          md: 60,
          lg: 120
        }).getValue(this.breakObject?.breakPoint))
        .vertical(new BreakPointType({
          sm: false,
          md: false,
          lg: true
        }).getValue(this.breakObject?.breakPoint))
        .scrollable(false) // 阻止滚动切换
        .animationDuration(new BreakPointType({
          sm: 300,
          md: 300,
          lg: 0
        }).getValue(this.breakObject.breakPoint)) // 阻止切换动画
        .padding({ bottom: this.safeAreaObject.bottomHeight })
      }
    }

  }

  /**
   * 获取TabItem
   * @param item 数据源接口
   * @param index 下标
   */
  @Builder getTabItemBuilder(item: TabItem, index: number) {
    Column() {
      Image(this.activeIndex == index ? item.active : item.normal)
        .draggable(false)
        .width(24)
        .aspectRatio(1)
      Text(item.text)
        .fontColor($r('[basic].color.black')) // 跨hsp访问资源 [module].resourcesFile.resources
        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }

  @Builder getFullTabItemBuilder(item: TabItem, index: number) {
    if (index == 2) {
      Badge({ count: this.appSHoppingCart?.count ?? 0, style: {} }) {
        this.getTabItemBuilder(item, index)
      }
    } else {
      this.getTabItemBuilder(item, index)
    }
  }
}

class MyModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(sInstance: NavigationAttribute) {
    sInstance.mode(NavigationMode.Stack) // 非分栏模式
    sInstance.titleMode(NavigationTitleMode.Mini) // 全屏标题模式
    sInstance.hideTitleBar(true) // 隐藏标题栏
  }
}