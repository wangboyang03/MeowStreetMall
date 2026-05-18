import { RequestRemoteCommunication } from "../utils";
import { AddCartParams, CartCount, CartGoods, DeleteCartGoods, PrepaymentCreatedOrders, UpdateCartCount } from "../models";

export const addShoppingCartApi = (data: AddCartParams) => RequestRemoteCommunication.post<null>("/member/cart", data)

export const getShoppingCartCountApi = () => RequestRemoteCommunication.get<CartCount>("/member/cart/count")

export const getShoppingCartListApi = () => RequestRemoteCommunication.get<CartGoods[]>("/member/cart")

export const updateShoppingCartApi = (skuId: string, data: UpdateCartCount) => RequestRemoteCommunication.put<null>(`/member/cart/${skuId}`, data)

export const selectOrUnSelectCartApi = (data: UpdateCartCount) => RequestRemoteCommunication.put<null>("/member/cart/selected", data)

export const deleteCartGoodsApi = (data: DeleteCartGoods) => RequestRemoteCommunication.delete<null>("/member/cart", undefined, data)

export const getPrepaymentOrderApi = () => RequestRemoteCommunication.get<PrepaymentCreatedOrders>(`/member/order/pre`)