import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { rcp } from '@kit.RemoteCommunicationKit';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

interface DownloadParamsResponse {
  url: string
  filePath: string
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
workerPort.onmessage = async (event: MessageEvents) => {
  try {
    const params = event.data as DownloadParamsResponse // 获取参数
    const session = rcp.createSession() // 创建会话
    await session.downloadToFile(params.url, { kind: 'file', file: params.filePath }) // 下载完成
    workerPort.postMessage("success") // 下载成功 发送消息通知主线程
    session.close() // 关闭会话
  } catch (error) {
    workerPort.postMessage("fail") // 发生错误意味着下载失败
  }
};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
workerPort.onmessageerror = (event: MessageEvents) => {
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param event error message
 */
workerPort.onerror = (event: ErrorEvent) => {
};