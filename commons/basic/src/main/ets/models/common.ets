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