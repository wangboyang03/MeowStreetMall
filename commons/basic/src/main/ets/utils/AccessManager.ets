import { Permissions, bundleManager, abilityAccessCtrl } from "@kit.AbilityKit";

export class AccessManager {
  private static sInstance: AccessManager;
  private constructor() {} // 私有构造函数
  public static getInstance(): AccessManager {
    if (!AccessManager.sInstance) {
      AccessManager.sInstance = new AccessManager();
    }
    return AccessManager.sInstance;
  }
   /**
    * 检查权限
    */
  async checkPermission(permissions: Permissions[], success: () => void, fail?: () => void) {
    const bundleInformation = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION) // 获取信息
    const manager = abilityAccessCtrl.createAtManager() // 创建鉴权管理器
    const listResult = permissions.map(permission => manager.checkAccessTokenSync(bundleInformation.appInfo.accessTokenId, permission)) // 获取权限列表

    const hasPermission = listResult.every(res => res == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) // 检查所有权限结果
    if (!!hasPermission) {
      success()
    } else {
      // 第一次申请权限
      const result = await manager.requestPermissionsFromUser(getContext(), permissions)
      const againCheck = result.authResults.every(res => res == 0) // 再次检查
      if (!!againCheck) {
        success()
      } else {
        // 第二次申请权限 拉起设置面板
        const secondResult = await manager.requestPermissionOnSetting(getContext(), permissions)
        const checkResult = secondResult.every(res => res == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
        if (checkResult) {
          success()
        } else {
          // 没招了。
          fail?.()
        }
      }
    }
  }
}