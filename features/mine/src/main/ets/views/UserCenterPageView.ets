import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, CellComponent, CellGroupComponent, NavigationBar, PAGE_PATH } from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { UserInformationResponse } from "../models";
import { getUserInformationApi } from "../apis";

@HMRouter({ pageUrl: PAGE_PATH.USER_CENTER_PAGE })
@ComponentV2
export struct UserCenterPageView {
  @Local userObject: UserInformationResponse = {} as UserInformationResponse
  @Local showSheet: boolean = false
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  /**
   * 获取用户信息
   */
  async getUserInformation() {
    this.userObject = await getUserInformationApi()
  }

  /**
   * 拍照
   */
  async takePicture() {}

  /**
   * 打开相册
   */
  async openPhotoAlbum() {}

  /**
   * 加载用户信息
   * @param url
   */
  async upload(url: string) {}

  aboutToAppear(): void {
    this.getUserInformation()
  }

  build() {
    Column() {
      NavigationBar({
        title: '个人信息',
        onLeftClick: () => HMRouterMgr.pop()
      })
      CellGroupComponent() {
        CellComponent({
          leftLabel: '头像',
          customIcon: (): void => this.getUserAvatar()
        })
        CellComponent({ leftLabel: "账号", rightLabel: this.userObject.account, showRightIcon: false })
        CellComponent({ leftLabel: "昵称", rightLabel: this.userObject.nickname })
        CellComponent({ leftLabel: "性别", rightLabel: this.userObject.gender })
        CellComponent({ leftLabel: "生日", rightLabel: this.userObject.birthday })
        CellComponent({ leftLabel: "城市", rightLabel: this.userObject.fullLocation })
      }
    }
    .bindSheet($$this.showSheet, this.getSheetBuilder, {
      height: 150 + this.safeAreaObject?.bottomHeight!,
      showClose: false
    })
  }

  @Builder getUserAvatar() {
    Row() {
      Image(this.userObject.avatar)
        .width(30)
        .aspectRatio(1)
        .borderRadius(15)
      Image($r("[basic].media.ic_public_right"))
        .width(30)
        .aspectRatio(1)
        .fillColor($r("[basic].color.gray"))
    }
    .onClick(() => this.showSheet = true)
  }

  @Builder getSheetBuilder() {
    Column() {
      Text("拍照")
        .textAlign(TextAlign.Center)
        .height(50)
        .width("100%")
        .border({
          color: $r("[basic].color.under"),
          width: {
            bottom: 0.5
          }
        })
        .stateStyles({
          pressed: {
            .backgroundColor($r("[basic].color.under"))
          },
          normal: {
            .backgroundColor($r("[basic].color.white"))
          }
        })
        .onClick(() => this.takePicture())
      Text("从相册上传")
        .textAlign(TextAlign.Center)
        .height(50)
        .width("100%")
        .border({
          color: $r("[basic].color.under"),
          width: {
            bottom: 0.5
          }
        })
        .stateStyles({
          pressed: {
            .backgroundColor($r("[basic].color.under"))
          },
          normal: {
            .backgroundColor($r("[basic].color.white"))
          }
        })
        .onClick(() => this.openPhotoAlbum())

      Text("取消")
        .textAlign(TextAlign.Center)
        .height(50)
        .width("100%")
        .stateStyles({
          pressed: {
            .backgroundColor($r("[basic].color.under"))
          },
          normal: {
            .backgroundColor($r("[basic].color.white"))
          }
        })
        .onClick(() => this.showSheet = false)
    }
    .width("100%")
    .backgroundColor($r("[basic].color.white"))
    .padding({
      bottom: this.safeAreaObject?.bottomHeight
    })
  }
}