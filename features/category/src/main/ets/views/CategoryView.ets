import { AppBreakPoint, AppSafeArea, CategoryItem, CategoryItemChild } from "basic"
import { AppStorageV2 } from "@kit.ArkUI"

@ComponentV2
export struct CategoryView {
  @Local activeIndex: number = 0 // 默认渲染第一项
  breakObject:AppBreakPoint = AppStorageV2.connect(AppBreakPoint, ()=> new AppBreakPoint())! // 断点对象
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())! // 安全区避让对象
  categoryItems: CategoryItem[] = new Array(10).fill({
    id: "1181622001",
    name: "气质女装",
    picture: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png"
  }) // 分类项

  build() {
    Column() {
      Row() {
        // 左边分类栏
        Column() {
          Repeat<CategoryItem>(this.categoryItems).each((object: RepeatItem<CategoryItem>)=> {
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
            Image('https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png') // 顶图
              .width('100%')
              .height(136)
              .objectFit(ImageFit.Contain)
              .backgroundColor('#F6F6F6')
              .borderRadius(8)
              .margin({ bottom: 8 })
            GridRow({ columns: 2, gutter: 8 }) {
              ForEach(Array.from({ length: 10 }), (sub: CategoryItemChild) => {
                GridCol() {
                  Column() {
                    Image('https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_bq.png?quality=95&imageView')
                      .width(64)
                      .aspectRatio(1)
                    Text('半裙')
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
    .padding({
      top: this.safeAreaObject.topHeight
    })
  }
}