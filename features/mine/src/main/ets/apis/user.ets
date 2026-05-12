import { RequestRemoteCommunication } from "basic";
import { HuaweiLoginParams, LoginParams, LoginResult } from "../models";

export const userLoginApi = (data: LoginParams) => RequestRemoteCommunication.post<LoginResult>("/login", data)

export const huaweiLoginApi = (data: HuaweiLoginParams) => RequestRemoteCommunication.post<LoginResult>("/login/huawei", data)