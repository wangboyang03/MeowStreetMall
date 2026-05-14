import { RequestRemoteCommunication, User } from "basic";
import { HuaweiLoginParams, IAddressForm, LoginParams } from "../models";

export const userLoginApi = (data: LoginParams) => RequestRemoteCommunication.post<User>("/login", data)

export const huaweiLoginApi = (data: HuaweiLoginParams) => RequestRemoteCommunication.post<User>("/login/huawei", data)

export const addAddressListApi = (data: IAddressForm) => RequestRemoteCommunication.post<null>("/member/address", data)