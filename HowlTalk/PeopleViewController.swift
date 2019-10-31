//
//  MainViewController.swift
//  HowlTalk
//
//  Created by 유명식 on 2017. 8. 29..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class PeopleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    //친구목록 어레이
    var array : [UserModel] = []
    //다음화면 페이지 Flag값
    let detailChatSeuge = "DetailChatSeuge"
    //채팅방 UID
    var chatRoomUid : String?
    //나의 UID
    var myUid : String?
    //상대방 UID
    var destinationUid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        myUid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.array.removeAll()
            let myUid = Auth.auth().currentUser?.uid
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String : Any]
                let userModel = UserModel(JSON: dic)
                
                
                if(userModel?.uid == myUid){
                    continue
                }
                self.array.append(userModel!)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData();
            }
        })
    }
    
    //테이블뷰 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    //테이블뷰 셀 지정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        let item = self.array[indexPath.row]
        if(item.profileImageUrl != nil){
            cell.imageview.makeRounded()
            cell.imageview.sd_setImage(with: URL(string: item.profileImageUrl!), completed: nil)
        }
        
        cell.name.text = item.userName
        return cell
    }
    //테이블뷰 선택 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        destinationUid = self.array[indexPath.row].uid
        
        //먼저 내가 소속된 방들을 검색
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+myUid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value,with: { (datasnapshot) in
            
            //방이 하나도 없을때
            if(datasnapshot.children.allObjects.count == 0){
                self.createRoom(uid: self.myUid!, destinationUid: self.destinationUid!)
            }
            else{
                //방이 있을때
                for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                    let chatRoomdic = item.value as! [String:AnyObject]
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if(chatModel?.users[self.destinationUid!] == true){
                        ////내가 선택한 사람의 방이 존재할때
                        self.chatRoomUid = item.key
                        self.performSegue(withIdentifier: self.detailChatSeuge, sender: nil)
                    }else{
                        //다시 생성
                        self.createRoom(uid: self.myUid!, destinationUid: self.destinationUid!)
                    }
                    
                }
            }
        })
        
    }
    // 방 생성 코드
    func createRoom(uid : String, destinationUid : String){
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [
            uid: true,
            destinationUid :true
            ]
        ]
        
        Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: { (err, ref) in
            self.chatRoomUid = ref.key
            self.performSegue(withIdentifier: self.detailChatSeuge, sender: nil)
        })
        
    }
    // MARK: - Navigation
    
    // 다음화면으로 넘어갈때 데이터를 넘겨주어야 할경우 호출 하는 부분
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == detailChatSeuge){
            let vc = segue.destination as? ChatViewController
            vc?.chatRoomUid = chatRoomUid
            vc?.myUid = myUid
            vc?.destinationUid = destinationUid
        }
    }
}
class PersonCell :UITableViewCell{
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var name: UILabel!
}
