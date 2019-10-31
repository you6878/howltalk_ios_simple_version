//
//  SignupViewController.swift
//  HowlTalk
//
//  Created by 유명식 on 2017. 8. 15..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    //이미지
    @IBOutlet weak var imageView: UIImageView!
    
    //입력
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //버튼
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var imageupload: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //각 버튼에 이벤트 넣기
        imageupload.addTarget(self, action: #selector(imagePicker), for: .touchUpInside)
        signup.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    //앨번 오픈 코드
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    //이미지 선택 결과 페이지
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
    //회원가입 버튼
    @objc func signupEvent(){
        //회원가입 요청
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            
            //현재 UID
            let uid = user?.user.uid
            //이미지 데이터
            let image = self.imageView.image!.jpegData(compressionQuality: 0.1)
            //스토리지 이미지 업로드
            let fileRef = Storage.storage().reference().child("userImages").child(uid!)
            fileRef.putData(image!, metadata: nil, completion: { (data, error) in
                fileRef.downloadURL { (url, err) in
                    
                    //유저 이름, 이미지 주소, UID값 맵으로 생성
                    let values = ["userName":self.name.text,
                                  "profileImageUrl":url,
                                  "uid":Auth.auth().currentUser?.uid
                                 ] as [String : Any]
                    
                    //데이터베이스에 유저정보 입력
                    Database.database().reference().child("users").child(uid!).setValue(values, withCompletionBlock: { (err, ref) in
                        if(err == nil){
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }
    }
    //취소버튼
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
    }
}
