import { RequestRemoteCommunication } from "../utils";
import { AddCartParams, CartCount, CartGoods, UpdateCartCount } from "../models";

export const addShoppingCartApi = (data: AddCartParams) => RequestRemoteCommunication.post<null>("/member/cart", data)

export const getShoppingCartCountApi = () => RequestRemoteCommunication.get<CartCount>("/member/cart/count")

export const getShoppingCartListApi = () => RequestRemoteCommunication.get<CartGoods[]>("/member/cart")

export const updateShoppingCartApi = (skuId: string, data: UpdateCartCount) => RequestRemoteCommunication.put<null>(`/member/cart/${skuId}`, data)