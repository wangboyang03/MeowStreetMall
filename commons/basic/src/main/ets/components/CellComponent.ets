@ComponentV2
export struct CellComponent {
  @Param leftLabel: string = ""
  @Param icon: ResourceStr = $r("app.media.ic_public_right")
  @Param rightLabel: string = ""
  @Param showRightIcon: boolean = true // 是否显示右侧图标
  @Event onRightClick: () => void = () => {}
  @BuilderParam customLabel: () => void // 左側自定義結構
  @BuilderParam customIcon: () => void // 右側自定義結構


  build() {
    Row() {
      if (this.customLabel) {
        this.customLabel()
      } else {
        Text(this.leftLabel)
          .fontSize(16)
          .fontColor($r("app.color.black"))
      }

      Row() {
        Text(this.rightLabel)
          .fontColor($r("app.color.gray"))
          .fontSize(14)

        if (this.customIcon) {
          this.customIcon()
        } else {
          if (this.showRightIcon) {
            Image(this.icon)
              .fillColor($r("app.color.gray"))
              .width(30)
              .aspectRatio(1)
              .onClick(() => {
                this.onRightClick()
              })
          }
        }
      }
    }
    .width("100%")
    .constraintSize({
      minHeight: 50
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }
}