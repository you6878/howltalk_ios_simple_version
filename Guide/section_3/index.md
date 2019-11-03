# Firebase과 Swift 연동 1

## 누구나 쉽게 서버를 만들 수 있는 Firebase란?

파이어베이스(Firebase)는 2011년 파이어베이스(Firebase, Inc)사가 개발하고 2014년에 구글에 인수된 모바일 및 웹 어플리케이션 개발 플렛폼입니다. 파이어베이스가 구글I/O에서 정식으로 소개된 것은 2015년이지만 최근에서야 플렛폼이 유명해지기 시작했다.  모바일 서버 개발에 필요한 인증, 데이터베이스, 스토리지, 푸시알람, 원격구성, 애드워즈(광고)  Node.js기반에 Cloud Fuction을 제공합니다.


### Firebase 장점
1.  인증은 파이어베이스에서 로그인을 담당하는 부분입니다. 로그인을 담당하는 부분은 직접 서버로 개발할 경우 엄청나게 복잡한데 이 이유는 인증된 사용자인데 확인 하는 세션처리 그 세션으로 데이터베이스, 저장소 접근해도 문제가 없는지 확인하는 보안 처리 비밀번호 찾기 아이디 찾기 비밀번호 바꾸기, 이메일 인증 이런 복잡한 것을 구축해야 될 것이다. 이 기능들을 사실 많이 처음에만 회원가입할 때만 쓰일뿐 많이 쓰이지 않는 기능이지만 이것을 구축하는것은 굉장히 까다롭다. 물론 파이어베이스는 이 모든 것을을 지원한다. **당신은  코 풀지 않고 서버를 구축할 수 있는 것이다. **

2.  현대 빅데이터 인공지능 시대로 넘어가면서 부터 Document형식의 빠르고 간편한 NOSQL 기반의 데이터베이스를 도입했다. 또한 다른 데이터베이스와 다르게 RTSP(Real Time Stream Protocol) 방식의 데이터베이스를 지원하고 있다. RTSP는 말 그대로 **실시간으로 데이터**들을 전송해주는 방식을 말한다. 실시간으로 데이터를 통신하는 데이터베이스라고 생각하시면 된다. 이 방식을 사용하면 소켓 기반 서버를 만들어서 통신하는 것보다 비약적으로 코드의 양이 줄어들게 되어 코드 몇 줄로도 원하는 구성을 만들 수가 있다.

3. 원격구성을 지원한다. ** 원격으로 앱의 환경상태를 구성하는 것을 말한다.** 앱의 배경화면 테마나 폰트를 바꾼다던가 업데이트 알림창을 띄운다던가 앱의 환경을 원격으로 구성할때 사용하는 기능이다. 물론 어느정도 개발했던 사람들이라면 데이터베이스에 플레그 값을 만들면 되잖아. 라고 답할지도 모른다. 물론 하지만 데이터베이스의 플레그 값을 이용하는 것은 어떻게 도면 표준화 되지 않는 방법이며 이것을 정식적으로 만들어서 파이어베이스 콘솔을 이용해서 쉽게 원격구성을 설정할 수 있도록 만든 것이 원격구성이다. 물론 나는 이것을 쉽게 앱에 문제가 있거나 앱 업데이트를 해야 될때 유용하게 쓰고 있다.

4. 파이어베이스 콘솔을 제공한다. 이렇게 말하면 콘솔이라는 용어가 감이 오지 않을 수도 있다. 정확히 말하면 **서버 관리자 페이지**라고 생각하시면 된다. 앱의 서버를 만들게 되면 **리눅스**, **FTP**, **Mysql(데이터베이스)**, **Node.JS** 서버 혹은 **Spring Server** 구축할 것이 아니라 이 모든것을 관리할 수 있는 **관리자 페이지**가 필요하다. 회사나 조직에 있는 사람들이 컴퓨터 전문가가 많아서 데이터를 다이렉트로  다룰 줄 안다면 관리자 페이지 필요가 없을 수 도 있다. 그럼 앱을 만들기 위해서는 앱 개발자 뿐만 필요한 것이 아니라 서버 개발자 그 다음으로 서버를 관리할 수 있는 홈페이지를 만들 수 있는 개발자가 필요한 것이다. 안드로이드 앱을 하나 만들기 위해서 배보다 배꼽이 커지는 것이다. 다행히도 파이어베이스는 이 모든 것들을 준비해준다.

