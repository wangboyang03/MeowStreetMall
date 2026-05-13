import { RequestRemoteCommunication, User } from "basic";
import { HuaweiLoginParams, LoginParams } from "../models";

export const userLoginApi = (data: LoginParams) => RequestRemoteCommunication.post<User>("/login", data)

export const huaweiLoginApi = (data: HuaweiLoginParams) => RequestRemoteCommunication.post<User>("/login/huawei", data)