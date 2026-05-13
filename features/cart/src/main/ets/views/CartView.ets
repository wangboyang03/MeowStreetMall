import { PersistenceV2 } from "@kit.ArkUI"
import { CartGoodsModel, NavigationBar, RecommendComponent, UserInformation } from "basic"
import { CartItem } from "../components"

@ComponentV2
export struct CartView {
  userInformation?: UserInformation = PersistenceV2.connect(UserInformation, () => new UserInformation()) // 用户信息
  @Local cartList: CartGoodsModel[] = [] // 购物车列表

  onCheckOrder() {
    AlertDialog.show({
      message: '去结算'
    })
  }

  build() {
    Column() {
      NavigationBar({
        title: '购物袋'
      }).border({
        width: { bottom: 0.5 },
        color: '#E4E4E4'
      })

      List() {
        if (!!this.userInformation?.token) {
          if (this.cartList.length) {
            ForEach(this.cartList, (cart: CartGoodsModel) => {
              ListItem() {
                CartItem({
                  cartGoodsModel: cart,
                  onChangeSelected: async selected => {}
                })
              }
              .backgroundColor($r('[basic].color.under'))
              .padding({
                left: 8,
                right: 8
              })
              .transition({ type: TransitionType.Delete, opacity: 0 })
              .swipeAction({
                end: this.DeleteBuilder(cart)
              })
            })
          } else {
            ListItem() {}
          }
        } else {
          // 没有登录
          ListItem() {}
        }
        // 猜喜
        ListItem() {
          RecommendComponent()
            .margin({
              top: 8,
              bottom: 8
            })
        }
      }
      .contentStartOffset(8)
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      if (this.cartList.length) {
        Row() {
          Checkbox()
            .selectedColor($r('[basic].color.red'))
            .onClick(async () => {})
          Text('全选')
            .fontSize(14)
            .fontColor($r('[basic].color.black'))
            .margin({ right: 20 })
          Text('合计:')
            .fontSize(14)
            .fontColor($r('[basic].color.black'))
            .margin({ right: 2 })
          Text("0.00")
            .fontSize(16)
            .fontWeight(500)
            .fontColor($r('[basic].color.red'))
            .layoutWeight(1)
          Button('去结算')
            .enabled(this.cartList.some(item => item.selected))
            .fontSize(14)
            .height(36)
            .backgroundColor($r('[basic].color.red'))
            .onClick(() => {})
        }
        .width('100%')
        .height(50)
        .backgroundColor($r('[basic].color.white'))
        .border({
          width: {
            top: 0.5,
            bottom: 0.5
          },
          color: '#E4E4E4'
        })
        .padding({
          left: 16,
          right: 16
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('[basic].color.under'))
  }

  @Builder DeleteBuilder(cart: CartGoodsModel) {
    Text('删除')
      .fontSize(14)
      .backgroundColor($r('[basic].color.red'))
      .fontColor($r('[basic].color.white'))
      .textAlign(TextAlign.Center)
      .width(60)
      .height(100)
      .onClick(() => {})
  }
}