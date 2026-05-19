import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { CIPStorageManager, PAGE_PATH, ScreenManager } from 'basic';
import { HMRouterMgr } from '@hadss/hmrouter';
import { rpc } from '@kit.IPCKit';
import { emitter } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;

export default class PhoneAbility extends UIAbility {
  private toUrl: string = "" // 跳转的页面

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      HMRouterMgr.init({
        context: this.context
      })
      CIPStorageManager.getInstance().mContext = this.context // 获取上下文
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      this.callee.on("receiveFormId", (data) => {
        const object = JSON.parse(data.readString()) as object
        const formId = object["formId"] as string
        CIPStorageManager.getInstance().saveFormId(formId) // 存盘
        return new Params()
      })
      this.toUrl = want.parameters!["toUrl"] as string // 此时窗口尚未绘制 因此只做接收参数 不跳转
      this.callee.on("updateRecommend", () => {
        emitter.emit("updateRecommend") // 广播推荐页面进行更新
        return new Params()
      })
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const url = want.parameters!["toUrl"] // 获取跳转的页面
    if (url == 'recommend') {
      const stack = HMRouterMgr.getPathStack(PAGE_PATH.MAIN_PAGE_ID) // 获取路由栈
      if (stack?.getAllPathName().pop() != PAGE_PATH.RECOMMEND_PAGE) {
        HMRouterMgr.push({ pageUrl: PAGE_PATH.RECOMMEND_PAGE })
      }
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    ScreenManager.getInstance().mContext = this.context; // 获取当前上下文
    ScreenManager.getInstance().registerScreenWidthChange() // 从启动器注册屏幕宽度改变监听
    ScreenManager.getInstance().fullScreenMode() // 开启沉浸式
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
      setTimeout(() => {
        if (this.toUrl) {
          HMRouterMgr.push({ pageUrl: PAGE_PATH.RECOMMEND_PAGE })
        }
      }, 100)
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    ScreenManager.getInstance().unRegisterWindowSizeChange() // 取消监听
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

class Params implements rpc.Parcelable {
  marshalling(dataOut: rpc.MessageSequence): boolean {
    return true
  }
  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    return true
  }
}