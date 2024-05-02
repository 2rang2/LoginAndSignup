//
//  ViewController.swift
//  LoginAndSignup
//
//  Created by 랑 on 5/1/24.
//

import UIKit
import KakaoSDKUser

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var userLoginState = false
    let userLoginStateKey = "userLoginState"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.set(userLoginState, forKey: self.userLoginStateKey)
        userLoginState = defaults.bool(forKey: self.userLoginStateKey)
        
        updateUI()
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오톡으로 로그인 성공")
                    
                    //do something
                    _ = oauthToken
                    self.changeLoginState(userLoginState: true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("카카오 계정으로 로그인 성공")
                        self.changeLoginState(userLoginState: true)

                        //do something
                        _ = oauthToken

                    }
                }
        }
        
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("로그아웃 성공")
                self.changeLoginState(userLoginState: false)
            }
        }
    }
    
    func updateUI() {
        // 로그인된 경우 로그아웃 버튼이 보이도록, 로그아웃된 경우 카카오로 로그인 버튼이 보이도록
        if userLoginState {
            loginButton.isHidden = true
            logoutButton.isHidden = false
        } else {
            loginButton.isHidden = false
            logoutButton.isHidden = true
        }
    }
    
    func changeLoginState(userLoginState: Bool) {
        self.userLoginState = userLoginState
        updateUI()
    }
    
}

