//
//  LQGSignInViewModel.swift
//  LQGSign
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

import Foundation
import LQGBaseViewModel

class LQGSignInViewModel: LQGBaseViewModel {
    
    //MARK: - 属性
    
    var mobile: String?
    
    var password: String?
    
    var userInfo: [AnyHashable: Any]?
    
    //MARK: - Other Method
    
    func signIn(completion: VMCompletion?) {
        if (self.mobile == nil ||
            self.mobile?.count == 0) {
            if completion != nil {
                completion!(false, "请输入手机号")
            }
            return
        }
        if (self.password == nil ||
            self.password?.count == 0) {
            if completion != nil {
                completion!(false, "请输入密码")
            }
            return
        }
        if (self.mobile != "17383876961" ||
            self.password != "123456") {
            if completion != nil {
                completion!(false, "账号或密码错误")
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
            self.userInfo = [
                "userId": "admin",
                "token": "0123456789"
            ]
            VMCompletionOnMainQueue(completion, true, "登录成功")
        })
    }
    
}
