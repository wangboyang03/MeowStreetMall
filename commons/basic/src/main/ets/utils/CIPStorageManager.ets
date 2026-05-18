import { preferences } from "@kit.ArkData";
import { Constants } from "../Constants";

export class CIPStorageManager {
  private static sInstance: CIPStorageManager;
  mContext?: Context
  private constructor() {} // 私有构造函数

  public static getInstance(): CIPStorageManager {
    if (!CIPStorageManager.sInstance) {
      CIPStorageManager.sInstance = new CIPStorageManager();
    }
    return CIPStorageManager.sInstance;
  }

  /**
   * 同步读盘 获取存储信息
   */
  private getStorage() {
    return preferences.getPreferencesSync(this.mContext ?? getContext(), {
     name: Constants.STORAGE_NAME
    })
  }

  /**
   * 获取卡片id列表
   */
  async getFormIdList() {
    const CIPStorage = await this.getStorage() // 获取存储信息
    return CIPStorage.getSync(Constants.FORM_NAME, []) as string[]
  }

  /**
   * 存储卡片id
   * @param formId 卡片id
   */
  async saveFormId(formId: string) {
    const CIPStorage = await this.getStorage() // 获取存储信息
    const formIdList = await this.getFormIdList()
    formIdList.push(formId)
    CIPStorage.putSync(Constants.FORM_NAME, formIdList) // 写入首选项
    CIPStorage.flushSync() // 写入磁盘
  }
}