//
//  LoginViewController.swift
//  HowlTalk
//
//  Created by 유명식 on 2017. 8. 8..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //자동로그인 해제
//        try! Auth.auth().signOut()
        
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        signup.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                self.performSegue(withIdentifier: "MainSeuge", sender: nil)
            }
        }
    }
    //회원가입 페이지 이동
    @objc func presentSignup(){
        self.performSegue(withIdentifier: "SignupSeuge", sender: nil)
    }
    //로그인 페이지 이동
    @objc func loginEvent(){
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, err) in
            
            if(err != nil){
                let alret = UIAlertController(title: "에러", message: err.debugDescription, preferredStyle: UIAlertController.Style.alert)
                alret.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alret, animated: true, completion: nil)
            }
        }
    }
}
