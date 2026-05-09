@ComponentV2
export struct NavigationColumnComponent {
  @Param itemIcon: ResourceStr = ''
  @Param label: string = ''
  @Param labelColor: ResourceColor = $r('app.color.black')

  build() {
    GridCol() {
      Column() {
        Image(this.itemIcon)
          .width(24)
          .aspectRatio(1)
        Text(this.label)
          .fontColor(this.labelColor)
          .fontSize(12)
          .lineHeight(22)
          .margin({ top: 4 })
      }
      .padding({ top: 16, bottom: 10 })
    }
  }
}