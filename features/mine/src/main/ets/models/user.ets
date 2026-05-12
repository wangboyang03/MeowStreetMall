// 请求参数
export interface LoginParams {
  account: string
  password: string
}

// 返回结果
export interface LoginResult {
  account: string;
  avatar: string;
  nickname: string;
  token: string;
}

// 华为登录请求返回参数
export interface HuaweiLoginParams {
  clientId: string; // 客户端id
  clientSecret: string; // 客户端秘钥
  code: string; // 华为授权码

}
