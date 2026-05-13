import { ConfirmOption, LoadingOption } from "../models";
import { ComponentContent, promptAction, window } from "@kit.ArkUI";
import { util } from "@kit.ArkTS";
import { LoadingProgressComponent } from "../components/LoadingProgressComponent";

export class CustomDialogHelper {
  private static sInstance: CustomDialogHelper;
  mContext?: Context;
  private mUIContext: UIContext | null = null
  private dialogMap: Map<string, ComponentContent<LoadingOption>> = new Map()

  private constructor() {} // 私有构造函数

  public static getInstance(): CustomDialogHelper {
    if (!CustomDialogHelper.sInstance) {
      CustomDialogHelper.sInstance = new CustomDialogHelper();
    }
    return CustomDialogHelper.sInstance;
  }

  /**
   * 獲取窗口對象
   */
  getWindowObject() {
    return window.getLastWindow(this.mContext ?? getContext())
  }

  /**
   * 初始化UIContext
   */
  async initUIContext() {
    if (!this.mUIContext) {
      const windowObject = await this.getWindowObject()
      this.mUIContext = windowObject.getUIContext()
    }
  }

  showLoading(options?: LoadingOption) {
    let key = ""
    this.initUIContext().then(() => {
      const promptAction = this.mUIContext?.getPromptAction()
      const componentContent = new ComponentContent(this.mUIContext!, wrapBuilder(LoadingBuilder), options as Object)
      key = util.generateRandomUUID() // 生成一个唯一的key
      this.dialogMap.set(key, componentContent)
      promptAction?.openCustomDialog(componentContent)
    })
    // 同步代码
    return () => {
      this.closeLoading(key)
    }
  }

  async closeLoading(key: string) {
    await this.initUIContext()
    const action = this.mUIContext?.getPromptAction()
    const componentContent = this.dialogMap.get(key)
    action?.closeCustomDialog(componentContent)
    this.dialogMap.delete(key) // 删除彈窗
  }

  // 提示消息
  showToast(options: promptAction.ShowToastOptions) {
    this.initUIContext().then(() => {
      this.mUIContext?.getPromptAction().showToast(options)
    })
  }

  // 彈窗
  showAlertDialog(options: promptAction.ShowDialogOptions) {
    this.initUIContext().then(() => {
      this.mUIContext?.getPromptAction().showDialog(options)
    })
  }

  // 確認彈窗
  showConfirmDialog(options?: Partial<ConfirmOption>) {
    let key = ""
    this.initUIContext().then(() => {
      const promptAction = this.mUIContext?.getPromptAction() // 获取弹窗对象
      const emptyFunction = () => {} // 空函数
      const onLeftClick = options?.onLeftClick ?? emptyFunction
      const onRightClick = options?.onRightClick ?? emptyFunction
      // 這樣做是爲了如果有自定義操作 先執行自定義操作 再關閉彈窗
      const leftAction = async () => {
        await onLeftClick()
        this.closeLoading(key)
      }
      const rightAction = async () => {
        await onRightClick()
        this.closeLoading(key)
      }
      if (!!options) {
        options.onLeftClick = leftAction
        options.onRightClick = rightAction
      }
      const componentContent = new ComponentContent(this.mUIContext!, wrapBuilder(ConfirmBuilder), options as Object)
      key = util.generateRandomUUID()
      this.dialogMap.set(key, componentContent)
      promptAction?.openCustomDialog(componentContent)
    })
    return (): Promise<void> => this.closeLoading(key)
  }
}

@Builder function LoadingBuilder(options?: LoadingOption) {
  Column({ space: 20 }) {
    LoadingProgressComponent({
      progressWidth: options?.pWidth ?? 40,
      strokeWidth: options?.strokeWidth ?? 4,
      progressColor: options?.color ?? $r("app.color.white")
    })
    Text(options?.title ?? "加载中...")
      .fontColor(options?.color ?? $r("app.color.white"))
  }
  .justifyContent(FlexAlign.Center)
  .width(120)
  .aspectRatio(1)
  .borderRadius(10)
  .backgroundColor("rgba(0,0,0,0.4)")
}

@Builder function ConfirmBuilder(options?: Partial<ConfirmOption>) {
  Column({ space: 10 }) {
    Row() {
      Text(options?.message ?? "您可能正在执行危险性操作，这些操作一旦生效将无法回滚，需要用户确认。")
    }
    .width("100%")
    .padding({
      top: 30,
      bottom: 30
    })
    .justifyContent(FlexAlign.Center)

    Row() {
      Text(options?.leftText ?? "取消")
        .fontColor(options?.leftColor ?? $r("app.color.gray"))
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .border({
          color: $r("app.color.gray"),
          width: {
            right: 0.5
          }
        })
        .height("100%")
        .onClick(() => {
          options?.onLeftClick?.()
          // if (options) {
          //   options.onLeftClick && options.onLeftClick()
          // }
        })
      Text(options?.rightText ?? "好")
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontColor(options?.rightColor ?? $r("app.color.red"))
        .onClick(() => {
          options?.onRightClick?.()
        })
        .height("100%")
    }
    .height(50)
    .border({
      width: {
        top: 0.5
      },
      color: $r("app.color.gray")
    })
    .width("100%")
  }
  .justifyContent(FlexAlign.Center)
  .width(280)
  .borderRadius(10)
  .backgroundColor($r("app.color.white"))
}