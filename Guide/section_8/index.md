# IOS 채팅앱 만들기 4

## ChatPage
여러 페이지가 필요하니 Tab Bar ViewController로 만들어주자.
### Interface Builder
1. Tab bar 만들기

![](DraggedImage.tiff)

나의 말풍선은 파란색 말풍선인 으로 상대방 말풍선은 주황색 말풍선인 으로 설정해준다.
물론 이미지 100%를 따라할 필요가 없으며 이것은 참고용 이라는 것만 알아두자.

2. Segue연결
![](Screen%20Shot%202019-11-23%20at%205.35.43%20PM.png)
Segue Indentifier 명을 **DetailChatSeuge**로 명명해준다.
 
### 소스코드
```swift
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
        getDestinationUserInfo()
    }

	func getDestinationUserInfo(){
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
```
#### 소스코드 분석
- 상대방 정보 읽어오기
```swift
	func getDestinationUserInfo(){
	Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
            let dic = datasnapshot.value as! [String:Any]
                   self.userModel = UserModel(JSON: dic)
                   self.getMessageList()
                   
               })
        sendButton.addTarget(self, action: #selector(sendMessageRoom), for: .touchUpInside)
        // Do any additional setup after loading the view.
	}
```
여기서 주의해야할점은 상대방 개인정보의 **child**값이 **uid**값으로 저장이 되어 있어야 한다.

- 메세지 전송
```swift
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
```
**child("chatrooms").child(chatRoomUid!)**경로에 **comments**까지 넣어서 입력해야 코멘트들을 보관하는 배열을 만들 수가 있다.
![](DraggedImage-1.tiff)![](DraggedImage-2.tiff)

- 메세지 읽어오기
```swift
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
```
메세지를 읽어오는 방법은 **comments**까지 입력하게 되면 깔끔하게 불러올 수 있다.

 - MyMessageCell 만들기
![](DraggedImage-3.tiff)

```swift
class MyMessageCell :UITableViewCell{
    
    @IBOutlet weak var label_message: UILabel!
    @IBOutlet weak var label_timestamp: UILabel!
}
```
마찬가지로 MyMessageCell의 row identifier도 ** MyMessageCell**으로 명명해주자.
- DestinationMessageCell 만들기
![](DraggedImage-4.tiff)

```swift
class DestinationMessageCell :UITableViewCell{
    @IBOutlet weak var label_message: UILabel!
    @IBOutlet weak var imageview_profile: UIImageView!
    @IBOutlet weak var label_timestamp: UILabel!
    @IBOutlet weak var label_name: UILabel!
}
```
마찬가지로 DestinationMessageCell의 row identifier도 **DestinationMessageCell**으로 명명해주자.
- 채팅 메세지 리스트 만들기
```swift
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
```
여기서 중요한점은 코멘트에 있는 uid값이 나랑 일치하는지 판단을 해서 **MyMessageCell**과 **DestinationMessageCell**셀을 호출 하면된다.



## 기타 추가 디자인코드

확장은 기존 클래스, 구조, 열거 또는 프로토콜 유형에 새로운 기능을 추가하는 기능이며. 여기에는 원래 소스 코드에 액세스할 수 없는 유형을 확장하는 기능이 포함된다. 확장은 목표 C언어의 카테고리와 유사하다


```swift
extension Int{
    var toDayTime :String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
```
![](Screen%20Shot%202019-11-23%20at%205.59.59%20PM.png) toDayTime는 초만기록된 유닉스의 시간값을 yyyy.MM.dd HH:mm값으로 바꿔주는 코드가 있다. ![](Screen%20Shot%202019-11-23%20at%206.02.10%20PM.png) makeRounded 사각형 이미지를 동그랗게 만들어주는 코드를 가지고 있다.

이것들은 개발자들이 그대로 복사해서 많이 사용하기 때문에 따로 저장에서 사용하자.