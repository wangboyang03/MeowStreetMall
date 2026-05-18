import { AddressItem, CellComponent } from "basic";

@ComponentV2
export struct ChangeAddressComponent {
  @Param addressList: AddressItem[] = []
  @Local currentAddress: AddressItem = {} as AddressItem
  @Event onChangeAddress: (address: AddressItem) => void = () => {}
  @Monitor("addressList") onAddressListChange() {
    const defAddress = this.addressList.find(addr => addr.isDefault == 0)
    if (defAddress) {
      this.currentAddress = defAddress
    } else {
      this.currentAddress = this.addressList[0]
    }
    this.onChangeAddress(this.currentAddress)
  }

  build() {
    Row() {
      CellComponent({
        customLabel: (): void => this.AddressHintBuilder()
      })
    }
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('[basic].color.white'))
    .width('100%')
    .onAppear(() => this.onChangeAddress(this.currentAddress))
  }

  /**
   * 地址提示
   */
  @Builder AddressHintBuilder() {
    if (this.addressList.length) {
      Column({ space: 8 }) {
        Row({ space: 4 }) {
          if (this.currentAddress.isDefault === 0) {
            Text('默认')
              .fontSize(14)
              .width(40)
              .height(20)
              .borderRadius(4)
              .fontColor($r('[basic].color.white'))
              .textAlign(TextAlign.Center)
              .linearGradient({
                angle: 90,
                colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
              })
          }
          Text(this.currentAddress.fullLocation)
            .fontSize(14)
            .fontColor($r('[basic].color.text'))
        }

        Text(this.currentAddress.address)
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('[basic].color.black'))
        Text(`${this.currentAddress.receiver} ${this.currentAddress.contact}`)
          .fontSize(13)
          .fontColor($r('[basic].color.text'))
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ top: 10, bottom: 10 })
    } else {
      Text('请填写收货地址')
        .fontSize(14)
        .fontColor($r('[basic].color.gray'))
    }
  }
}