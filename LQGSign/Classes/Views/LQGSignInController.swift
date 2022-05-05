//
//  LQGSignInController.swift
//  LQGSign
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import LQGCategory
import LQGBaseView
import LQGTip

public class LQGSignInController: LQGBaseViewController {

    //MARK: - NavigationBar
    
    public override func lqg_setupNavigationBarItem() {
        self.title = "登录"
    }
    
    //MARK: - 属性
    
    lazy var mobileLab: UILabel = {
        let lab: UILabel = .init()
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = .black
        lab.text = "账号："
        lab.setContentHuggingPriority(.required, for: .horizontal)
        return lab
    }()
        
    lazy var mobileTF: UITextField = {
        let tf: UITextField = .init()
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = .black
        tf.placeholder = "请输入您的账号"
        return tf
    }()
    
    lazy var passwordLab: UILabel = {
        let lab: UILabel = .init()
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = .black
        lab.text = "密码："
        lab.setContentHuggingPriority(.required, for: .horizontal)
        return lab
    }()
    
    lazy var passwordTF: UITextField = {
        let tf: UITextField = .init()
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = .black
        tf.placeholder = "请输入您的密码"
        return tf
    }()
    
    lazy var signInBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.setBackgroundImage(.init(size: CGSize(width: 100, height: 44), color: .init(hex: 0x4745F4)), for: .normal)
        btn.setBackgroundImage(.init(size: CGSize(width: 100, height: 44), color: .init(hex: 0x4745F4, a: 0.3)), for: .disabled)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("立即登录", for: .normal)
        return btn
    }()
    
    lazy var signInViewModel: LQGSignInViewModel = {
        let viewModel: LQGSignInViewModel = LQGSignInViewModel.init()
        return viewModel
    }()
    
    public var signInSuccessCompletion: (([AnyHashable: Any]?) -> Void)?
    
    let disposeBag = DisposeBag()
    
    //MARK: - 初始化
    
    public override func lqg_addSubviews() {
        self.view.addSubview(self.mobileLab)
        self.view.addSubview(self.mobileTF);
        self.view.addSubview(self.passwordLab)
        self.view.addSubview(self.passwordTF)
        self.view.addSubview(self.signInBtn)
        
        self.mobileLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
        }
        self.mobileTF.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(self.mobileLab.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.mobileLab)
        }
        self.passwordLab.snp.makeConstraints { make in
            make.left.equalTo(self.mobileLab)
        }
        self.passwordTF.snp.makeConstraints { make in
            make.top.equalTo(self.mobileTF.snp.bottom).offset(10)
            make.left.equalTo(self.passwordLab.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.passwordLab)
        }
        self.signInBtn.snp.makeConstraints { make in
            make.top.equalTo(self.passwordLab.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(44)
        }
    }
    
    //MARK: - Life Cycle
        
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        self.mobileTF.rx.text.orEmpty.bind(to: self.signInViewModel.rx.mobile).disposed(by: disposeBag)
        self.passwordTF.rx.text.orEmpty.bind(to: self.signInViewModel.rx.password).disposed(by: disposeBag)
        
        self.mobileTF.rx.text.orEmpty.map { text in
            return text.count > 11
        }.subscribe { [weak self] (flag) in
            if flag == false { return }
            let text = self?.mobileTF.text
            let index = text!.index(text!.startIndex, offsetBy: 11)
            self?.mobileTF.text = String(text![..<index])
        } onDisposed: {}

        self.passwordTF.rx.text.orEmpty.map { text in
            return text.count > 6
        }.subscribe { [weak self] (flag) in
            if flag == false { return }
            let text = self?.passwordTF.text
            let index = text!.index(text!.startIndex, offsetBy: 6)
            self?.passwordTF.text = String(text![..<index])
        } onDisposed: {}
        
        Observable.combineLatest(self.mobileTF.rx.text.orEmpty, self.passwordTF.rx.text.orEmpty){ mobile, password -> Bool in
            return mobile.count == 11 && password.count == 6
        }
        .map{ $0 }
        .bind(to: self.signInBtn.rx.isEnabled)
        .disposed(by: disposeBag)
        
        self.signInBtn.rx.tap.subscribe { [weak self] in
            LQGToastView.showHUD(withMessage: "登录中...")
            self?.signInViewModel.signIn { success, message in
                if success {
                    LQGToastView.hide()
                    if (self?.signInSuccessCompletion != nil) {
                        self?.signInSuccessCompletion!(self?.signInViewModel.userInfo)
                    }
                } else {
                    LQGToastView.showToast(withMessage: message)
                }
            }
        } onDisposed: {}
    }
    
}
