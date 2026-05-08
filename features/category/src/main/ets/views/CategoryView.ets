import { AppBreakPoint, AppSafeArea, AppSharedData, BreakPointType, CategoryItem, CategoryItemChild, NavigationBar, PAGE_PATH } from "basic"
import { AppStorageV2 } from "@kit.ArkUI"
import { HMRouterMgr } from "@hadss/hmrouter"

@ComponentV2
export struct CategoryView {
  @Local activeIndex: number = 0 // 默认渲染第一项
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())! // 断点对象
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())! // 安全区避让对象
  appSharedData: AppSharedData = AppStorageV2.connect(AppSharedData, () => new AppSharedData())! // 共享数据对象

  build() {
    Column() {
      NavigationBar({
        title: '分类',
        showRightIcon: true,
        rightIcon: $r('[basic].media.ic_public_search'),
        onRightClick: () => HMRouterMgr.push({ pageUrl: PAGE_PATH.SEARCH_PAGE })}).border({ width: { bottom: 0.5 }, color: $r('[basic].color.under') })
      Row() {
        // 左边分类栏
        Column() {
          Repeat<CategoryItem>(this.appSharedData.category).each((object: RepeatItem<CategoryItem>)=> {
            Text(object.item.name)// 文本
              .backgroundColor(this.activeIndex == object.index ? $r('[basic].color.black') : $r('[basic].color.white'))
              .fontSize(14)
              .fontColor(this.activeIndex == object.index ? $r('[basic].color.white') : $r('[basic].color.black'))
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(56)
              .onClick(() => {
                this.activeIndex = object.index
              })
          })
        }
        .width(88)
        .border({ width: { right: 0.5 }, color: $r('[basic].color.under') })

        Scroll() {
          Column() {
            // 顶部图片
            Image(this.appSharedData.category[this.activeIndex]?.picture)
              .draggable(false)
              .width('100%')
              .height(new BreakPointType({
                sm: 136,
                md: 316,
                lg: 316
              }).getValue(this.breakObject.breakPoint))
              .objectFit(ImageFit.Contain)
              .backgroundColor('#F6F6F6')
              .borderRadius(8)
              .margin({ bottom: 8 })
            GridRow({ columns: {
              sm: 2,
              md: 4,
              lg: 4
            }, gutter: 8 }) {
              Repeat<CategoryItemChild>(this.appSharedData.category[this.activeIndex]?.children ?? []).each((object: RepeatItem<CategoryItemChild>) => {
                GridCol() {
                  Column() {
                    Image(object?.item?.picture)
                      .draggable(false)
                      .width(64)
                      .aspectRatio(1)
                    Text(object?.item?.name)
                      .fontSize(14)
                      .fontColor($r('[basic].color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#F6F6F6')
                .borderRadius(8)
              })
            }
          }
          .padding(8)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
  }
}