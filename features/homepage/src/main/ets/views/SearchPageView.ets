import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, PAGE_PATH } from "basic";
import { AppStorageV2, KeyboardAvoidMode } from "@kit.ArkUI";
import { AudioSearch } from "../components/AudioSearch";

@HMRouter({ pageUrl: PAGE_PATH.SEARCH_PAGE })
@ComponentV2
export struct SearchPageView {
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, ()=> new AppSafeArea())! // 安全区避让对象
  @Local keyword: string = '' // 搜索关键词

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE) // 键盘避让
  }
  build() {
    Column() {
      /*SearchBox({ keyword: this.keyword, onSearchSubmit: (value: string) => {
        HMRouterMgr.push({
          pageUrl: PAGE_PATH.SEARCH_RESULT_PAGE,
          param: { keyword: value }
        })
      }})*/
      Row() {
        Image($r('[basic].media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('[basic].color.white'))
          .margin(13)
          .onClick(() => {
            HMRouterMgr.pop()
          })
        Search({ placeholder: '请输入商品关键字', value: this.keyword })
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
          .onSubmit((value) => {
            HMRouterMgr.push({
              pageUrl: PAGE_PATH.SEARCH_RESULT_PAGE,
              param: { keyword: value }
            })
          })
      }
      .padding({ top: this.safeAreaObject.topHeight, right: 16 })
      .linearGradient({
        angle: 135,
        colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
      })

      // voice_searchItem
      AudioSearch({
        onComplete: (keyword) => {
          this.keyword = keyword
          HMRouterMgr.push({
            pageUrl: PAGE_PATH.SEARCH_RESULT_PAGE,
            param: { keyword: this.keyword }
          })
        }
      })
    }
    .padding({
      bottom: this.safeAreaObject.bottomHeight
    })
  }
}