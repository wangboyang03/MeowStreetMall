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

// 搜索結果商品信息
export interface GoodsItems {
  counts: number;
  items: GoodsItem[];
  page: number;
  pages: number;
  pageSize: number;
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

/**
 * 云端购物车单品的数据类型
 */
export interface CartGoods {
  count: number;
  id: string;
  name: string;
  picture: string;
  price: number;
  selected: boolean;
  skuId: string;
  stock: number;
  attrsText: string;
}

@ObservedV2
export class CartGoodsModel implements CartGoods {
  @Trace count: number = 0
  id: string = ''
  name: string = ''
  picture: string = ''
  price: number = 0
  selected: boolean = false
  skuId: string = ''
  stock: number = 0
  attrsText: string = ''

  constructor(model: CartGoods) {
    this.count = model.count
    this.id = model.id
    this.name = model.name
    this.picture = model.picture
    this.price = model.price
    this.selected = model.selected
    this.skuId = model.skuId
    this.stock = model.stock
    this.attrsText = model.attrsText
  }
}