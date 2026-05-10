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
