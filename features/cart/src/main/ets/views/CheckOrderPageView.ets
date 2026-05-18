import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AddressItem, AppSafeArea, CellComponent, CustomDialogHelper, getPrepaymentOrderApi, NavigationBar, OrderGoodsItem, PAGE_PATH, PayChannel, Summary } from 'basic'
import { AppStorageV2 } from "@kit.ArkUI";
import { ChangeAddressComponent } from "../components";

@HMRouter({ pageUrl: PAGE_PATH.CHECK_ORDER_PAGE })
@ComponentV2
export struct CheckOrderPageView {
  @Local goodsList: OrderGoodsItem[] = []  // 商品列表
  @Local addressList: AddressItem[] = [] // 地址
  @Local summary: Summary = {} as Summary // 订单概要
  @Local showPaySheet: boolean = false // 是否显示支付弹窗
  @Local payChannel: number = 1 // 支付通道
  @Local addressId: string = ''
  @Local loading: boolean = false
  payChannels = [PayChannel.Alipay, PayChannel.WeChat, PayChannel.HuaweiPay]
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  async submitOrder(): Promise<void> {
    if (this.payChannel !== 1) {
      return CustomDialogHelper.getInstance().showToast({ message: '暂不支持该支付方式' })
    }
    if (!this.addressId) {
      return CustomDialogHelper.getInstance().showToast({ message: '未选择收货地址' })
    }
    this.loading = true
  }

  /**
   * 获取订单信息
   */
  async getPreOrder() {
    const result = await getPrepaymentOrderApi()
    this.goodsList = result.goods
    this.addressList = result.userAddresses
    this.summary = result.summary
  }

  aboutToAppear(): void {
    this.getPreOrder()
  }

