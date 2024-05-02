//
//  ViewController.swift
//  LoginAndSignup
//
//  Created by 랑 on 5/1/24.
//

import UIKit
import KakaoSDKUser
import GoogleSignIn

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var userLoginState = false
    let userLoginStateKey = "userLoginState"
    
    var loggedInWith = ""
    let loggedInWithKey = "loggedInWith"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.set(userLoginState, forKey: userLoginStateKey)
        userLoginState = defaults.bool(forKey: userLoginStateKey)
        
        defaults.set(loggedInWith, forKey: loggedInWithKey)
        loggedInWith = defaults.string(forKey: userLoginStateKey)!
        
        updateUI()
        
        
    }
    
    @IBAction func kakaoLoginButtonPressed(_ sender: UIButton) {
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
                    self.loggedInWith = "kakao"
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
                        self.loggedInWith = "kakao"

                        //do something
                        _ = oauthToken

                    }
                }
        }
        
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }

            // If sign in succeeded, display the app's main content View.
            print("구글 로그인 성공")
            self.loggedInWith = "google"
          }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        if loggedInWith == "kakao" {
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로그아웃 성공")
                    self.changeLoginState(userLoginState: false)
                }
            }
        } else if loggedInWith == "google" {
            GIDSignIn.sharedInstance.signOut()
            print("구글 로그아웃 성공")
        }
        
    }
    
    func updateUI() {
        // 로그인된 경우 로그아웃 버튼이 보이도록, 로그아웃된 경우 카카오로 로그인 버튼이 보이도록
        if userLoginState {
            //kakaoLoginButton.isHidden = true
            //logoutButton.isHidden = false
        } else {
            //kakaoLoginButton.isHidden = false
            //logoutButton.isHidden = true
        }
    }
    
    func changeLoginState(userLoginState: Bool) {
        self.userLoginState = userLoginState
        updateUI()
    }
    
}

