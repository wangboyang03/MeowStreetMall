@ComponentV2
export struct EmptyContentComponent {
  @Param title: string = "空空如也"
  @Param buttonLabel: string = "去逛逛?"
  @Param icon: ResourceStr = $r("app.media.ic_public_empty")
  @Event onButtonClick: () => void = () => {}

  build() {
    Column({ space: 20 }) {
      Image(this.icon)
        .width(120)
        .aspectRatio(1)
      Text(this.title)
        .fontSize(12)
        .fontColor($r("app.color.gray"))
      Button(this.buttonLabel)
        .height(30)
        .fontSize(12)
        .padding({ left: 10, right: 10 })
        .fontColor($r("app.color.white"))
        .linearGradient({
          angle: 90,
          colors: [['#FD3F8F', 0], ['#FF773C', 1]]
        })
        .onClick(() => this.onButtonClick())
    }
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .padding({
      top: 20,
      bottom: 80
    })
  }
}