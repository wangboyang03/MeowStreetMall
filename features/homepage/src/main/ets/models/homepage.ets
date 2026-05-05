import { GoodsItem } from "basic";

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

export interface GoodsItems {
  counts: number;
  items: GoodsItem[];
  page: number;
  pages: number;
  pageSize: number;
}
