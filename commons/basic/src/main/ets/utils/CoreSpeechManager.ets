import { speechRecognizer } from "@kit.CoreSpeechKit";
import { Loggar } from "./LoggarUtil";

export class CoreSpeechManager {
  private static sInstance: CoreSpeechManager;
  asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null // 语音识别引擎 引擎得提前初始化
  sessionId: string = Date.now().toString() // 会话id是当前时间戳
  resultCallBack?: (content: string) => void // 结果回调

  private constructor() {} // 私有构造函数

  public static getInstance(): CoreSpeechManager {
    if (!CoreSpeechManager.sInstance) {
      CoreSpeechManager.sInstance = new CoreSpeechManager();
    }
    return CoreSpeechManager.sInstance;
  }

  // 初始化引擎
  async initEngine(callBack: (content: string) => void) {
    this.resultCallBack = callBack // 传入回调
    let extraParam: Record<string, Object> = { "locate": "CN", "recognizerMode": "short" }; // 设置引擎参数 中文 短音频
    let initParamsInfo: speechRecognizer.CreateEngineParams = {
      language: 'zh-CN', // 支持中文
      online: 1, // 离线模式 缺点是识别能力较弱
      extraParams: extraParam
    };
    this.asrEngine = await speechRecognizer.createEngine(initParamsInfo); // 异步创建引擎
    this.setListener() // 设置监听
    this.startListening() // 开始监听
  }

  /*
   * 设置监听
   */
  private setListener() {
    // 创建回调对象
    let setListener: speechRecognizer.RecognitionListener = {
      onStart: (sessionId: string, eventMessage: string): void => {
        Loggar.info(`onStart, sessionId: ${sessionId} eventMessage: ${eventMessage}`)
      },
      onEvent: (sessionId: string, eventCode: number, eventMessage: string): void => {
        Loggar.info(`onEvent, sessionId: ${sessionId} eventCode: ${eventCode} eventMessage: ${eventMessage}`)
      },
      onResult: (sessionId: string, result: speechRecognizer.SpeechRecognitionResult): void => {
        Loggar.info(result.result)
        Loggar.info(`onResult, sessionId: ${sessionId} sessionId: ${JSON.stringify(result)}`)
      },
      onComplete: (sessionId: string, eventMessage: string): void => {
        Loggar.info(`onComplete, sessionId: ${sessionId} eventMessage: ${eventMessage}`)
      },
      onError: (sessionId: string, errorCode: number, errorMessage: string): void => {
        Loggar.error(`onError, sessionId: ${sessionId} errorCode: ${errorCode} errorMessage: ${errorMessage}`)
      }
    }
    this.asrEngine?.setListener(setListener) // 设置回调
  }

  /**
   * 开始监听
   */
  private startListening() {
    let recognizerParams: speechRecognizer.StartParams = {
      sessionId: this.sessionId,
      audioInfo: {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      } //audioInfo参数配置请参考AudioInfo
    }
    // 调用开始识别方法
    this.asrEngine?.startListening(recognizerParams);
  }

  /**
   * 开始分析
   */
  startTransVoice(buffer: ArrayBuffer) {
    this.asrEngine?.writeAudio(this.sessionId, new Uint8Array(buffer)) // 写入音频流
  }

  /**
   * 停止分析
   */
  stopTransVoice() {
    this.asrEngine?.finish(this.sessionId) // 调用完成方法停止识别
    this.asrEngine?.shutdown() // 释放资源
    this.asrEngine = null // 清空内存
    this.sessionId = Date.now().toString() // 重置会话id
  }
}