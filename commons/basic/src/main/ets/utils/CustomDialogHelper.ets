import { LoadingOption } from "../models";
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
}

@Builder
function LoadingBuilder(options?: LoadingOption) {
  Column({ space: 20 }) {
    LoadingProgressComponent({
      progressWidth: options?.pWidth ?? 40,
      strokeWidth: options?.strokeWidth ?? 8,
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
