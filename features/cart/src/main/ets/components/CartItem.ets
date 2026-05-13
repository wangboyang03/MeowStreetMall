import { CartGoods, CartGoodsModel } from "basic"

@ComponentV2
export struct CartItem {
  @Param cartGoodsModel: CartGoodsModel = new CartGoodsModel({} as CartGoods) // 实例化商品模型
  @Event onChangeSelected: (selected: boolean) => void = () => {}
  @Event onChangeCount: (count: number) => void = () => {}

  build() {
    Row({ space: 10 }) {
      Checkbox()
        .selectedColor($r('[basic].color.red'))
        .size({ width: 14, height: 14 })
        .select(this.cartGoodsModel.selected)
        .onClick(() => {
          this.cartGoodsModel.selected = !this.cartGoodsModel.selected // 取反
          this.onChangeSelected(this.cartGoodsModel.selected)
        })

      Image(this.cartGoodsModel.picture)
        .width(80)
        .height(80)
        .syncLoad(true)

      Column({ space: 8 }) {
        Text(this.cartGoodsModel.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(14)
          .fontColor($r('[basic].color.black'))
          .width('100%')
        Row() {
          Text(this.cartGoodsModel.attrsText)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(12)
            .fontColor($r('[basic].color.text'))
            .layoutWeight(1)
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .fillColor($r('[basic].color.gray'))
            .width(16)
            .height(16)
        }
        .width(100)
        .height(24)
        .padding({
          left: 6,
          right: 4
        })
        .backgroundColor($r('[basic].color.under'))
        .borderRadius(2)

        Row() {
          Text(`¥${this.cartGoodsModel.price}`)
            .fontSize(14)
            .fontWeight(500)
          Counter() {
            Text(this.cartGoodsModel.count.toString())
          }
          .enableDec(this.cartGoodsModel.count > 1)
          .onInc(() => {
            this.cartGoodsModel.count++
            this.onChangeCount(this.cartGoodsModel.count)
          })
          .onDec(() => {
            this.cartGoodsModel.count--
            this.onChangeCount(this.cartGoodsModel.count)
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(100)
    .padding(10)
    .border({
      width: {
        bottom: 0.5
      },
      color: '#E4E4E4'
    })
    .backgroundColor($r('[basic].color.white'))
  }
}