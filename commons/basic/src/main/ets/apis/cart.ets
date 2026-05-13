import { RequestRemoteCommunication } from "../utils";
import { AddCartParams } from "../models";

export const addShoppingCartApi = (data: AddCartParams) => RequestRemoteCommunication.post<null>("/member/cart", data)