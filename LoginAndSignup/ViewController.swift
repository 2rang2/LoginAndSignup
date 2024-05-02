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
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    
    var loggedInWith = ""
    let loggedInWithKey = "loggedInWith"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.set(loggedInWith, forKey: loggedInWithKey)
        loggedInWith = defaults.string(forKey: loggedInWithKey)!
        
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
                            
                    self.setLoginWith(loggedInWith: "kakao")
                    self.getUserDataFromKakao()
                    self.updateUI()
                }
            }
        }
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            print("구글 로그인 성공")
            self.setLoginWith(loggedInWith: "google")
        
            guard let user = signInResult?.user else { return }
            guard let profile = user.profile else { return }
            
            let name = profile.name
            
            self.displayUserData(name: name)
            self.updateUI()
    
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
                    self.setLoginWith(loggedInWith: "")
                    self.updateUI()
                }
            }
        } else if loggedInWith == "google" {
            GIDSignIn.sharedInstance.signOut()
            print("구글 로그아웃 성공")
            setLoginWith(loggedInWith: "")
            updateUI()
        }
        
    }
    
    func updateUI() {
        print("현재 loggedInWith = \(loggedInWith)")
        if loggedInWith == "" {
            kakaoLoginButton.isHidden = false
            googleLoginButton.isHidden = false
            logoutButton.isHidden = true
            greetingLabel.text = "로그인 해주세요."
        } else if loggedInWith == "kakao" || loggedInWith == "google" {
            kakaoLoginButton.isHidden = true
            googleLoginButton.isHidden = true
            logoutButton.isHidden = false
        }
    }
    
    func setLoginWith(loggedInWith: String) {
        self.loggedInWith = loggedInWith
    }
    
    func getUserDataFromKakao() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
            
                guard let kakaoAccount = user?.kakaoAccount else { return }
                guard let profile = kakaoAccount.profile else { return }
                guard let nickname = profile.nickname else { return }
                
                self.displayUserData(name: nickname)
            }
        }
    }
    
    func displayUserData(name: String) {
        greetingLabel.text = "\(name)님 환영합니다."
    }
    
}

