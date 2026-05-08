import { GoodsItem } from "basic";

@ComponentV2
export struct Goods {
  @Param goodsItem: GoodsItem = {} as GoodsItem
  @Param smallImage: boolean = false
  build() {
    this.GoodsComponent()
  }
  @Builder GoodsComponent() {
    Column({ space: 10 }) {
      if (this.smallImage) {
        Row() {
          Image(this.goodsItem.picture)
            .alt($r('[basic].media.ic_public_empty'))
            .draggable(false)
            .width('100%')
            .aspectRatio(1)
        }
        .width('100%')
        .padding(20)
      } else {
        Image(this.goodsItem.picture)
          .alt($r('[basic].media.ic_public_empty'))
          .draggable(false)
          .width('100%')
          .aspectRatio(1)
      }
      Text(this.goodsItem.name)
        .fontSize(14)
        .fontColor($r('[basic].color.text'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .padding({ left: 10, right: 10 })
      Row({ space: 4 }) {
        Text('¥' + Number(this.goodsItem.price))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('[basic].color.black'))
        Text('¥999')
          .fontSize(8)
          .fontColor($r('[basic].color.gray'))
          .decoration({ type: TextDecorationType.LineThrough, color: $r('[basic].color.gray') })
        Blank()
        Text('2.9万+人付款')
          .fontSize(10)
          .fontColor($r('[basic].color.gray'))
      }
      .alignItems(VerticalAlign.Bottom)
      .width('100%')
      .margin({ bottom: 10 })
      .padding({ left: 10, right: 10 })
    }
    .width('100%')
    .backgroundColor($r('[basic].color.white'))
    .borderRadius(8)
    .clip(true)
  }
}