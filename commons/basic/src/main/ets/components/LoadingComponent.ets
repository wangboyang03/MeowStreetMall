@ComponentV2
export struct LoadingComponent {
  @Param imageWidth: number = 80 // 图标宽度
  build() {
    Stack({ alignContent: Alignment.Center }) {
      ImageAnimator().images([
          {
            src: $r("app.media.loading_01")
          },
          {
            src: $r("app.media.loading_02")
          },
          {
            src: $r("app.media.loading_03")
          },
          {
            src: $r("app.media.loading_04")
          }
        ])
        .state(AnimationStatus.Running)
        .iterations(-1)// 无限运行动画
        .width(this.imageWidth)
        .aspectRatio(3)
    }
    .width("100%")
    .height("100%")
  }
}