6. Analytics를 제공한다. Analytics는 단어 그대로 통계를 말하며 정확히는 다수의 사용자가 앱을 어떻게 사용하는지 **통계 정보**를 가지고 있다. 앱의 현재 접속자 부터, 오류 통계, 사용자 유지율, 고객들의 앱의 업데이트 상태, 사용자들이 어디 화면에 오랫동안 머물렀는지, 이벤트 추척 이런 것들이 추척할 수가 있다. 이런 부분을 데이터들을 수집에서 사용자가 어떤 페이지에서 흥미를 잃었는지 어디페이지가 인기가 많은지 찾아낼 수 있으며 나중에 **필요한 맞춤 마케팅을 만들수가 있을 것이다.**

### Fireabse 단점

1. 파이어베이스를 많이 사용한 유저들이 하는 말은 서버의 응답속도가 종종 느려진다는 것이다. 가령 파이어베이스로 채팅앱을 만들었는데 메세지가 늦게 간다던가 혹은 파이어베이스 인증을 성공하고 나서 로그인을 하고 메인 화면에 데이터베이스에 접근을 할때 서버의 응답이 조금 걸리는 경우가 있다. 이것은 파이어베이스의 고질적인 문제이며 계정을 유료로 전환하여도 **서버의 응답이 지연되는 것은 되는 것이 문제이다**. 해외에 있기 때문에 종종 처리속도에 지연이 발생된다. 아마 파이어베이스가 국내에서 리전을 준비하고 있는 소문이 있다.

3. 파이어베이스의 데이터베이스 Firestore(신버전 데이터베이스)나 RealTime Database(구 버전 데이터베이스) 모두다 **쿼리가 굉장히 빈약하다.** SQL에 익숙한 사람들은 파이어베이스 데이터베이스를 사용하게 되면 굉장히 황당해 할 것이다. 그 흔한 OR 문으로 검색되지 않으며 또한 LIKE 문도 존재 하지 않아서 비슷한 글자나 데이터를 검색할 수 없다. 그래서 파어베이스를 사용하는 사용자들은 이 모든 데이터를 받아와서 안드로이드 기기에서 필터링 해주는 방법을 권장해주고 있다.


## Firebase 인증(Authorization) 라이브러리

대부분의 앱에서 사용자의 신원 정보를 필요로 합니다. 사용자의 신원을 알면 앱이 사용자 데이터를 클라우드에 안전하게 저장할 수 있고 사용자의 모든 기기에서 개인에게 맞춘 동일한 경험을 제공할 수 있기 때문입니다.

Firebase 인증은 앱에서 사용자 인증 시 필요한 백엔드 서비스와 사용하기 쉬운 SDK, 기성 UI 라이브러리를 제공합니다. 비밀번호, 전화번호, 인기 ID 제공업체(예: Google, Facebook, Twitter 등)를 통한 인증이 지원됩니다.

_Android, IOS, Node.js, Java, Unity 다양한 플렛폼 지원_


### 인증(Authorization)라이브러리 설치

## Cocoapod란?
Xcode Dependency(라이브러리) Manager이다 애플에서 정식으로 만든 프로그램은 아니며 Third Party(다른 사용자) 만든 프로그램니다. 라이브러리를 관리할때 Xcode 사용자들이 가장 많이 쓰는 프로그램이기도 하다.

 - Cocoapod 설치
Terminal을 켜서 Cocoapod를 설치하자.
```bash
sudo gem install cocoapods
```
_이미 Cocoapod 설치했을 경우 생략하고 넘어가자_

### 파이어베이스 연동 및 인증 라이브러리 설치

앱을 만드는 것 중에 투입된 노동대비 시간이 많이 걸리는 것이 이메일 로그인이다. 이메일로그인 보통 회원가입과 마찬가지로 이메일 아이디와 비밀번호를 이용해 로그인을 진행하는 방식이라고 생각하면 된다. 여기서 복잡한 이유는 로그인 화면과 회원가입화면을 구성해야 할 뿐만 아니라 비밀번호 재설정(비밀번호 찾기), 비밀번호 바꾸기, 메일 인증하기, 아이디 바꾸기 등 정말 많은 기능들이 있다. 

