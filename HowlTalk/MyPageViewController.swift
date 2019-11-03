//
//  MyPageViewController.swift
//  HowlTalk
//
//  Created by Howl on 2019/11/03.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import Firebase

class MyPageViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.addTarget(self, action: #selector(logout), for: UIControl.Event.touchUpInside)
    }
    @objc func logout(){
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
