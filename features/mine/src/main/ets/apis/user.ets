import { RequestRemoteCommunication } from "basic";
import { LoginParams, LoginResult } from "../models";

export const userLoginApi = (data: LoginParams) => RequestRemoteCommunication.post<LoginResult>("/login", data)