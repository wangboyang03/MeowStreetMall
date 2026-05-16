import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, CustomDialogHelper, NavigationBar, PAGE_PATH } from "basic";
import { addAddressListApi } from "../apis";
import { AddressForm, IAddressForm } from "../models";
import { AppStorageV2 } from "@kit.ArkUI";

@HMRouter({ pageUrl: PAGE_PATH.CREATE_ADDRESS_PAGE })
@ComponentV2
export struct CreateAddressPageView {
  @Local addressFormData: AddressForm = new AddressForm({} as IAddressForm) // 地址表单数据对象
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  async onSubmit(): Promise<void> {
    if (!this.addressFormData?.receiver) {
      return CustomDialogHelper.getInstance().showToast({ message: '收货人姓名不能为空' })
    }
    if (!/^1[3-9]\d{9}$/.test(this.addressFormData?.contact)) {
      return CustomDialogHelper.getInstance().showToast({ message: '收货人手机号码格式不对' })
    }
    if (!this.addressFormData?.address) {
      return CustomDialogHelper.getInstance().showToast({ message: '收货人详细地址不能为空' })
    }
    await addAddressListApi({
      contact: this.addressFormData?.contact,
      isDefault: this.addressFormData?.isDefault,
      receiver: this.addressFormData?.receiver,
      address: this.addressFormData?.address
    })
    CustomDialogHelper.getInstance().showToast({ message: '新增地址成功' })
    HMRouterMgr.pop()
  }

  build() {
    Column() {
      NavigationBar({
        title: '新增地址页',
        onLeftClick: () => HMRouterMgr.pop()
      })

      Row() {
        List() {
          ListItem() {
            Row() {
              Text('收货人')
                .width(80)
                .fontSize(14)
                .fontColor($r('[basic].color.black'))
              TextInput({ placeholder: '请填写收货人名称', text: $$this.addressFormData.receiver })
                .fontSize(14)
                .backgroundColor($r('[basic].color.white'))
            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Text('手机号码')
                .width(80)
                .fontSize(14)
                .fontColor($r('[basic].color.black'))
              TextInput({ placeholder: '请填写收货人电话', text: $$this.addressFormData.contact })
                .fontSize(14)
                .backgroundColor($r('[basic].color.white'))

            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Text('详细地址')
                .width(80)
                .fontSize(14)
                .fontColor($r('[basic].color.black'))
              TextInput({ placeholder: '请填写详细地址', text: $$this.addressFormData.address })
                .fontSize(14)
                .backgroundColor($r('[basic].color.white'))


            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Text('设为默认地址')
                .fontSize(14)
                .fontColor(($r('[basic].color.black')))
              Toggle({ isOn: this.addressFormData?.isDefault == 0 ? true : false, type: ToggleType.Checkbox })
                .selectedColor(($r('[basic].color.red')))
                .onChange((isOn) => {
                  if (!!this.addressFormData) this.addressFormData.isDefault = isOn ? 0 : 1
                })
            }
            .listItemStyle()
          }
        }
        .divider({
          strokeWidth: 1,
          color: '#eee'
        })
        .backgroundColor($r('[basic].color.white'))
        .padding({ left: 8, right: 8 })
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)

      // 保存按钮
      Row() {
        Button('保存')
          .backgroundColor(($r('[basic].color.black')))
          .fontSize(14)
          .width('100%')
          .onClick(() => this.onSubmit())
      }
      .height(46)
      .padding({ left: 16, right: 16 })
    }
    .height('100%')
    .backgroundColor('#F5F4F9')
    .padding({
      bottom: this.safeAreaObject?.bottomHeight
    })
  }
}

@Extend(Row) function listItemStyle() {
  .width('100%')
  .padding({ top: 4, bottom: 4 })
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor($r('[basic].color.white'))
}