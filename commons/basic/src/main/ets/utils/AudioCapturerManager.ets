import { audio } from "@kit.AudioKit";

export class AudioCapturerManager {
  private static sInstance: AudioCapturerManager;
  capturer: audio.AudioCapturer | null = null

  private constructor() {} // 私有构造函数

  public static getInstance(): AudioCapturerManager {
    if (!AudioCapturerManager.sInstance) {
      AudioCapturerManager.sInstance = new AudioCapturerManager();
    }
    return AudioCapturerManager.sInstance;
  }

  /**
   * 创建录音对象
   */
  async initCapturer() {
    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率 语音识别只能识别16000
      channels: audio.AudioChannel.CHANNEL_1, // 通道1
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
    };
    let audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,
      capturerFlags: 0
    };
    let audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo
    };
    this.capturer = await audio.createAudioCapturer(audioCapturerOptions);
  }

  /**
   * 开始录音
   */
  async start(callback: (buffer: ArrayBuffer) => void) {
    if (!this.capturer) {
      await this.initCapturer() // 创建采样器
    }
    this.capturer?.on("readData", (buffer) => callback(buffer))
    this.capturer?.start() // 开始录音
  }

  /**
   * 停止录音
   */
  async stop() {
    await this.capturer?.stop()
    this.capturer?.release()
    this.capturer = null
  }
}