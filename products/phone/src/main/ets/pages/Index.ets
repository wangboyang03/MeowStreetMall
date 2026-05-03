import { TabItem } from 'basic'

@Entry
@ComponentV2
struct Index {
  @Local activeIndex: number = 0 // 默认选中TabContent
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]

  build() {
    Tabs({ barPosition: BarPosition.End, index: $$this.activeIndex }) {
      ForEach(this.list, (item: TabItem, index: number) => {
        TabContent() {}
        .tabBar(this.getTabItemBuilder(item, index))
      })
    }
    .scrollable(false) // 阻止滚动切换
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