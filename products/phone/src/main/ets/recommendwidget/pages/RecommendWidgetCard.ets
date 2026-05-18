@Entry
@Component
struct RecommendWidgetCard {
  /*
   * The title.
   */
  readonly title: string = 'Hello World';
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'PhoneAbility';
  /*
   * The message.
   */
  readonly message: string = 'add detail';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';
  @State count: number = 1
  @LocalStorageProp("formId") @Watch("updateForm") formId: string = ""
  @LocalStorageProp("cartCount") cartCount: number = 0 // 购物车商品数量

  updateForm() {
    if (!!this.formId) {
      postCardAction(this, {
        action: 'call',
        abilityName: 'PhoneAbility', // abilityName
        params: {
          formId: this.formId, // 传递参数
          method: "receiveFormId" // 方法名称
        }
      })
    }
  }

  build() {
    /*Row() {
      Column() {
        Text(this.title)
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font'))
      }
      .width(this.fullWidthPercent)
    }
    .height(this.fullHeightPercent)
    .backgroundColor($r('sys.color.comp_background_primary'))
    .onClick(() => {
      postCardAction(this, {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.message
        }
      });
    })*/
    Column({ space: 20 }) {
      Text(`购物车数量是${this.cartCount}`)
    }
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height("100%")
    .backgroundColor(Color.Pink)
  }
}