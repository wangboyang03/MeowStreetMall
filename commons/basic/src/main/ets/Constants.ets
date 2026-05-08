export class Constants {
  static readonly BASE_URL = 'https://meikou-api.itheima.net'; // 网络请求基地址
  static readonly SUCCESS_TYPE = '1'; // 成功标识
  static readonly TIME_OUT = 600000; // 超时时间
  static readonly TIP_SOUND: string = "sound.mp3"
}

export class PAGE_PATH {
  static readonly MAIN_PAGE_ID: string = "homepage"
  static readonly MAIN_PAGE: string = "HomePageView"
  static readonly SEARCH_PAGE: string = "SearchPageView"
  static readonly SEARCH_RESULT_PAGE: string = "SearchResultPageView"
}