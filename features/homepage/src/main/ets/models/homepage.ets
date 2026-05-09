import { GoodsItem, GoodsItems } from "basic";

export interface Banner {
  id: string;
  imgUrl: string;
  type: string;
}

export interface Params {
  title: string,
  subTitle: string,
  bg: ResourceStr,
  list: GoodsItem[]
}

export enum DiscountType {
  COMMAND,
  DISCOUNT,
  NEW
}

// 推荐
export interface HotRecommend {
  id: string;
  subTypes: SubType[];
  title: string;
}

export interface SubType {
  id: string;
  title: string;
  goodsItems: GoodsItems;
}

// 猜喜列表请求的参数类型
export interface RecommendParams {
  limit: number // 条数
}