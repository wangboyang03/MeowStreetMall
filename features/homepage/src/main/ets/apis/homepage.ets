import { CategoryItem, GoodsItem, RequestRemoteCommunication } from "basic"
import { Banner, Goods, GoodsParams, HotRecommend, RecommendParams } from "../models"

// 获取轮播图
export const getBannerApi = () => {
  return RequestRemoteCommunication.get<Banner[]>("/home/banner")
}

//
export const getCategoryApi = () => {
  return RequestRemoteCommunication.get<CategoryItem[]>("/home/category/head")
}

// 获取特惠推荐
export const getHotRecommendApi = () => {
  return RequestRemoteCommunication.get<HotRecommend>("/hot/preference")
}

// 获取爆款推荐
export const getInVogueApi = () => {
  return RequestRemoteCommunication.get<HotRecommend>("/hot/inVogue")
}

// 获取一站买全
export const getOneStopApi = () => {
  return RequestRemoteCommunication.get<HotRecommend>("/hot/oneStop")
}

// 获取新鲜好物
export const getHomePageNewApi = () => {
  return RequestRemoteCommunication.get<GoodsItem[]>("/home/new")
}

/**
 * 获取猜喜
 * @param params 请求入参
 */
export const getRecommendApi = (params: RecommendParams) => {
  return RequestRemoteCommunication.get<GoodsItem[]>("/home/recommend", params)
}

/**
 *
 */
export const getGoodsDetailApi = (params: GoodsParams) => {
  return RequestRemoteCommunication.get<Goods>("/goods", params)
}