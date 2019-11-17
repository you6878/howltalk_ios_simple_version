//
//  SignupViewController.swift
//  HowlTalk
//
//  Created by Howl on 2019/11/10.
//  Copyright © 2019 유명식. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mainImageview: UIImageView!
    
    @IBOutlet weak var albumButton: UIButton!
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var passowrdTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.addTarget(self, action: #selector(actionSignup), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
        
        //        Database.database().reference()
        //        .child("users")
        //        .child("-LtJGcP9FoazKg-1RRfD")
        //            .observe(DataEventType.value) { (snopshot) in
        //                print(snopshot.value)
        //        }
        
        albumButton.addTarget(self, action: #selector(actionSelectImage), for: UIControl.Event.touchUpInside)
        
    }
    @objc func actionSelectImage(){
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        
        //화면 오픈 코드
        present(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        self.dismiss(animated: true, completion: nil)
        var image = info[.originalImage] as? UIImage
        mainImageview.image = image
        
        
    }
    
    
    @objc func actionSignup(){
        //1단계 : 아이디 생성
        Auth.auth().createUser(withEmail: emailIdTextField.text!, password: passowrdTextField.text!) { (auth, err) in
            if(err == nil){
                //현재 유저의 고유값 가져오기(주민등록번호)
                var uid = auth?.user.uid
                // 이미지를 데이터화
                let data = self.mainImageview.image?.jpegData(compressionQuality: 0.1)
                // 이미지를 저장할 경로
                let riversRef =  Storage.storage().reference()
                    .child("images")
                    .child("\(uid).png")
                //2단계 : 이미지 업로드 코드
                riversRef.putData(data!, metadata: nil) { (metadata, error) in
                    
                    //이미지 다운로드 URL
                    riversRef.downloadURL { (url, err) in
                        var userModel = UserModel()
                        userModel.userName = self.nameTextField.text
                        userModel.uid = uid
                        userModel.profileImageUrl = url?.absoluteString
                        
                        
                        //3단계 : 데이터베이스에 개인정보 입력
                        Database.database().reference()
                            .child("users")
                            .childByAutoId()
                            .setValue(userModel.toJSON())
                        
                    }
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
