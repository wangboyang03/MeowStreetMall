import { GoodsItem, SkuType, Spec } from "basic";

/**
 * 商品属性
 */
export interface GoodsProperty {
  name: string;
  value: string;
}

export interface GoodsDetail {
  pictures: string[];
  properties: GoodsProperty[];
}

export interface Goods extends GoodsItem {
  inventory: number
  mainPictures: string[]
  details: GoodsDetail
  specs: Spec[]
  skus: SkuType[]
}

export interface SpecValue {
  name: string
  picture: string | null
  selected: boolean | null
  disabled: boolean | null
}