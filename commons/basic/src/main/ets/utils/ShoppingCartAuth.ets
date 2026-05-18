import { AppStorageV2, PersistenceV2 } from "@kit.ArkUI";
import { getShoppingCartListApi } from "../apis";
import { getShoppingCartCountApi } from "../apis/cart";
import { CartGoodsModel } from "../models/business";
import { AppShoppingCart, AppUserCenter } from "../models/common";
import { CIPStorageManager } from "./CIPStorageManager";
import { formBindingData, formProvider } from "@kit.FormKit";

export class ShoppingCartAuth {
  private static sInstance: ShoppingCartAuth;
  private constructor() {} // 私有构造函数

  public static getInstance(): ShoppingCartAuth {
    if (!ShoppingCartAuth.sInstance) {
      ShoppingCartAuth.sInstance = new ShoppingCartAuth();
    }
    return ShoppingCartAuth.sInstance;
  }

  /**
   * 更新用户的购物车数量和列表
   */
  async updateCartCount() {
    const user = PersistenceV2.connect(AppUserCenter, () => new AppUserCenter())
    const appShoppingCart = AppStorageV2.connect(AppShoppingCart, () => new AppShoppingCart())
    if (!!user?.user.token && !!appShoppingCart) {
      // 获取购物车商品数量
      const res = await getShoppingCartCountApi()
      appShoppingCart.count = res.count
      // 获取购物车列表
      const list = await getShoppingCartListApi()
      appShoppingCart.cartList = list.map(item => new CartGoodsModel(item)) // ObservedV2必须实例化才具备响应式
      this.pushCardDataWithCartCount(appShoppingCart.count)
    } else {
      this.pushCardDataWithCartCount(0)
      appShoppingCart!.count = 0
      appShoppingCart!.cartList = []
    }
  }

  /**
   * 推送购物车数量到卡片
   */
  async pushCardDataWithCartCount(count: number) {
    const formIdList = await CIPStorageManager.getInstance().getFormIdList()
    const data = formBindingData.createFormBindingData({
      "cartCount": count
    }) // 創建卡片和应用工程数据桥
    formIdList.forEach(formId => formProvider.updateForm(formId, data))
  }
}