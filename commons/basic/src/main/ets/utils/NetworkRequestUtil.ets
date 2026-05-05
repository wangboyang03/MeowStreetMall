import { rcp } from '@kit.RemoteCommunicationKit';
import { Constants } from '../Constants';
import { ResponseData } from '../models';
import { promptAction } from '@kit.ArkUI';

// Rcp拦截器需要单独实例化 实现rcp.Interceptor类
class RequestInterceptor implements rcp.Interceptor {
  /**
   * 请求拦截
   * @param context 请求上下文对象
   * @param next 传递到下一个
   * @returns 异步处理队列
   */
  intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    // TODO: to from next axios返回类型无法更改 请求拦截器 注入Token
    return next.handle(context);
  }
}

class ResponseInterceptor implements rcp.Interceptor {
  /**
   * 响应拦截器
   * @param context 请求上下文对象
   * @param next 传递到下一个
   * @returns 异步处理队列
   */
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    // TODO: to from next axios返回类型无法更改 请求拦截器
    const result = await next.handle(context) // 将结构返回给下一个执行链
    if (result.statusCode == 401) {
      // Token过期 无感刷新token
    }
    return result
  }
}

const sInstance = rcp.createSession({
  baseAddress: Constants.BASE_URL, // 基地址
  interceptors: [
    new RequestInterceptor(),
    new ResponseInterceptor()
  ], // 设置拦截器
  requestConfiguration: {
    transfer: {
      timeout: {
        connectMs:Constants.TIME_OUT,// 连接超时毫秒数
        transferMs:Constants.TIME_OUT, // 传输超时毫秒数
        inactivityMs:Constants.TIME_OUT // 对话超时毫秒数
      }
    }
  }
})

export class RequestRemoteCommunication {
  /**
   * GET请求
   * @param url
   * @param params
   */
  static get<T>(url:string, params?: object):Promise<T> {
    // url?id=1&name=2 {id:1,name:2}
    return RequestRemoteCommunication.toRightData<T>(sInstance.get(url + "?" + RequestRemoteCommunication.transJSONToParams(params)))
  }

  /**
   * POST请求
   * @param url
   * @param params
   */
  static post<T>(url:string, params?: object):Promise<T> {
    return RequestRemoteCommunication.toRightData<T>(sInstance.post(url, params))
  }

  /**
   * DELETE请求
   * @param url
   * @param params
   * @param data
   * @example delete支持传body参数 删除购物车需要传递body参数
   */
  static delete<T>(url:string, params?: object, data?: object):Promise<T> {
    const request = new rcp.Request(url + "?" + RequestRemoteCommunication.transJSONToParams(params), "DELETE", {}, data)
    return RequestRemoteCommunication.toRightData<T>(sInstance.fetch(request))
  }

  /**
   * PUT请求
   * @param url
   * @param params
   */
  static put<T>(url:string, params?: object):Promise<T> {
    return RequestRemoteCommunication.toRightData<T>(sInstance.put(url, params))
  }

  /**
   * PATCH请求
   * @param url
   * @param params
   */
  static patch<T>(url:string, data?: object):Promise<T> {
    const request = new rcp.Request(url, "PATCH", {}, data)
    return RequestRemoteCommunication.toRightData<T>(sInstance.fetch(request))
  }

  // 上传下载
  static upload<T>() {}
  static download<T>() {}

  /**
   * 将数据转化成正确的数据类型
   * @param res 请求结果数据
   * @returns
   */
  static async toRightData<T>(res: Promise<rcp.Response>) {
    const obj = await res
    const result = obj.toJSON() as ResponseData<T>
    if (result.code == Constants.SUCCESS_TYPE) {
      return result.result // 请求成功返回后端数据
    }
    promptAction.showToast({ message: result.message })
    return Promise.reject(new Error(result.message))
  }

  /**
   * 转化Json为Url地址参数的方法
   * @param params
   * @returns
   * @example  { id: 1, name: 2 } => id=1&name=2
   */
  static transJSONToParams(params?: object) {
    if (params) {
      return Object.keys(params).filter(key => !!params[key]).map(key => `${key}=${params[key]}`).join("&")
    }
    return ""
    // ["id","name"] => ["id=1", "name=2"]
  }
}