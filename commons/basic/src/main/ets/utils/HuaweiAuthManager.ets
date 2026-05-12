import { authentication } from "@kit.AccountKit";
import { util } from "@kit.ArkTS";

export class HuaweiAuthManager {
  private static sInstance: HuaweiAuthManager;
  private constructor() {} // 私有构造函数

  public static getInstance(): HuaweiAuthManager {
    if (HuaweiAuthManager.sInstance == null) {
      HuaweiAuthManager.sInstance = new HuaweiAuthManager();
    }
    return HuaweiAuthManager.sInstance;
  }

  // 拉起华为登录
  async launchAuth() {
    try {
      // 1.创建授权请求
      const request = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest()
      request.scopes = ['phone'] // 2.传递参数
      request.permissions = ['serviceauthcode']; // 获取code需传如下permission
      request.forceAuthorization = true; // 强制授权
      request.state = util.generateRandomUUID(); // 随机UUID 返回的state要和这个UUID对得上 没对上就说明有人篡改请求
      const controller = new authentication.AuthenticationController(getContext()) // 实例化控制器
      const result = await controller.executeRequest(request) as authentication.AuthorizationWithHuaweiIDResponse
      // 根据结果判断
      if (request.state === result.state) {
        return result.data?.authorizationCode // 正常请求
      } else {
        // reject
        return Promise.reject(new Error("Rejected, Huawei account login request has been tampered with."))
      }
    } catch (error) {
      // 日志.
      // reject
      return Promise.reject(new Error(error))
    }

  }

  // 退出登录
  async exitAuth() {
    const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest()
    const controller = new authentication.AuthenticationController()
    await controller.executeRequest(cancelRequest)

  }
}