import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { AppSafeArea, PAGE_PATH } from "basic";
import { AppStorageV2 } from "@kit.ArkUI";
import { SearchBox } from "../components";

@HMRouter({ pageUrl: PAGE_PATH.SEARCH_PAGE })
@ComponentV2
export struct SearchPageView {
  safeAreaObject: AppSafeArea = AppStorageV2.connect(AppSafeArea, ()=> new AppSafeArea())! // 安全区避让对象
  @Local keyword: string = '输入想要搜索的商品...' // 搜索关键词

  build() {
    Column() {
      // searchBox
      SearchBox({ keyword: this.keyword, onSearchSubmit: (value: string) => {
        HMRouterMgr.push({
          pageUrl: PAGE_PATH.SEARCH_RESULT_PAGE,
          param: { keyword: value }
        })
      }})
      // voice_searchItem
    }
  }
}