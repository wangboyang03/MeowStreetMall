import { media } from "@kit.MediaKit";
import { audio } from "@kit.AudioKit";
import { application } from "@kit.AbilityKit";

export class SoundPoolPlayer {
  private static sInstance: SoundPoolPlayer;
  pool: media.SoundPool | null = null
  private constructor() {} // 私有构造函数
  public static getInstance(): SoundPoolPlayer {
    if (!SoundPoolPlayer.sInstance) {
      SoundPoolPlayer.sInstance = new SoundPoolPlayer();
    }
    return SoundPoolPlayer.sInstance;
  }

  /**
   * 初始化
   */
  async initPool() {
    let audioRendererInfo: audio.AudioRendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型
      rendererFlags: 0 // 音频渲染器标志
    };
    this.pool = await media.createSoundPool(5, audioRendererInfo)
  }

  /**
   * 播放
   */
  async play(fileName: string) {
    if (!this.pool) {
      await this.initPool()
    }
    // 播放前先拿到文件句柄
    const basicContext = await application.createModuleContext(getContext(), "basic") // 公用模块上下文对象
    const resourceInformation = basicContext.resourceManager.getRawFdSync(fileName) // 获取音频文件句柄
    const soundId = await this.pool?.load(resourceInformation.fd, resourceInformation.offset, resourceInformation.length)
    this.pool?.on("loadComplete", () => {
      this.pool?.play(soundId)
    })
    this.pool?.on("playFinished", () => {
      this.pool?.off("loadComplete")
      this.pool?.off("playFinished")
    })
  }
}