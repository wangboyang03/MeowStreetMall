import { taskpool, util, worker } from "@kit.ArkTS";
import { RequestRemoteCommunication } from "./NetworkRequestUtil";
import { fileIo } from "@kit.CoreFileKit";
import { image } from "@kit.ImageKit";

enum SanBoxType {
  FILE,
  TEMP,
  CACHE
}

export class NetworkDownloadManager {
  private static sInstance: NetworkDownloadManager;
  currentSanBox: SanBoxType = SanBoxType.TEMP // 目录存储类型

  private constructor() {} // 私有构造函数

  public static getInstance(): NetworkDownloadManager {
    if (!NetworkDownloadManager.sInstance) {
      NetworkDownloadManager.sInstance = new NetworkDownloadManager();
    }
    return NetworkDownloadManager.sInstance;
  }

  downLoadMultiObject(list: string[]): Promise<Record<string, string>[]> {
    return Promise.all(list.map((url): Promise<string | Record<string, string>> => this.downloadSingleFile(url))) as Promise<Record<string, string>[]>
  }

  // 下载多个文件 每个网络地址对应其本地文件
  downLoadMulti(list: string[]) {
    // list.forEach((url): Promise<void> => this.downloadSingleFile(url))
    return Promise.all(list.map((url): Promise<string | Record<string, string>> => this.downloadSingleFile(url))) as Promise<string[]>
  }

  /**
   * 下载单个文件
   */
  async downloadSingleFile(url: string, isObjectType: boolean = false) {
    // const filePath = getContext().cacheDir + "/" + util.generateRandomUUID() + ".jpg" // 获取沙箱路径
    // await RequestRemoteCommunication.download(url, {
    //   kind: "file",
    //   file: filePath
    // })
    return new Promise<string | Record<string, string>>((resolve, reject) => {
      let filePath = util.generateRandomUUID() + ".jpg" // 生成文件名
      let targetPath = util.generateRandomUUID() + ".jpg" // 压缩的目标图片
      if (this.currentSanBox == SanBoxType.FILE) {
        filePath = getContext().filesDir + "/" + filePath
        targetPath = getContext().filesDir + "/" + targetPath
      }else if (this.currentSanBox === SanBoxType.TEMP) {
        filePath = getContext().tempDir + "/" + filePath
        targetPath = getContext().tempDir + "/" + targetPath
      } else {
        filePath = getContext().cacheDir + "/" + filePath
        targetPath = getContext().cacheDir + "/" + targetPath
      }
      // 开多线程去下载
      const downloadWorker = new worker.ThreadWorker("basic/ets/workers/DownloadWorker.ets")
      try {
        downloadWorker.onmessage = async (event) => {
          if (event.data == "success") {
            await taskpool.execute(imageZipper, filePath, targetPath) // 开启多线程
            fileIo.unlinkSync(filePath) // 删除原文件
            let object: Record<string, string> = {}
            object[url] = targetPath // 在鸿蒙中只有小写的object和Record类型才能通过[key]的方式取值
            resolve(isObjectType ? object : targetPath) // 返回压缩的地址
            downloadWorker.terminate() // 结束多线程
          }
        } // 接收消息
        downloadWorker.postMessage({
          url, // 网络地址
          filePath // 下载目标路径
        })
      } catch (error) {
        reject(new Error('Multi-threaded download failed.'))
      }
    })
  }
}

@Concurrent
async function imageZipper(filePath: string, targetPath: string) {
  try {
    const sourceFile = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY) // 原始文件
    const targetFile = fileIo.openSync(targetPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE) // 压缩目标文件
    const imageSource = image.createImageSource(sourceFile.fd) // 创建原始文件资源
    const packer = image.createImagePacker() // 压缩工具
    await packer.packToFile(imageSource, targetFile.fd, {
      quality: 100, // 压缩质量
      format: 'image/png' // 压缩格式
    })
  } catch (error) {
    // 日志.
  }
}