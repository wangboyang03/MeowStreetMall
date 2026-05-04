/**
 * 每一项的商品信息
 */
export interface GoodsItem {
  id: string
  name: string
  desc: string
  price: string
  picture: ResourceStr
  orderNum: number // 已购数量
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