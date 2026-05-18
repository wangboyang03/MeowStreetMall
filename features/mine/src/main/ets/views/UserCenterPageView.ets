import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, CellComponent, CellGroupComponent, NavigationBar, PAGE_PATH } from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { UserInformationModel, UserInformationResponse } from "../models";
import { getUserInformationApi } from "../apis";
import { camera, cameraPicker } from "@kit.CameraKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";

@HMRouter({ pageUrl: PAGE_PATH.USER_CENTER_PAGE })
@ComponentV2
export struct UserCenterPageView {
  // @Local userObject: UserInformationResponse = {} as UserInformationResponse
  @Local userViewModel: UserInformationModel = new UserInformationModel({} as UserInformationResponse)
  @Local showSheet: boolean = false
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  /**
   * 获取用户信息
   */
  async getUserInformation() {
    // this.userObject = await getUserInformationApi()
    // 只有通过实例化后的类对象才能具有响应式
    const result = await getUserInformationApi()
    this.userViewModel = new UserInformationModel(result)
  }

  /**
   * 拍照
   */
  async takePicture() {
    // 安全拉起相机拍摄
    const tempCameraPicker = await cameraPicker.pick(
      this.getUIContext().getHostContext(), // 上下文对象
      [cameraPicker.PickerMediaType.PHOTO], // 媒体类型
      {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_FRONT // 摄像头位置
      }
    )
    this.userViewModel.avatar = tempCameraPicker.resultUri
    this.showSheet = false
  }

  /**
   * 打开相册
   */
  async openPhotoAlbum() {
    const picker = new photoAccessHelper.PhotoViewPicker() // 创建图片选择器
    const mediaFile = await picker.select({
      maxSelectNumber: 1, // 最大选择数量
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (mediaFile?.photoUris?.length) {
      this.userViewModel.avatar = mediaFile.photoUris[0]
      this.showSheet = false
    }
  }

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
        CellComponent({ leftLabel: "账号", rightLabel: this.userViewModel?.account, showRightIcon: false })
        CellComponent({ leftLabel: "昵称", rightLabel: this.userViewModel?.nickname })
        CellComponent({ leftLabel: "性别", rightLabel: this.userViewModel?.gender })
        CellComponent({ leftLabel: "生日", rightLabel: this.userViewModel?.birthday })
        CellComponent({ leftLabel: "城市", rightLabel: this.userViewModel?.fullLocation })
      }
    }
    .bindSheet($$this.showSheet, this.getSheetBuilder, {
      height: 150 + this.safeAreaObject?.bottomHeight!,
      showClose: false
    })
  }

  @Builder getUserAvatar() {
    Row() {
      Image(this.userViewModel?.avatar)
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