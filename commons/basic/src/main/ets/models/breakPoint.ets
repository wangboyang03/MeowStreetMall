export enum BreakPointEnum {
  XS = "xs",
  SM = "sm",
  MD = "md",
  LG = "lg"
}

interface BreakPointOption<T> {
  xs?: T
  sm?: T
  md?: T
  lg?: T
}

export class BreakPointType<T> {
  breakPointOptions: BreakPointOption<T> = {}

  constructor(options: BreakPointOption<T>) {
    this.breakPointOptions = options // 将传入的断点的值赋值给对象
  }

  getValue(breakPoint: BreakPointEnum): T {
    return (this.breakPointOptions as object)[breakPoint]
  }
}