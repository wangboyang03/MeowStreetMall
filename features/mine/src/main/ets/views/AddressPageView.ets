import { AddressItem, AppSafeArea, NavigationBar, PAGE_PATH, CustomDialogHelper } from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { HMLifecycleState, HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { addAddressListApi, deleteAddressListApi, getAddressListApi, updateAddressListApi } from "../apis/user";
import { IAddressForm } from "../models";

@HMRouter({ pageUrl: PAGE_PATH.ADDRESS_PAGE })
@ComponentV2
export struct AddressPageView {
  @Local addressList: AddressItem[] = []
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  /**
   * 获取地址列表
   */
  async getAddressList() {
    const addressList = await getAddressListApi()
    addressList.reverse()
    this.addressList = addressList
  }

  aboutToAppear(): void {
    // 返回就要刷新地址 利用Navigation生命钩子onShown()
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onShown, () => {
      this.getAddressList()
    })
  }

  build() {
    Column() {
      NavigationBar({
        title: '收货地址管理',
        showLeftIcon: true
      })

      Row() {
        List() {
          ForEach(
            this.addressList,
            (item: AddressItem) => {
              ListItem() {
                Row() {
                  Column() {
                    Row() {
                      if (item.isDefault == 0) {
                        Row() {
                          Text('默认')
                            .fontSize(13)
                            .fontColor($r('[basic].color.white'))
                        }
                        .borderRadius(2)
                        .padding({
                          left: 8,
                          right: 8,
                          top: 2,
                          bottom: 2
                        })
                        .linearGradient({
                          angle: '93',
                          colors: [['#FD3F8F', 0], ['#FF773C', 1]]
                        })
                        .margin({
                          right: 4
                        })
                      }

                      Text(item.address)
                        .fontColor('#434343')
                        .fontSize(14)

                    }

                    Text(`${item.receiver} ${item.contact}`)
                      .margin({ top: 8 })
                      .fontSize(12)
                  }
                  .alignItems(HorizontalAlign.Start)

                  Row() {
                    Image($r("[basic].media.ic_public_edit"))
                      .width(16)
                      .onClick(() => {
                        HMRouterMgr.push({
                          pageUrl: PAGE_PATH.CREATE_ADDRESS_PAGE,
                          param: item
                        })
                      })
                  }
                }
                .padding(16)
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .backgroundColor($r('[basic].color.white'))
              }
              .margin({ bottom: 10 })
              .swipeAction({
                end: this.ActionBuilder(item.id)
              })
            }
          )
        }
        .width('100%')
        .height('100%')
      }
      .margin({ top: 8 })
      .padding({ left: 8, right: 8 })
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)

      // 新增地址
      Row() {
        Button('新增地址')
          .backgroundColor($r('[basic].color.black'))
          .fontSize(14)
          .width('100%')
          .onClick(() => {
            HMRouterMgr.push({
              pageUrl: PAGE_PATH.CREATE_ADDRESS_PAGE
            })
          })
      }
      .height(46)
      .padding({ left: 16, right: 16, })
    }
    .height('100%')
    .backgroundColor('#F5F4F9')
    .padding({
      bottom: this.safeAreaObject?.bottomHeight
    })
  }

  @Builder ActionBuilder(id: string) {
    Row() {
      Row() {
        Text('设为默认')
          .fontColor($r('[basic].color.white'))
          .fontSize(11)
          .padding({ left: 10, right: 10 })
      }
      .layoutWeight(1)
      .height('100%')
      .backgroundColor($r('[basic].color.black'))
      .onClick(async () => {
        const object = this.addressList.find(item => item.id == id)
        if (!!object) {
          object.isDefault = 0
          await updateAddressListApi(object as IAddressForm)
          CustomDialogHelper.getInstance().showToast({
            message: '该地址已设置为默认地址'
          })
          this.getAddressList()
        }
      })

      Row() {
        Text('删除')
          .fontColor($r('[basic].color.white'))
          .fontSize(11)
          .padding({ left: 10, right: 10 })
          .onClick(async () => {
            await deleteAddressListApi(id)
            CustomDialogHelper.getInstance().showToast({
              message: '删除成功'
            })
            this.getAddressList()
          })
      }
      .backgroundColor($r('[basic].color.red'))
      .layoutWeight(1)
      .height('100%')
    }
    .width(88)
  }
}