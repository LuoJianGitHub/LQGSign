//
//  AppDelegate.swift
//  LQGSign
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

import UIKit
import LQGBaseAppDelegate
import LQGBaseView
import LQGSign

@UIApplicationMain
class AppDelegate: LQGBaseAppDelegate {

    override init() {
        super.init()
        
        self.needShowSignVCBlock = {
            return true
        }
        
        self.getSignVCBlock = {
            return LQGBaseNavigationController.init(rootViewController: {
                let signInVC = LQGSignInController.init()
                signInVC.signInSuccessCompletion = { userInfo in
                    print("\(userInfo!)")
                }
                return signInVC
            }())
        }
    }
    
}

