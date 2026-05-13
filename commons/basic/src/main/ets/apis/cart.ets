import { RequestRemoteCommunication } from "../utils";
import { AddCartParams, CartCount } from "../models";

export const addShoppingCartApi = (data: AddCartParams) => RequestRemoteCommunication.post<null>("/member/cart", data)

export const getShoppingCartCountApi = () => RequestRemoteCommunication.get<CartCount>("/member/cart/count")