만약 이것을 소셜로그인만 대체한다면 간단하게 로그인 버튼 하나만 만들면 된다. 복잡하게 비밀번호 찾기나 아이디 찾기 비밀번호 변경등 이런 것들을 구성할 필요가 없다. 그럼 소셜로그인만 쓰면 되지 왜 이메일 로그인을 구성하는 것 일까? 

사실 안드로이드에는 소셜로그인만 앱을 만들어도 앱을 등록하는데 문제가 없다 하지만 아이폰 같은 경우는 소셜로그인으로만 앱을 만들 경우 앱 등록 심사 거부 당할 사유가 된다. 

![](Screen%20Shot%202019-11-04%20at%209.37.05%20PM.png)![](Screen%20Shot%202019-11-04%20at%209.37.06%20PM.png)
위에 프로젝트 경로 이동한 후 아래 명령어를 입력하게되면
```bash
pod init
```
 Podfile이 생성이 된다.

3. Podfile에 Firebaes Authorization 목록 추가
터미널에 이 명령어를 입력하면  
```bash
open Podfile
```
테스트 파일이 열리며 
```bash
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HowlTalk' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HowlTalk

  target 'HowlTalkTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HowlTalkUITests' do
    # Pods for testing
  end

end
```
여기에 인증 라이브러리(Auth)와 파이어베이스 코어(Analytics) Dependencies를 넣어주자.


```bash
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HowlTalk' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HowlTalk

  #파이어베이스 라이브러리 추가
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'

  target 'HowlTalkTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HowlTalkUITests' do
    # Pods for testing
  end

end
```



4. Podfile 목록에 있는라이브러리 설치

터미널에서 아래 명령어를 입력하게 되면 라이브러리가 설치되게 된다.
```bash
pod install
```

![](DraggedImage.tiff)
5. 설치가 끝났으면 프로젝트를 실행해보자.
Pod에서 설치한 인증라이브러리까지 같이 실행하기 위해서는 .xcworkpace로 프로젝트를 오픈하면 된다.
![](Screen%20Shot%202019-11-06%20at%2012.40.19%20AM.png)

