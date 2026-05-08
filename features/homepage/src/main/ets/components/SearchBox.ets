import { AppSafeArea, PAGE_PATH } from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { HMRouterMgr } from "@hadss/hmrouter";

@ComponentV2
export struct SearchBox {
  @Param keyword: string = '';
  @Event onSearchSubmit: (value: string) => void; // 触发搜索行为下沉到业务
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())! // 安全区避让对象

  build() {
    Row() {
      Image($r('[basic].media.ic_public_left'))
        .width(24)
        .aspectRatio(1)
        .fillColor($r('[basic].color.white'))
        .margin(13)
        .onClick(() => HMRouterMgr.pop())
      Search({ placeholder: '商品关键字...', value: $$this.keyword })
        .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
        .placeholderColor($r('[basic].color.gray'))
        .placeholderFont({ size: 14 })
        .searchButton('搜索', { fontSize: 14, fontColor: $r('[basic].color.red') })
        .backgroundColor($r('[basic].color.white'))
        .textFont({ size: 14 })
        .layoutWeight(1)
        .padding(0)
        .margin(0)
        .height(36)
        .caretStyle({ color: $r('[basic].color.red') })
        .defaultFocus(true)
        .onSubmit((value) => this.onSearchSubmit?.(value))
    }
    .padding({ top: this.safeAreaObject.topHeight, right: 16 })
    .linearGradient({
      angle: 135,
      colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
    })
  }
}