  build() {
    Column() {
      NavigationBar({
        title: '收银台',
        onLeftClick: () => HMRouterMgr.pop()
      })
        .border({
          width: { bottom: 0.5 },
          color: '#E4E4E4'
        })
      List() {
        ListItem() {
          ChangeAddressComponent({
            addressList: this.addressList,
            onChangeAddress: (address) => this.addressId = address?.id
          })
        }

        ListItem() {
          Row() {
            Column() {
              ForEach(this.goodsList, (goods: OrderGoodsItem) => {
                this.GoodsItemBuilder(goods)
              })
            }
            .padding({ left: 8, right: 8 })
            .backgroundColor($r('[basic].color.white'))
          }
          .padding({ top: 8, left: 8, right: 8 })
        }

        ListItem() {
          Row() {
            Column() {
              CellComponent({ leftLabel: '配送时间', rightLabel: '时间不限' })
              CellComponent({ leftLabel: '留言', rightLabel: '建议留言前先和卖家沟通' })
            }
            .padding({ left: 8, right: 8 })
            .backgroundColor($r('[basic].color.white'))
          }
          .padding({ top: 8, left: 8, right: 8 })
        }

        ListItem() {
          Row() {
            Column() {
              PriceCell({ label: '商品总价', price: this.summary.totalPrice })
              PriceCell({ label: '运费', price: this.summary.postFee })
              PriceCell({ label: '实付金额', price: this.summary.totalPayPrice, isRed: true })
            }
            .padding({ left: 8, right: 8 })
            .backgroundColor($r('[basic].color.white'))
          }
          .padding({ top: 8, left: 8, right: 8 })
        }

        ListItem() {
          Row() {
            Column() {
              CheckCell({ label: '在线支付', checked: true })
              CheckCell({ label: '货到付款' })
            }
            .padding({ left: 8, right: 8 })
            .backgroundColor($r('[basic].color.white'))
          }
          .padding(8)
        }

      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Row() {
        Column() {
          Text() {
            Span('¥')
              .fontSize(14)
            Span(this.summary.totalPayPrice?.toFixed(2))
              .fontSize(20)
          }
          .fontColor($r('[basic].color.red'))
          .fontWeight(500)

          Text() {
            Span('共减')
              .fontColor($r('[basic].color.gray'))
            Span('¥00.00')
              .fontColor($r('[basic].color.red'))
              .fontWeight(500)
          }
          .fontSize(8)
        }
        .alignItems(HorizontalAlign.Start)

        Blank()
        Button('提交订单')
          .fontSize(14)
          .height(36)
          .backgroundColor($r('[basic].color.red'))
          .onClick(() => this.showPaySheet = true)
      }
      .width('100%')
      .height(50 + this.safeAreaObject?.bottomHeight!)
      .backgroundColor($r('[basic].color.white'))
      .border({
        width: { top: 0.5 },
        color: '#e4e4e4'
      })
      .padding({ left: 16, right: 16, bottom: this.safeAreaObject?.bottomHeight })
    }
    .backgroundColor($r('[basic].color.under'))
    .bindSheet($$this.showPaySheet, this.PaySheetBuilder(), {
      title: {
        title: '支付方式',
        subtitle: '请选择一种支付方式进行付款'
      }, height: SheetSize.FIT_CONTENT, backgroundColor: $r('[basic].color.white')
    })
  }

  /**
   * 商品项
   * @param goods
   */
  @Builder GoodsItemBuilder(goods: OrderGoodsItem) {
    Row({ space: 10 }) {
      Image(goods.picture)
        .width(80)
        .height(80)
      Column({ space: 8 }) {
        Text(goods.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(14)
          .fontColor($r('[basic].color.black'))
          .width('100%')
        Row({ space: 8 }) {
          Text(goods.attrsText)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(12)
            .fontColor($r('[basic].color.text'))
            .layoutWeight(1)
          Text('x' + goods.count)
            .fontSize(14)
            .fontColor($r('[basic].color.gray'))
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text('¥'+ ' ' + goods.payPrice)
          .width('100%')
          .fontSize(16)
          .fontColor($r('[basic].color.black'))
      }
      .layoutWeight(1)
    }
    .padding({ top: 10, bottom: 10 })
    .border({
      width: { bottom: 0.5 },
      color: '#E4E4E4'
    })
  }

  /**
   * 支付弹窗
   */
  @Builder PaySheetBuilder() {
    Column() {
      Text('¥' + ' ' + this.summary.totalPayPrice?.toString())
        .fontSize(20)
        .fontWeight(500)
        .fontColor($r('[basic].color.black'))
        .height(50)
        .width('100%')
        .border({
          width: { bottom: 0.5 },
          color: $r('[basic].color.under')
        })
      ForEach(this.payChannels, (label: string, index) => {
        CheckCell({
          label: label, checked: this.payChannel === index + 1, onClickBox: () => {
            this.payChannel = index + 1
          }
        }).onClick(() => this.payChannel = index + 1)
      })
      Row() {
        Button(this.loading ? '提交中...' : '立即支付')
          .width('100%')
          .height(36)
          .fontSize(14)
          .backgroundColor($r('[basic].color.red'))
          .onClick(() => {
            this.submitOrder()
          })
      }
      .height(50)
    }
    .padding({ left: 16, right: 16, bottom: this.safeAreaObject?.bottomHeight })
  }
}

@ComponentV2
struct PriceCell {
  @Param label: string = ""
  @Param price: number = 0
  @Param isRed: boolean = false

  @Builder PriceBuilder() {
    Text('¥' + ' ' + this.price)
      .fontSize(this.isRed ? 16 : 14)
      .fontColor(this.isRed ? $r('[basic].color.red') : $r('[basic].color.gray'))
  }

  build() {
    CellComponent({
      leftLabel: this.label,
      customIcon: (): void => this.PriceBuilder()
    })
  }
}

@Component
struct CheckCell {
  @Prop label: string
  @Prop checked: boolean = false
  onClickBox: () => void = () => {}

  @Builder CheckBuilder() {
    Checkbox()
      .selectedColor($r('[basic].color.red'))
      .select(this.checked)
      .onClick(() => {
        this.onClickBox()
      })
  }

  build() {
    CellComponent({
      leftLabel: this.label,
      customIcon: (): void => this.CheckBuilder()
    })
  }
}