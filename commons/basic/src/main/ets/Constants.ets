export class Constants {
  static readonly BASE_URL = 'https://meikou-api.itheima.net'; // 网络请求基地址
  static readonly SUCCESS_TYPE = '1'; // 成功标识
  static readonly TIME_OUT = 600000; // 超时时间
  static readonly TIP_SOUND: string = "sound.mp3"
  static readonly SWITCH_TAB: string = 'switch_tab'
}

export class PAGE_PATH {
  static readonly MAIN_PAGE_ID: string = "homepage"
  static readonly MAIN_PAGE: string = "HomePageView"
  static readonly SEARCH_PAGE: string = "SearchPageView"
  static readonly SEARCH_RESULT_PAGE: string = "SearchResultPageView"
  static readonly LOGIN_PAGE: string = "LoginPageView"
  static readonly SETTING_PAGE: string = "SettingPageView"
  static readonly GOODS_PAGE: string = "GoodsPageView"
  static readonly SHOPPING_CART_PAGE: string = "CartView"
  static readonly ADDRESS_PAGE: string = "AddressPageView"
  static readonly CREATE_ADDRESS_PAGE: string = "CreateAddressPageView"
  static readonly CHECK_ORDER_PAGE: string = "CheckOrderPageView"
}

/**
 * 声音状态枚举
 */
export enum VoiceState {
  DEFAULT, // 没有激活状态
  VOICING, // 正在录音
  VOICEOVER // 錄音結束
}