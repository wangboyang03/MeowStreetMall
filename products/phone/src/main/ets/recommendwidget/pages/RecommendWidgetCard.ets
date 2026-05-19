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
  @LocalStorageProp("list") list: string[] = [] // 推荐图片列表

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
    /*Column() {
      Swiper() {
        ForEach(this.list, (url: string) => {
          Image("memory://" + url) // 卡片只能用memory协议
            .width("100%")
            .height("100%")
        })
      }
    }
    .width("100%")
    .height("100%")*/
    RelativeContainer() {
      Button() {
        Image($r("app.media.icon_rays"))
          .width(12)
          .aspectRatio(1)
          .fillColor(Color.White)
      }
      .width(40)
      .height(40)
      .type(ButtonType.Circle)
      .alignRules({
        right: {
          anchor: '__container__',
          align: HorizontalAlign.End
        }
      })
      .onClick(() => {
        postCardAction(this, {
          action: 'call',
          abilityName: 'PhoneAbility',
          params: {
            method: 'updateRecommend'
          }
        })
      })
      .zIndex(2)

      if (this.list.length) {
        Swiper() {
          ForEach(this.list, (url: string) => {
            // 卡片上显示图片需要加上memory 内存协议
            Image("memory://" + url)
              .width("100%")
              .height("100%")
          })
        }
      } else {
        Image($r("[basic].media.ic_public_empty"))
          .width(40)
          .aspectRatio(1)
          .fillColor(Color.Orange)

      }
    }
    .padding(10)
    .backgroundColor("#ff73987a")
    .width("100%")
    .height("100%")
    .onClick(() => {
      postCardAction(this, {
        action: 'router',
        abilityName: 'PhoneAbility',
        params: {
          toUrl: 'recommend'
        }
      })
    })
  }
}