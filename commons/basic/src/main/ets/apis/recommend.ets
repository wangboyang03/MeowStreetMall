import { GoodsItems } from "../models";
import { RequestRemoteCommunication } from "../utils";

export const getGlobalRecommendApi = (params: object) => RequestRemoteCommunication.get<GoodsItems>("/home/goods/guessLike", params)