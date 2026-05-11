import { CategoryItem } from ".";
import { BreakPointEnum } from "./breakPoint";

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
@ObservedV2
export class UserInformation {
  @Trace token: string = ""
  @Trace nickname: string = ""
  @Trace avatar: string = ""
  @Trace account: string = ""
}