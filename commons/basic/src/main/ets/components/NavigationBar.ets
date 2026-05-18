import { AppSafeArea } from "../models"
import { AppStorageV2 } from "@kit.ArkUI"

@ComponentV2
export struct NavigationBar {
  @Param title: string = ""
  @Param leftIcon: ResourceStr = $r("app.media.ic_public_left")
  @Param rightIcon: ResourceStr = $r("app.media.ic_public_more")
  @Param showLeftIcon: boolean = false
  @Param showRightIcon: boolean = false
  @Param color: ResourceColor = $r("app.color.black")
  @Param bgColor: ResourceColor = $r("app.color.white")
  @Event onLeftClick: () => void = () => {}
  @Event onRightClick: () => void = () => {}
  @BuilderParam customTitle: () => void = this.defaultBuilder
  safeAreaObject?: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea()) // 安全区避让对象

  build() {
    RelativeContainer() {
      if (this.showLeftIcon) {
        Image(this.leftIcon)
          .draggable(false)
          .fillColor(this.color)
          .width(24)
          .aspectRatio(1)
          .alignRules({
            center: {
              anchor: "__container__",
              align: VerticalAlign.Center
            }
          })
          .onClick(() => this.onLeftClick())
      }
      if (this.showRightIcon) {
        Image(this.rightIcon)
          .draggable(false)
          .width(24)
          .aspectRatio(1)
          .fillColor(this.color)
          .alignRules({
            center: {
              anchor: "__container__",
              align: VerticalAlign.Center
            },
            right: {
              anchor: "__container__",
              align: HorizontalAlign.End
            }
          })
          .onClick(() => this.onRightClick())
          .zIndex(2)
      }
      if (this.title) {
        Text(this.title)
          .fontColor(this.color)
          .alignRules({
            center: {
              anchor: "__container__",
              align: VerticalAlign.Center
            },
            middle: {
              anchor: "__container__",
              align: HorizontalAlign.Center
            }
          })
          .fontWeight(FontWeight.Bold)
      }
      if (this.customTitle) {
        this.customTitle()
      }
    }
    .padding({
      top: this.safeAreaObject?.topHeight,
      left: 10,
      right: 10
    })
    .width("100%")
    .height(50 + this.safeAreaObject?.topHeight!)
    .backgroundColor(this.bgColor)
  }

  @Builder defaultBuilder() {}
}