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

/**
 * 加入购物车的参数类型
 */
export interface AddCartParams {
  skuId: string
  count: number
}

export interface CartCount {
  count: number
}

/**
 * 更新购物车数量
 */
export interface UpdateCartCount {
  selected: boolean
  count: number
}

/**
 * 删除购物车内商品
 */
export interface DeleteCartGoods {
  ids: string[]
}

/**
 * 地址
 */
export interface AddressItem {
  address: string
  contact: string
  fullLocation: string
  id: string
  isDefault: 0 | 1
  receiver: string
  provinceCode: number
  cityCode: number
  countyCode: number
}

/**
 * 商品订单
 */
export interface OrderGoodsItem {
  attrsText: string;
  count: number;
  id: string;
  name: string;
  payPrice: string;
  picture: string;
  price: string;
  skuId: string;
  totalPayPrice: string;
  totalPrice: string;
}

/**
 * 摘要
 */
export interface Summary {
  discountPrice: number;
  goodsCount: number;
  postFee: number;
  totalPayPrice: number;
  totalPrice: number;
}

/**
 * 预创建订单
 */
export interface PrepaymentCreatedOrders {
  goods: OrderGoodsItem[]
  userAddresses: AddressItem[]
  summary: Summary
}

/**
 * 创建订单参数
 */
export interface CreateOrderParamsGoods {
  skuId: string
  count: number
}

/**
 * 生成订单参数
 */
export interface CreateOrderParams {
  deliveryTimeType: number
  payType: number
  buyerMessage: string
  payChannel: number
  goods: CreateOrderParamsGoods[]
  addressId: string
}

/**
 * 创建订单结果
 */
export interface CreateOrderResult {
  id: string
}

/**
 * 订单项
 */
export interface OrderItem {
  countdown: number;
  createTime: string;
  id: string;
  orderState: 1 | 2 | 3 | 4 | 5 | 6;
  payChannel: number;
  payLatestTime: string;
  payMoney: number;
  payType: number;
  postFee: number;
  skus: OrderSku[];
  totalMoney: number;
  totalNum: number;
}

/**
 * 订单Sku
 */
export interface OrderSku {
  attrsText: string;
  curPrice: number;
  id: string;
  image: string;
  name: string;
  properties: Property[];
  quantity: number;
  realPay: number;
  spuId: string;
}

/**
 * 订单属性
 */
export interface Property {
  propertyMainName: string;
  propertyValueName: string;
}

/**
 * 支付方式枚舉
 */
export enum PayChannel {
  WeChat = '微信支付',
  Alipay = '支付宝',
  HuaweiPay = '华为支付'
}