### Firebase와 Xcode 프로젝트 연동
Firebase와 Xcode를 연동하기 위해서는  GoogleService-Info.plist 파일을 프로젝트 안으로 넣어주어야 한다. 먼저 GoogleService-Info.plist 생성하는 방법을 살펴보자.
1. Firebase Console 이동
[https://console.firebase.google.com](https://console.firebase.google.com/u/0/)이동 후 프로젝트를 생성해주자.
![](DraggedImage-1.tiff)

2. 프로젝트 생성

![](DraggedImage-2.tiff)
프로젝트 명은 **HowlTalk** 입력

![](DraggedImage-3.tiff)
계속 클릭하여 다음페이지로 넘어가자

![](DraggedImage-4.tiff)
나라는 대한민국 선택 후 약관 동의 후 프로젝트를 만들어보자.

3. GoogleService-Info.plist 추출하기

![](DraggedImage-5.tiff)
IOS 프로젝트를 추가해준다.

![](DraggedImage-6.tiff) ![](DraggedImage-7.tiff)
XCode의 Bundle Identifier를 참고해서 Bundle ID를 추가한다. 
![](Screen%20Shot%202019-11-06%20at%203.28.39%20AM.png)![](Screen%20Shot%202019-11-06%20at%203.51.37%20AM.png)
GoogleService-info.plist를 받고 프로젝트에 추가한다.

4. Firebase 초기화
```swift
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
```


AppDelegate.swift 파일의  application의 didFinishLaunchingWithOptions파라메터가 포함된 Function에   **FirebaseApp.configure()**  입력한다.


### 인증(Authorization)라이브러리 응용

1. 이메일 회원가입 코드
회원가입 로직을 만들기 위해서는 Auth Dependencies에  **createUser** Function을 사용하면 된다. _(아이디는 이메일, 비밀번호는 6자리 이상 필수)_

 - Interface Builder
![](Screen%20Shot%202019-11-06%20at%204.08.19%20AM.png)

- Swift
```swift
import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.addTarget(self, action: #selector(actionSignup), for: UIControl.Event.touchUpInside)
    }
    @objc func actionSignup(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (auth, err) in
            print(auth?.user)
        }
    }
}
```

2. 이메일 화원가입 설정 허가
![](Screen%20Shot%202019-11-06%20at%204.02.43%20AM.png)
파이어베이스 콘솔로 이동해서 회원가입 설정을 허가해주자.
  3. 아이디 생성확인
![](Screen%20Shot%202019-11-06%20at%204.02.43%20AM-1.png)
코드를 입력하고 실행하게되면 아이디가 생성된것을 볼 수가 있다.

### 데이터베이스(Realtime Database) 사용

데이터베이스는 다른 데이터베이스와 다른데 일단 첫번째로 NOSQL 기반의 3세대 데이터베이스이다. 현재 많이 쓰이고 있는 데이터베이스는 Document형식의 빠르고 간편한 NOSQL 기반의 데이터베이스를 도입했다. 또한 다른 데이터베이스와 다르게 RTSP(Real Time Stream Protocol) 방식의 데이터베이스를 지원하고 있다.  RTSP는 말 그대로 실시간으로 데이터들을 전송해주는 방식을 말한다. 실시간으로 데이터를 통신하는 데이터베이스라고 생각하시면 된다. 이 방식을 사용하면 소켓 기반 서버를 만들어서 통신하는 것보다 비약적으로 코드의 양이 줄어들게 되어 코드 몇 줄 로도 원하는 구성을 만들 수가 있다.


1. Podfile에 Database 추가하기

![](Screen%20Shot%202019-11-04%20at%209.37.05%20PM-1.png)![](Screen%20Shot%202019-11-07%20at%206.46.02%20PM.png)
위에 프로젝트 경로 이동한 후 아래 명령어를 입력하게되면
```bash
open Podfile
```
테스트 파일이 열리며 
```bash
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HowlTalk' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HowlTalk

#파이어베이스 라이브러리 추가
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'

  target 'HowlTalkTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HowlTalkUITests' do
    # Pods for testing
  end

end
```

여기에 데이터베이스 라이브러리를 추가한 후에 터미널에서 아래 명령어를 입력해서 데이터베이스를 설치해보자.
```bash
pod install
```

![](Screen%20Shot%202019-11-07%20at%206.58.02%20PM.png)

#### 데이터베이스 시작 설정하기

1. 파이어베이스 콘솔로 이동하자
[https://console.firebase.google.com](https://console.firebase.google.com/u/0/)이동 후 **HowlTalk**프로젝트로 이동하자

2. 데이터베이스를 만들자
![](Screen%20Shot%202019-11-07%20at%207.02.57%20PM.png)

3. **테스트 모드**로 설정 후 **사용 설정**을 클릭하자
![](Screen%20Shot%202019-11-07%20at%207.04.32%20PM.png)


#### 데이터베이스 쓰기
기본 쓰기 작업의 경우 setValue를 사용하여 지정된 참조에 데이터를 저장하고 기존 경로의 모든 데이터를 대체할 수 있습니다. 이 메소드의 용도는 다음과 같습니다.

사용 가능한 JSON 유형에 해당하는 다음과 같은 유형을 전달합니다.
  -  String
 - Number
 - Map(Dictionary)
- Array
예를 들어 setValue로 다음과 같이 사용자를 추가할 수 있습니다.


##### 데이터 입력
데이터를 입력하기 위해서는 setValue라는 코드를 사용해주면 된다. 하지만 저장된 데이터의 uid값을 발급하는 구조가 아니기 때문에 데이터를 누적해줄 수가 없다.
 - Interface Builder
![](Screen%20Shot%202019-11-07%20at%207.25.09%20PM.png)

- Swift
```swift
import UIKit
import Firebase
import FirebaseDatabase
class ViewController: UIViewController {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.addTarget(self, action: #selector(actionSendMessage), for: UIControl.Event.touchUpInside)
    }
    @objc func actionSendMessage(){
        var map = [ "username" : "자신의 이름"]
        var uid = Auth.auth().currentUser?.uid
        Database.database().reference()
			.child("chats")
			.child(uid!)
			.setValue(map)
    }
}
```

 - 데이터 입력 구조
Child라는 방법을 통해서 최종적으로 Json(Map 데이터)를 저장하게 된다.
![](Screen%20Shot%202019-11-07%20at%2011.32.01%20PM%20(3).png)

###### 데이터 누적 입력
데이터를 누적해서 입력해주기 위해서는 입력하는 데이터에 일일이 고유의 UID 값을 입력해주어야 한다. 입력해주는 방법은 데이터 입력시 **childByAutoId()** 코드를 추가해주면 된다.
```swift
Database.database().reference()
			.child("chats")
			.child(uid!)
			.childByAutoId()
			.setValue(map)
```
 - 데이터 누적 입력 구조
![](Screen%20Shot%202019-11-07%20at%2011.34.31%20PM%20(3).png)
결과를 랜덤으로 생성된 UID값이 입력되면서 경로가 하나더 기록된 것을 볼 수가 있다.

##### 데이터 읽기

데이터를 읽어오는 방법은 2가지가 있습니다. 첫번째는 데이터를 한번만 읽어오는 방식이 있으며 두번째는 데이터베이스를 실시간으로 항상 지켜보는 방식이 있습니다. 이 2가지는 상황에 따라 잘 사용하면 됩니다. **첫번째 방식**은 **갱신이 필요하지 않은 데이터**를 불러올때 많이 사용하며 두번째 방식은 **채팅이나 메세지 혹은 게임**을 만들때 가장 많이 사용합니다.

 1. Get방식
**observeSingleEvent** 코드를 통해서 데이터를 한번만 읽어오는 방식입니다.
```swift
Database.database()
    .reference()
    .child("chats")
    .child(uid!)
    .observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        print(snapshot.value)
    })
```
**observeSingleEvent** 코드를 입력해서 사용해주면 된다. 이 코드를  **viewDidLoad**안에다가 넣어주자.

```swift
class ViewController: UIViewController {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.addTarget(self, action: #selector(actionSendMessage), for: UIControl.Event.touchUpInside)
        let uid = Auth.auth().currentUser?.uid
        Database.database()
            .reference()
            .child("chats")
            .child(uid!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                print(snapshot.value)
            })
    }    
}
```

 - 결과

```bash
Optional({
    "-Lt5HL5BMlVULijHDBBp" =     {
        message = "bye~";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    "-Lt5HMLSngBlmozj32lA" =     {
        message = "how are you?";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    message = hi;
    username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
})
```

2. Snapshot방식
데이터가 실시간으로 변화하는 것까지 읽어오는 방식
** observe** 코드를 통해서 데이터를 한번만 읽어오는 방식입니다.
```swift
Database.database()
    .reference()
    .child("chats")
    .child(uid!)
    .observe(DataEventType.value, with: { (snapshot) in          	print(snapshot.value)
    })
```
** observe** 코드를 입력해서 사용해주면 된다. 이 코드를  **viewDidLoad**안에다가 넣어주자.

```swift
class ViewController: UIViewController {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.addTarget(self, action: #selector(actionSendMessage), for: UIControl.Event.touchUpInside)
        let uid = Auth.auth().currentUser?.uid
        Database.database()
            .reference()
            .child("chats")
            .child(uid!)
		    .observe(DataEventType.value, with: { (snapshot) in          	print(snapshot.value)
		    })
    }    
}
```
 - 결과
```bash
Optional({
    "-Lt5HL5BMlVULijHDBBp" =     {
        message = "bye~";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    "-Lt5HMLSngBlmozj32lA" =     {
        message = "how are you?";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    message = hi;
    username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
})

```

**bye**라고 저장된 데이터를 **bye!**로 바꾸게 되면 아래와 같은 로그가 추가적으로 발생하기 된다.
```bash
Optional({
    "-Lt5HL5BMlVULijHDBBp" =     {
        message = "bye~";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    "-Lt5HMLSngBlmozj32lA" =     {
        message = "how are you?";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    message = hi;
    username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
})
Optional({
    "-Lt5HL5BMlVULijHDBBp" =     {
        message = "bye!";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    "-Lt5HMLSngBlmozj32lA" =     {
        message = "how are you?";
        username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
    };
    message = hi;
    username = "\Uc790\Uc2e0\Uc758 \Uc774\Ub984";
})
```
