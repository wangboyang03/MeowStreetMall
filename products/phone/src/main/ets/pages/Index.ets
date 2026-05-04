import { AppBreakPoint, BreakPointType, TabItem } from 'basic'
import { CartView } from 'cart'
import { CategoryView } from 'category'
import { HomePageView } from 'homepage'
import { MineView } from 'mine'
import { AppStorageV2 } from '@kit.ArkUI'

@Entry
@ComponentV2
struct Index {
  @Local activeIndex: number = 0 // 默认选中TabContent
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())!
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]

  build() {
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
        .tabBar(this.getTabItemBuilder(item, index))
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
  }

  /**
   * 获取TabItem
   * @param item 数据源接口
   * @param index 下标
   */
  @Builder getTabItemBuilder(item: TabItem, index: number) {
    Column() {
      Image(this.activeIndex == index ? item.active : item.normal)
        .width(24)
        .aspectRatio(1)
      Text(item.text)
        .fontColor($r('[basic].color.black')) // 跨hsp访问资源 [module].resourcesFile.resources
        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }
}