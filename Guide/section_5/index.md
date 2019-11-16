# IOS 채팅앱 만들기 1

## 데이터 모델

### 라이브러리 설치

데이터 모델에 사용하기 위한 필수 라이브러리는 Objectmapper가 있다. 최근 Swift4에서 Codable을 도입을 했지만 오랜기간 숙성된 Objectmapper 안정성과 확장성이 뛰어나다.

- Dependency 목록 추가
```bash
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HowlTalk' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HowlTalk

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'SDWebImage'
pod 'ObjectMapper'
end
~
~
~
~
~
~
~
"Podfile" 16L, 378C
```

ObjectMapper를 추가한 후 Pod를 인스톨해주자

```bash
Pod install
```

서버와 클라이언트와 통신할 때는 문자열을 주고 받는 형식이다. 만약 플렛폼이 하나로 만들어졌으면 손쉽게 Struct된 클래스 파일들을 주고 받을 것이지만 서버랑 통신하는 플렛폼이 안드로이드, 아이폰, 유티니, 자바스크립트, 윈도우, 맥 프로그램 등 엄청나게 다양하기 때문에 문자열로 주고 받는다. 문자열을 주고 받을때 사용하는 프로토콜 규칙이 JSON이다.

만약 2명의 친구목록을 보내는 구조를 살펴보자.
이들은 이런 개인정보가 데이터베이스 저장되어 있다고 할 경우

```bash

-1
 이름 : 철수
 주민등록번호 : 950101-1..
 프로필 이미지 : profile_image_1.png
 
-2
 이름 : 영희
 주민등록번호 : 950101-2..
 프로필 이미지 : profile_image_2.png
```

JSON으로는 이렇게 표현한다.

```json
[
{"1" : {"이름" : "철수", "주민등록번호" :"950101-1..", "프로필 이미지":"profile_image_1.png"}},
{"2" : {"이름" : "영희", "주민등록번호" :"950101-2..", "프로필 이미지":"profile_image_2.png"}}
]
```

서버에서는 이렇게 문자열로 보내는 것 이다.
그럼 Swift에서 손쉽게 사용하기 위해서는 객체화를 시켜줘야한다.
그러기 위해서는 JSON에 맞게 데이터를 맵핑시켜주면된다.

 - 데이터 모델화
```swift
class DataModel{
	var 이름 :String
    var 주민등록번호 : String
	var 프로필이미지 :String
}
```

 - 실제코드
```swift
import ObjectMapper

struct UserModel: Mappable{
    var userName : String?
    var uid : String?   
    var profileImageUrl :String?

    init() {
        
    }
    init?(map: Map) {
           
    }
    mutating func mapping(map: Map) {
        userName <- map["userName"]
        uid <- map["uid"]
        profileImageUrl <- map["profileImageUrl"]
    }
}
```

## Swift와 Firebase 인증 라이브러를 통한 로그인페이지 만들기
인증 라이브러이에서 로그인을 요청하는 방법은 굉장히 간단하다. 
```swift
signIn(withEmail: "로그인아이디", password: "패스워드)
```
 이용하게 되면 Firebase Server에 로그인 페이지를 요청할 수 있다.
### LoginPage
이메일을 로그인하는 페이지를 만들어보자.
#### Interface Builder
![](Screen%20Shot%202019-11-15%20at%205.01.35%20PM.png)

#### 소스코드

```swift
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
        
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        signup.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        
    }
    //회원가입 페이지 이동
    @objc func presentSignup(){
        //회원가입 Seuge Identifier 호출
    }
    //로그인 페이지 이동
    @objc func loginEvent(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, err) in

            if(err != nil){
	            //에러가 발생하면 에러를 출력
	 			print(err)
            }else{
                //메인페이지로 이동하는 Seuge Identifier 호출
            }
        }
    }
}
```

로그인 페이지 만드는 부분은 생각보다.

