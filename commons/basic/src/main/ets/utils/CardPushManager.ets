import { NetworkDownloadManager } from "./NetworkDownloadManager";
import { fileIo } from "@kit.CoreFileKit";
import { CIPStorageManager } from "./CIPStorageManager";
import { formBindingData, formProvider } from "@kit.FormKit";

export class CardPushManager {
  private static sInstance: CardPushManager;
  private constructor() {} // 私有构造函数

  public static getInstance(): CardPushManager {
    if (!CardPushManager.sInstance) {
      CardPushManager.sInstance = new CardPushManager();
    }
    return CardPushManager.sInstance;
  }

  /**
   * 推送图片列表到卡片
   * @param list 图片列表 调用者传入形参
   */
  async pushImageList(list: string[]) {
    const fileList = await NetworkDownloadManager.getInstance().downLoadMulti(list) // 获取图片列表
    let formImages: Record<string, number> = {}
    fileList.forEach(url => {
      const file = fileIo.openSync(url, fileIo.OpenMode.READ_ONLY)
      formImages[url] = file.fd // 接收文件句柄 uri -> fd
    })
    const formIdList = await CIPStorageManager.getInstance().getFormIdList() // 获取所有卡片formId
    const data = formBindingData.createFormBindingData({
      formImages,
      list: fileList // 3张图片
    })
    formIdList.forEach(formId => {
      formProvider.updateForm(formId, data)
    })
  }
}