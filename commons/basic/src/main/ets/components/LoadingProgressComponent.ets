@ComponentV2
export struct LoadingProgressComponent {
  @Param progressWidth: number = 80
  @Param strokeWidth: number = 4
  @Param progressColor: ResourceColor = $r("app.color.red")
  @Local angle: number = 0
  @Local value: number = 40 // 40 -> 80 80 -> 40
  isRight: boolean = true // 是否是正向追加
  timer: number = -1 // 定时器句柄

  /**
   * 开始运行
   * 顺时针转到80时开始掉头 逆时针转到40时再掉头
   */
  startRun() {
    this.timer = setInterval(() => {
      if (this.value >= 80) {
        this.isRight = false
      }
      if (this.value <= 40) {
        this.isRight = true
      }
      if (this.isRight) {
        this.value++
      } else {
        this.value--
      }
    }, 100)
  }

  aboutToAppear(): void {
    this.startRun()
  }

  aboutToDisappear(): void {
    clearInterval(this.timer) // 清理句柄 避免内存泄露
  }

  build() {
    Progress({ total: 100, value: this.value, type: ProgressType.Ring })
      .color(this.progressColor)
      .rotate({
        angle: this.angle
      })
      .style({
        strokeWidth: this.strokeWidth
      })
      .width(this.progressWidth)
      .aspectRatio(1)
      .onAppear(() => this.getUIContext().animateTo({ iterations: -1, duration: 1500 }, () => this.angle = 360))
  }
}