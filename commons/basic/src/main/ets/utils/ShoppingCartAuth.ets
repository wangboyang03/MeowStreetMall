import { AppStorageV2, PersistenceV2 } from "@kit.ArkUI";
import { getShoppingCartCountApi } from "../apis/cart";
import { AppShoppingCart, AppUserCenter } from "../models/common";

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
      const res = await getShoppingCartCountApi()
      appShoppingCart.count = res.count
    } else {
      appShoppingCart!.count = 0
    }
  }
}