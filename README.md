# KabuKit
KabuKit is Simple & Tiny Application Framework
--
このFrameworkはつい膨れ上がってしまうViewControllerの肥大化を防ぎ、  
かつ乱雑になりがちな画面操作周りのコードを整理し保守性を高めるという目的で作られました。  
すでにあるAppleのUIKitといったFrameworkとの親和性も考えて作られてあります。  
なお、このFrameworkが主にサポートするのは以下の3点(4点)です。  

1. 画面の描画ロジックと遷移ロジックの分離
2. 画面の描画初期時に必要となるデータの受け渡し
3. 画面のライフサイクル管理
4. RxSwiftのサポート(optional)

## Requirements
- Xcode 8.1+
- Swift 3.0+

## Installation
### CocoaPods
CocoaPods 1.1.0+

```Ruby
# Podfile
use_frameworks!

target '{YOUR_TARGET_NAME}' do
    pod 'KabuKit', '0.0.1'
    pod 'RxSwift', '3.0'
    pod 'RxCocoa', '3.0'
end
```

```Shell
$ pod install
```

## Usage
### Simple Push/Pop Application
以下のシンプルなUIViewControllerを pushViewController/popViewController するだけのアプリ
- SampleAViewcontroller
  ```Swift
  import UIKit

  class Sample1AViewController: UIViewController {
    
      @IBOutlet weak var label: UILabel!
      @IBOutlet weak var nextButtonA: UIButton!
      @IBOutlet weak var nextButtonB: UIButton!
      @IBOutlet weak var prevButton: UIButton!
    
      deinit {
          print("sample1A deinit")
      }
  }
  ```
- SampleBViewcontroller
  ```Swift
  import UIKit

  class Sample1BViewController: UIViewController {
    
      @IBOutlet weak var label: UILabel!
      @IBOutlet weak var nextButtonA: UIButton!
      @IBOutlet weak var nextButtonB: UIButton!
      @IBOutlet weak var prevButton: UIButton!
    
      deinit {
          print("sample1B deinit")
      }
  }
  ```


#### 1. ViewController を実装する
基本的にextensionでActionScene Protocolを実装します  
ex) Sample1AViewController
  ```Swift
  import Foundation
  import KabuKit

  extension Sample1AViewController: ActionScene {
    
      // MARK: - SceneTransition Protocol
      enum Sample1Link : SceneTransition {
          typealias StageType = UIViewController
          case A, B
        
          func request(context: SceneContext<UIViewController>) -> SceneChangeRequest? {
              switch self {
              case .A:
                  let xib = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
                  return context.sceneRequest(xib, Sample1AViewController.self, true) { (stage, scene) in
                      stage.navigationController?.pushViewController(scene, animated: true)
                  }
              case .B:
                  let xib = ViewControllerXIBFile("Sample1BViewController", Bundle.main)
                  return context.sceneRequest(xib, Sample1BViewController.self, nil) { (stage, scene) in
                      stage.navigationController?.pushViewController(scene, animated: true)
                  }
              }
          }
      }

      // MARK: - ActionScene Protocol
      typealias TransitionType = Sample1Link
      typealias ArgumentType = Bool

      func onRelease(stage: UIViewController) -> Bool {
          _ = stage.navigationController?.popViewController(animated: true)
          return true
      }

      // MARK: - Override
      override func viewDidLoad() {
          self.navigationItem.hidesBackButton = true
          prevButton.isEnabled = argument!
          let action = Sample1AAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
          actor.activate(action: action, director: self.director, argument: self.argument)
      }
    
      override func viewDidDisappear(_ animated: Bool) {
          if (self.navigationController == nil && !isReleased) {
              director?.exit()
          }
      }
  }
  ```
##### 解説
- SceneTranstion Protocol の実装について
  
    ```Swift
    // MARK: - SceneTransition Protocol
    enum Sample1Link : SceneTransition {
        typealias StageType = UIViewController
        case A, B
        
        func request(context: SceneContext<UIViewController>) -> SceneChangeRequest? {
            switch self {
            case .A:
                let xib = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
                return context.sceneRequest(xib, Sample1AViewController.self, true) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            case .B:
                let xib = ViewControllerXIBFile("Sample1BViewController", Bundle.main)
                return context.sceneRequest(xib, Sample1BViewController.self, nil) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            }
        }
    }
    ```
    上記の `Sample1AViewController` のサンプルではクラス内にenum `Sample1Link` が定義されており  
    そして `Sample1Link` は SceneTransition の実装となっています。  
    SceneTranstionの実装である事を宣言した場合以下の1つのメソッドと1つのtypealiasを宣言する必要があります  
    1. StageType
    このアプリケーション全体を通して表示の規定となるクラスの型です。後述しますがSequence起動時に渡されるクラスの型でもあります。  
    基本的なiOSアプリケーションにおいてが大体の場合、UIViewControllerになります
    1. request
    ユーザーからのなんらかのアクションによって画面遷移をする事になった際、どのような時にどのような遷移を行うかのハンドリングを行うメソッドです。  
    
    このサンプルでは各クラス(Sample1AViewController, Sample1BViewController)内にenumでそれぞれ定義していますが  
    共通化させ別ファイルにしてそれぞれのクラスで同じTransitionを使用するというのも可能です。  

