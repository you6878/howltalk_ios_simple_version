# IOS 채팅앱 만들기 3

## MainPage
여러 페이지가 필요하니 Tab Bar ViewController로 만들어주자. 현재 만들어줄 화면은 
- 친구목록 페이지
- 계정정보 페이지
두가지를 만들 예정이다.
### 친구 목록페이지
친구들를 리스트나 나온 페이지이다.

#### Interface Builder
1. Tab bar 만들기
![](DraggedImage.tiff)

![](DraggedImage-1.tiff)
2. 친구목록 페이지 만들기
![](Screen%20Shot%202019-11-15%20at%206.11.20%20PM.png)
 
#### 소스코드
```swift
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
		loadPeopleList()
        
    }
	func loadPeopleList(){	Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
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

	// 다음화면으로 넘어갈때 데이터를 넘겨주어야 할경우 호출 하는 부분
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
```
##### 소스코드 분석

 - 채팅 리스트 목록
```swift
	func loadPeopleList(){
	Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            //데이터 초기화(데이터가 매 순간마다 갱신되므로 초기화를 시켜줘야함)
			self.array.removeAll()

            let myUid = Auth.auth().currentUser?.uid

			//서버에서 넘오는 데이터들를 UserModel로 변환시켜준다.
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String : Any]
                let userModel = UserModel(JSON: dic)
               
				//자신의 계정 정보를 받지 않도록 설정(선택사항)                
                if(userModel?.uid == myUid){
                    continue
                }
				//Array에 UserModel 하나씩 추가
                self.array.append(userModel!)
```

```swift
            }
            DispatchQueue.main.async {
                self.tableview.reloadData();
            }
        })
	}
```
먼저 채팅 리스트를 불러오는 코드이며 **child("users").observe**로 **users**에 있는 목록을 모두 불러오는 코드이다.
![](DraggedImage-2.tiff)

**snapshot.children**는 키 값을 제외한 value값의 데이터들을 불러오며 이 값들을 **For**을 통해서 하나하나씩 **UserModel**화를 시켜준 이후에 **array**에 담아주면 된다.
![](DraggedImage-3.tiff)

- 테이블 뷰 선택 이펜트
```swift
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
                    }                    
                }
            }
        })
        
    }
```
테이블뷰 선택 이벤트는 **tableView**의 **didSelectRowAt**의 파라메터가 담긴 Functions를 호출하면된다. 방을 선택하는 로직이 조금 까다로운데 방이 있을 경우 입장 방이 없을 경우 방을 생성하도록 코드를 만들어놓았다.
- 채팅방 데이터 모델
![](DraggedImage-4.tiff)

데이터 형식
```json
[{
"방번호" : {
	"참여자" : {
				"참여자 1" : true,
				"참여자 2" : true
			}
	"메세지" : [메세지]}
}]
```

JSON 형식
```json
[{
"-LuJKEhcsqo-TLnk63F5" : {
	"users" : {
				"SUnBA5qGrWTic7gHgmYDEZ5K1Zp1" : true,
				"SUnBA5qGrWTic7gHgmYDEZ5K1Zp1" : true
			}
	"comments" : [메세지]}
}]
```


- 방만들기
```swift
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
```
**chatrooms**의 데이터베이스에  **childByAutoId**으로 방키를 생성해서 만들어보자.

 - Present되는 ViewController에 방키 값을 전달
```swift
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
```



### 계정정보 페이지
이부분은 계정을 로그아웃을 진행하는 부분이다.

#### Interface Builder
1. 개인정보페이지 만들기
![](DraggedImage-5.tiff)

```swift
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
```
2. LoginViewController와 UITabBarController와 연결하기
![](Screen%20Shot%202019-11-15%20at%205.17.13%20PM.png) ![](Screen%20Shot%202019-11-15%20at%205.16.31%20PM.png)
Seugment에 Identifier에 “MainSeuge”값 넣고 Seuge Identifier호출

#### 소스코드
```swift
//로그인 페이지 이동
    @objc func loginEvent(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, err) in
            //에러가 발생하면 에러를 출력
            if(err != nil){
	 			print(err)
			//다음페이지로 이동
            }else{
                //메인페이지로 이동하는 Seuge Identifier입력
				self.performSegue(withIdentifier: "MainSeuge", sender: nil)
            }
        }
    }

```
loginEvent Functions에서 Seuge Identifier의 “MainSeuge”호출 코드 추가



