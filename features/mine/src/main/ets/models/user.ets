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

export interface IAddressForm {
  id?: string // 商品id
  address: string
  contact: string
  isDefault: 0 | 1
  receiver: string
}

/**
 * 地址
 */
@ObservedV2
export class AddressForm {
  @Trace id?: string = ""
  @Trace address: string = ""
  @Trace contact: string = ""
  @Trace isDefault: 0 | 1 = 0
  @Trace receiver: string = ""

  constructor(item: IAddressForm) {
    this.id = item.id
    this.address = item.address
    this.contact = item.contact
    this.receiver = item.receiver
    this.isDefault = item.isDefault
  }
}

/**
 * 用户登录返回信息
 */
export interface UserInformationResponse {
  account: string;
  avatar: string;
  birthday: string;
  fullLocation: string; // 完整收货地址
  gender: string;
  id: string;
  nickname: string;
  profession: string;
}

@ObservedV2
export class UserInformationModel implements UserInformationResponse {
  account: string = ''
  @Trace avatar: string = '' // 头像必须拥有响应式更新
  birthday: string = ''
  fullLocation: string = ''
  gender: string = ''
  id: string = ''
  nickname: string = ''
  profession: string = ''

  constructor(model: UserInformationResponse) {
    this.account = model.account
    this.avatar = model.avatar
    this.birthday = model.birthday
    this.fullLocation = model.fullLocation
    this.gender = model.gender
    this.id = model.id
    this.nickname = model.nickname
    this.profession = model.profession
  }
}
