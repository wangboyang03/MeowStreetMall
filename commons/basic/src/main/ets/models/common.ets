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
