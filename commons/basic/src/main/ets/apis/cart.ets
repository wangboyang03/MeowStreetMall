import { RequestRemoteCommunication } from "../utils";
import { AddCartParams, CartCount, CartGoods } from "../models";

export const addShoppingCartApi = (data: AddCartParams) => RequestRemoteCommunication.post<null>("/member/cart", data)

export const getShoppingCartCountApi = () => RequestRemoteCommunication.get<CartCount>("/member/cart/count")

export const getShoppingCartListApi = () => RequestRemoteCommunication.get<CartGoods[]>("/member/cart")