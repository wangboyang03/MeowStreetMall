import { AppUserCenter, User } from "../models";
import { PersistenceV2 } from "@kit.ArkUI";

export class Auth {
  private static sInstance: Auth;
  private constructor() {} // 私有构造函数

  public static getInstance(): Auth {
    if (!Auth.sInstance) {
      Auth.sInstance = new Auth();
    }
    return Auth.sInstance;
  }

  setUser(user: User) {
    let appUserCenter = PersistenceV2.connect(AppUserCenter, () => new AppUserCenter())
    if (!!appUserCenter) {
      appUserCenter.user.token = user.token ?? ""
      appUserCenter.user.avatar = user.avatar ?? ""
      appUserCenter.user.nickname = user.nickname ?? ""
      appUserCenter.user.account = user.account ?? ""
    }
    PersistenceV2.notifyOnError((error, reason, message) => {
      AlertDialog.show({ message: `error:${error},reason:${reason},message:${message}` })
    })
  }

  getUser() {
    let appUserCenter = PersistenceV2.connect(AppUserCenter, () => new AppUserCenter())
    if (!!appUserCenter) {
      return appUserCenter.user
    }
    return null
  }
}