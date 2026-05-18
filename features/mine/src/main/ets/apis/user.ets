import { RequestRemoteCommunication, User, AddressItem } from "basic";
import { HuaweiLoginParams, IAddressForm, LoginParams, UserInformationResponse } from "../models";

export const userLoginApi = (data: LoginParams) => RequestRemoteCommunication.post<User>("/login", data)

export const huaweiLoginApi = (data: HuaweiLoginParams) => RequestRemoteCommunication.post<User>("/login/huawei", data)

export const getAddressListApi = () => RequestRemoteCommunication.get<AddressItem[]>("/member/address")

export const addAddressListApi = (data: IAddressForm) => RequestRemoteCommunication.post<null>("/member/address", data)

export const updateAddressListApi = (data: IAddressForm) => RequestRemoteCommunication.put<null>(`/member/address/${data.id}`, data)

export const deleteAddressListApi = (id: string) => RequestRemoteCommunication.delete<null>(`/member/address/${id}`)

export const getUserInformationApi = () => RequestRemoteCommunication.get<UserInformationResponse>("/member/profile")