/**
 * 每一项的商品信息
 */
export interface GoodsItem {
  id: string
  name: string
  desc?: string
  price: string
  picture: ResourceStr
  orderNum?: number // 已购数量
  payCount?: number; // 猜喜特有
}

/**
 * 二级子类信息
 */
export interface CategoryItemChild {
  id: string
  name: string
  picture: ResourceStr
}

/**
 * 一级子类信息 包含子类与关联商品
 */
export interface CategoryItem {
  children?: CategoryItemChild[]
  goods?: GoodsItem[]
  id: string
  name: string
  picture: ResourceStr
}

// 猜喜的参数
export interface GuessParams {
  page: number
  pageSize: number
}

/**
 * 搜索和猜喜返回的类型
 */
export interface SingleGoodsItem {
  counts: number;
  items: GoodsItem[];
  page: number;
  pages: number;
  pageSize: number;
}