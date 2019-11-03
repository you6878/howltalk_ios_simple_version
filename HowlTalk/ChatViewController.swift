//
//  ChatViewController.swift
//  HowlTalk
//
//  Created by 유명식 on 2017. 9. 26..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    //채팅메세지 어레이
    var comments : [ChatModel.Comment] = []
    
    var userModel :UserModel?
    //채팅방 UID
    var chatRoomUid : String?
    //나의 UID
    var myUid : String?
    //상대방 UID
    var destinationUid : String?
    
    
    //채팅메세지 테이블 뷰
    @IBOutlet weak var tableview: UITableView!
    //채팅메세지 입력
    @IBOutlet weak var textfield_message: UITextField!
    //채팅 메세지 전송 버트
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
            let dic = datasnapshot.value as! [String:Any]
                   self.userModel = UserModel(JSON: dic)
                   self.getMessageList()
                   
               })
        sendButton.addTarget(self, action: #selector(sendMessageRoom), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    //메세지 읽어오기
    func getMessageList(){
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableview.reloadData()
            if self.comments.count > 0{
                self.tableview.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableView.ScrollPosition.bottom, animated: true)
                
            }
        })
    }
    //메세지 전송
    @objc func sendMessageRoom(){
        let value :Dictionary<String,Any> = [
            "uid" : myUid!,
            "message" : textfield_message.text!,
            "timestamp" : ServerValue.timestamp()
        ]
        Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value, withCompletionBlock: { (err, ref) in
            self.textfield_message.text = ""
        })
    }
    //테이블뷰 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    //테이블뷰 셀 지정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.comments[indexPath.row].uid == myUid){
            let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            
            view.label_message.text = self.comments[indexPath.row].message
            view.label_timestamp.text = self.comments[indexPath.row].timestamp?.toDayTime
            return view
            
        }else{
            let view = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            view.label_name.text = userModel?.userName
            view.label_message.text = self.comments[indexPath.row].message
            view.imageview_profile.sd_setImage(with: URL(string:(self.userModel?.profileImageUrl)!), completed: nil)
            view.label_timestamp.text = self.comments[indexPath.row].timestamp?.toDayTime
            return view
            
        }
    }
}

class MyMessageCell :UITableViewCell{
    
    @IBOutlet weak var label_message: UILabel!
    @IBOutlet weak var label_timestamp: UILabel!
}

class DestinationMessageCell :UITableViewCell{
    @IBOutlet weak var label_message: UILabel!
    @IBOutlet weak var imageview_profile: UIImageView!
    @IBOutlet weak var label_timestamp: UILabel!
    @IBOutlet weak var label_name: UILabel!
}
