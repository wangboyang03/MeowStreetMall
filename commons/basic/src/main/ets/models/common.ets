import { CartGoodsModel, CategoryItem } from ".";
import { BreakPointEnum } from "./breakPoint";
import { Type } from "@kit.ArkUI";

@ObservedV2
export class AppBreakPoint {
  @Trace breakPoint: BreakPointEnum = BreakPointEnum.XS // 默认视图断点为XS
}

@ObservedV2
export class AppSafeArea {
  @Trace topHeight: number = 0
  @Trace bottomHeight: number = 0
}

export interface ResponseData<T> {
  code: string
  message: string
  result: T
}

// 存储应用间共享数据
@ObservedV2
export class AppSharedData {
  @Trace category: CategoryItem[] = [] // 分类列表
}

/**
 * 解耦彈窗渲染參數
 */
export interface LoadingOption {
  title?: string
  color?: ResourceColor
  pWidth?: number
  strokeWidth?: number
}

export interface ConfirmOption {
  message: string
  leftText: string
  rightText: string
  leftColor: ResourceColor
  rightColor: ResourceColor
  onLeftClick: () => void
  onRightClick: () => void
}

/**
 * 持久化存儲用戶信息
 */
export interface UserInformation {
  token: string
  nickname: string
  avatar: string
  account: string
}

/**
 * 全局用户类型
 */
@ObservedV2
export class User implements UserInformation {
  @Trace token: string = ''
  @Trace avatar: string = ''
  @Trace nickname: string = ''
  @Trace account: string = ''
}

@ObservedV2
export class AppUserCenter {
  @Type(User) // 序列化复杂数据类型的时候需要用Type修饰这个持久化的属性
  @Trace user: User = new User()
}

/**
 * 全局购物袋
 */
@ObservedV2
export class AppShoppingCart {
  @Trace count: number = 0
  @Trace cartList: CartGoodsModel[] = []
}