- ActionScene Protocol の実装について
  
    ```Swift
        // MARK: - ActionScene Protocol
      typealias TransitionType = Sample1Link
      typealias ArgumentType = Bool

      func onRelease(stage: UIViewController) -> Bool {
          _ = stage.navigationController?.popViewController(animated: true)
          return true
      }
    ```
    ActionScene Protocolの実装である事を宣言した場合、上記のようなコードを書く必要があり以下の1つのメソッドと2つのtypealiasを宣言する必要があり、
    そして3つのプロパティが提供されます
    - 宣言すべき typealias
      1. ArgumentType  
      ActionSceneを実装しているクラスが画面を描画する際に必要となる情報の型です。  
      このサンプルでは戻るボタンを有効にするか否かの情報を送るためにBool型を指定しています
      1. TransitionType  
      ユーザーからのなんらかのアクションによって画面遷移をする事になった際、どのような時にどのような遷移を行うか  
      というのを記述したクラス(正確にはSceneTransitionを実装したクラス)の型をここに指定します。  
      今回に場合はクラス内に記述されている実装したEnum、`Sample1Link` を指定しています。  
    - 実装すべきメソッド
      1. onRelease  
      `dissmissViewController` や `popViewController` などで画面が解放され、捨てられる時に呼ばれます。
      その際このクラスが指定しているSceneTransitionクラスのStageTypeのクラスが引数としてよばれます
    
    - 提供されるプロパティ
      1. director?  
      Sceneを変更させるメソッド `transitTo` と `exit` を提供します。  
       - `transitTo`  
       TransitionType で定義されたクラスのインスタンスを引数に取ります。このメソッドを呼ぶとSceneTransitionクラスが呼ばれ画面遷移がされます
       ```Swift
       typealias TransitionType = Sample1Link
       director.transitTo(Sample1Link.A)
       ```
       - `exit`
       現状の画面から離脱します、が、離脱できない場合(SinglePage Application)何も起きません
       
      1. argument?  
      Sceneを初期化させるのに必要なプロパティです
    

- その他
  ```Swift
   // MARK: - Override
   override func viewDidLoad() {
       self.navigationItem.hidesBackButton = true
       prevButton.isEnabled = argument!
       let action = Sample1AAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
       actor.activate(action: action, director: self.director, argument: self.argument)
   }
  ```
  サンプルの`viewDidLoad` ではActionの初期化がされ且つ、activateが行われてますが、  
  このフレームワーク的にはどこでActionの初期化を行うかは規定していません。  
  このサンプルでは `viewDidLoad` が最適だっただけで、アプリによっては `viewWillAppear` で毎回初期化するのがいい場合もあります。  
  また、このフレームワークにおいてはPresentationロジックはViewController側に書く事はあまり推奨されていません(とはいえ書けますが)。  
  PresentationロジックはActionに書く事進められています。  
  Actionの実装の仕方については次項にて説明します。  
    
#### 2. Actionを実装する
Action Protoolを以下のように実装します
```Swift
import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample1AAction: Action {
    
    unowned let label: UILabel
    unowned let nextButtonA: UIButton
    unowned let nextButtonB: UIButton
    unowned let prevButton: UIButton
    
    typealias SceneType = Sample1AViewController
    
    func start(director: SceneDirector<Sample1AViewController.Sample1Link>?, argument: Bool?) -> [Observable<()>] {
        return [
            self.nextButtonA.rx.tap.do(onNext: { () in director?.transitTo(link: Sample1AViewController.Sample1Link.A)}),
            self.nextButtonB.rx.tap.do(onNext: { () in director?.transitTo(link: Sample1AViewController.Sample1Link.B)}),
            self.prevButton.rx.tap.do(onNext: { () in _ = director?.exit()})
        ]
    }
    
    func onStop() {
        // TODO implement
    }
    
    func onError(error: Error) {
       // TODO implement
    }
    
    init(label: UILabel, buttonA: UIButton, buttonB: UIButton, prevButton: UIButton) {
        self.label = label
        self.nextButtonA = buttonA
        self.nextButtonB = buttonB
        self.prevButton = prevButton
    }
}
```
##### 解説
- Actionクラスの実装について
  ```Swift
  typealias SceneType = Sample1AViewController
    
  func start(director: SceneDirector<Sample1AViewController.Sample1Link>?, argument: Bool?) -> [Observable<()>] {
      return [
          self.nextButtonA.rx.tap.do(onNext: { () in director?.transitTo(link: Sample1AViewController.Sample1Link.A)}),
          self.nextButtonB.rx.tap.do(onNext: { () in director?.transitTo(link: Sample1AViewController.Sample1Link.B)}),
          self.prevButton.rx.tap.do(onNext: { () in _ = director?.exit()})
      ]
  }
    
  func onStop() {
    // TODO implement if you need
  }
    
  func onError(error: Error) {
    // TODO implement if you need
  }
  ```
  Action Protocolを宣言した場合は上記のようなメソッドとtypealiasを指定する必要があります
  1. SceneType  
  このActionがどのSceneに紐付いているか定義します。
  1. start  
  Actionを起動させます。具体的にはここで返しているRxSwiftのObservableを一括でsubscribeします。  
  1. onStop  
  このActionを停止した際に呼ばれます。  
  終了処理ではなく、停止した際、という事に注意してください。
  1. onError  
  startでsubscribeされたSigalがなんらかのエラーを起こし、そしてキャッチし損ねた場合、ここに辿りつきます

#### 3. AppDelegateにて初期化
以下のコードをAppDelegateに書きます

```Swift
  let root = UIViewController()
  let xibFile = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
  sceneSequence = SceneSequence(root)
  // Sequence Start
  // stageはroot, sceneはSample1AViewControllerのインスタンス
  sceneSequence?.start(xibFile, Sample1AViewController.self, { (stage, scene) in
      stage.addChildViewController(scene)
      stage.view.addSubview(scene.view)
  })
```
SceneSequenceをスタートさせます

