import { AppStorageV2, display, window } from "@kit.ArkUI"
import { BreakPointEnum } from "../models/breakPoint"
import { AppBreakPoint } from "../models/common"

export class ScreenManager {
  private static sInstance?: ScreenManager
  mContext?: Context // 上下文对象
  private constructor() {} // 私有构造函数
  // 单例模式
  static getInstance(): ScreenManager {
    if (!ScreenManager.sInstance) {
      ScreenManager.sInstance = new ScreenManager()
    }
    return ScreenManager.sInstance
  }

  // 异步获取window对象
  getWindowObject() {
    return window.getLastWindow(this.mContext ?? getContext())
  }

  // 注册屏幕宽度改变监听
  async registerScreenWidthChange() {
    const windowObject = await this.getWindowObject() // 获取window对象
    this.judgeScreen(px2vp(display.getDefaultDisplaySync().width)) // 先手动判断一次
    windowObject.on("windowSizeChange", (size)=> this.judgeScreen(px2vp(size.width))) // 监听变化去修改断点
  }

  // 取消注册监听
  async unRegisterWindowSizeChange() {
    const windowObject = await this.getWindowObject() // 获取window对象
    windowObject.off("windowSizeChange")
  }

  /**
   * 判断屏幕
   * @param width 屏幕宽度
   */
  judgeScreen(width: number) {
    let breakPoint:BreakPointEnum = BreakPointEnum.XS
    if (width>0 && width<320) {
      breakPoint = BreakPointEnum.XS
    }  else if (width >= 320 && width < 520) {
      breakPoint = BreakPointEnum.SM
    } else if (width >= 520 && width < 840) {
      breakPoint = BreakPointEnum.MD
    } else {
      breakPoint = BreakPointEnum.LG
    }
    // 存储内存 AppStorage.setOrCreate("key", "value")
    const appStorage = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())
    if (appStorage != undefined) {
      appStorage.breakPoint = breakPoint // 将断点值存入到全局状态
    }
  }
}