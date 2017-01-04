# KabuKit
[![Build Status](https://travis-ci.org/crexista/KabuKit.svg?branch=master)](https://travis-ci.org/crexista/KabuKit)
[![codecov](https://codecov.io/gh/crexista/KabuKit/branch/master/graph/badge.svg)](https://codecov.io/gh/crexista/KabuKit)

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
- CocoaPods 1.1.0+ or Carthage 0.18.1+

## Installation
### CocoaPods
- デフォルト
  - Podfile
    ```Ruby
    # Podfile
    use_frameworks!

    target '{YOUR_TARGET_NAME}' do
        pod 'KabuKit', '0.0.1'
        pod 'RxSwift', '3.0'
        pod 'RxCocoa', '3.0'
    end
    ```
  - Shellコマンド
    ```Shell
    $ pod install
    ```
- Rx Support なし
  - Podfile
    ```Ruby
    # Podfile
    use_frameworks!

    target '{YOUR_TARGET_NAME}' do
        pod 'KabuKit/Scene', '0.0.1'
        pod 'RxSwift', '3.0'
        pod 'RxCocoa', '3.0'
    end
    ```
  - Shellコマンド
    ```Shell
    $ pod install
    ```

### Carthage
- デフォルト
  - Cartfile
    ```
    github "crexista/KabuKit"
    ```
  - Shellコマンド
    ```Shell
    carthage update --platform iOS
    ```
  - Run Script Build Phase
    ```Shell
    /usr/local/bin/carthage copy-frameworks
    ```
  - Input files
    ```
    $(SRCROOT)/carthage/Build/iOS/KabuKit.framework
    $(SRCROOT)/carthage/Build/iOS/RxSwift.framework # if you've not added
    ```

---

## Basic Usage
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

  }
  ```


#### 1. ViewController を実装する
extensionでActionScene Protocolを実装します  
ex) Sample1AViewController
```Swift
import Foundation
import KabuKit

extension Sample1AViewController : Scene {

    // MARK: - SceneTransition Protocol
    enum Sample1Link : SceneTransition {
        typealias StageType = UIViewController
        case A, B

        func request(context: SceneContext<UIViewController>) -> SceneRequest? {
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

    var isRemoval: Bool {
        return self.argument!
    }

    func onRemove(stage: UIViewController) {
        _ = stage.navigationController?.popViewController(animated: true)
    }

    func onPressAButton(sender: UIButton) {
        self.director?.changeScene(transition: Sample1Link.A)
    }

    func onPressBButton(sender: UIButton) {
        self.director?.changeScene(transition: Sample1Link.B)
    }

    func onPressPrevButton(sender: UIButton) {
        self.director?.exitScene()
    }

    // MARK: - Override
    override func viewDidLoad() {
        prevButton.isEnabled = self.argument!
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }

    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil && !isReleased) {
            director?.exitScene()
        }
    }

}
  ```

- Handle SceneTransition

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

- Implements Scene

    ```Swift
        // MARK: - ActionScene Protocol
      typealias TransitionType = Sample1Link
      typealias ArgumentType = Bool

      var isRemoval: Bool {
        return self.argument!
      }

      func onRemove(stage: UIViewController) {
          _ = stage.navigationController?.popViewController(animated: true)
      }
    ```
    Scene Protocolの実装である事を宣言した場合、上記のようなコードを書く必要があり以下の1つのメソッドと2つのtypealiasを宣言する必要があり、
    そして3つのプロパティが提供されます
    - typealias
      1. `ArgumentType`  
      ActionSceneを実装しているクラスが画面を描画する際に必要となる情報の型です。  
      このサンプルでは戻るボタンを有効にするか否かの情報を送るためにBool型を指定しています
      1. `TransitionType`  
      ユーザーからのなんらかのアクションによって画面遷移をする事になった際、どのような時にどのような遷移を行うか  
      というのを記述したクラス(正確にはSceneTransitionを実装したクラス)の型をここに指定します。  
      今回に場合はクラス内に記述されている実装したEnum、`Sample1Link` を指定しています。  

    - method
      1. `isRemovable`  
      この画面が破棄可能かどうかを返すゲッターです。  
      このプロパティが常にfalseを返すようにすると、画面を破棄することができなくなります。  
      1. `onRemove`  
      上記のisRemovalがtrueを返した時に呼ばれます。  
      その際このクラスが指定しているSceneTransitionクラスのStageTypeのクラスが引数としてよばれます  
      このメソッドが呼ばれるとdirector等、Sceneが持っているプロパティが全て破棄されます

- Properties
  ```Swift
    func onPressAButton(sender: UIButton) {
        self.director?.changeScene(transition: Sample1Link.A)
    }

    func onPressBButton(sender: UIButton) {
        self.director?.changeScene(transition: Sample1Link.B)
    }

    func onPressPrevButton(sender: UIButton) {
        self.director?.exitScene()
    }

    // MARK: - Override
    override func viewDidLoad() {
        prevButton.isEnabled = self.argument!
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
  ```
  上記のコードを見てわかるように、Sceneをimplementsすると `director` と `argument` というpropertyが提供されます。
  それぞれに責務は以下のとおりです。  

    1. director  
    Sceneを変更させるメソッド `changeScene` と `exitScene` を提供します。  
      - `changeScene`  
      TransitionType で定義されたクラスのインスタンスを引数に取ります。このメソッドを呼ぶとSceneTransitionクラスが呼ばれ画面遷移がされます
      ```Swift
      typealias TransitionType = Sample1Link
      director.changeScene(Sample1Link.A)
      ```
      - `exitScene`
      現状の画面から離脱します、が、離脱できない場合何も起きません(後述)

    1. argument  
      Sceneを初期化させるのに必要なプロパティです

  サンプルの`viewDidLoad` ではActionの初期化がされ且つ、activateが行われてますが、  
  このフレームワーク的にはどこでActionの初期化を行うかは規定していません。  
  このサンプルでは `viewDidLoad` が最適だっただけで、アプリによっては `viewWillAppear` で毎回初期化するのがいい場合もあります。  
  また、このフレームワークにおいてはPresentationロジックはViewController側に書く事はあまり推奨されていません(とはいえ書けますが)。  
  PresentationロジックはActionに書く事進められています。  
  Actionの実装の仕方については次項にて説明します。

#### 2. AppDelegateにて初期化
SceneとなるViewControllerの準備ができたらAppDelegateにて呼び出しのコードを書きます

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
SceneとなるViewControllerをnewで呼び出すことはできません。  
呼び出したとしても先述した `director` と `argument` property はnilのままです。  
Sceneの初期化には `SceneSequence` を上記コードのように使ってください

---
## Recommended Usage
### ActionSceneを使う
前述の方法でSceneをViewControllerにimplementsさせれば基本的に使えますが、このままだとやはり、ViewControllerは肥大化していきます。  
そこでRxSwiftを使った `ActionScene` というprotocolもこのフレームワークは提供しています

#### 1. ViewControllerの実装について
基本的なtypealiasとmethodの実装形式は `Scene` の時とは変わりません。  
新に `observer` というpropertyが一つ追加されるだけです。  
この `observer` によって以下のようにViewController内部のロジックを複数のActionに分割することが可能になります
```Swift
  // MARK: - Override
  override func viewDidLoad() {
    self.navigationItem.hidesBackButton = true
    let actionA = Sample1AAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
    let actionB = Sample1BAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)

    self.observer.activate(action: actionA, director: self.director, argument: self.argument)
    self.observer.activate(action: actionB, director: self.director, argument: self.argument)
  }
```

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

---

## 目次
* 基本概念
  * [Scene(画面)](#Scene)
  * [Stage(画面基底)](#Stage)
  * [SceneScequence(画面フロー)](#SceneSequence)
  * [SceneDirector(画面管理)](#Scene)
  * [SceneTranstion(画面遷移)](#SceneTransition)
  * [Argument(画面)](#Scene)
  * [Scenario(画面フロー制御)](#Scene)

### Scene(画面)
ユーザーのインタラクションを受け、描画切り替えを行ったり内部的にAPI通信したりする画面のことをSceneと呼びます。  
実装の詳細に関しては上述の Usage を見てください

### Stage(画面基底)
Sceneを表示するために必要となるUIComponentを示す概念です。  
概念そのもののためStageを示すクラスもプロトコルもこのフレームワークには存在しません。  
_(iOSの実装の場合、往々にして `UIViewController` になるのがほとんどです)_
ただ、変数名、関数の引数としては存在しており  
このフレームワークのプロトコル等を実装した際に `Stage` という単語が出てきた場合は  
このことを示しています  

### SceneSequence(画面フロー)
Sceneの遷移を管理するクラスです。  
一番最初に表示すべきSceneを定めるのもこのクラスの責務であるため、  
init時にstageとなるオブジェクトを渡す必要があり、start時には最初のSceneを設定する必要があります。  

```Swift
  let sequence = SceneSequence(UIViewController())
  sequence?.start(xibFile, Sample1AViewController.self, { (stage, scene) in
      stage.addChildViewController(scene)
      stage.view.addSubview(scene.view)
  })
```
### SceneDirector(画面管理)
画面を管理するクラスです。  
他の画面へ遷移させたい、もしくは現在の画面から離脱したい、といった場合  
以下のように `changeScene` または `exitScene` を呼びます
```Swift
  func onPressAButton(sender: UIButton) {
      self.director?.changeScene(transition: Sample1Link.A)
  }

  func onPressBButton(sender: UIButton) {
      self.director?.changeScene(transition: Sample1Link.B)
  }

  func onPressPrevButton(sender: UIButton) {
        self.director?.exitScene()
  }
```
なお、exitSceneが呼ばれ、かつ、Sceneの `isRemovable` プロパティが `true` を返した場合、  
Sceneに紐付いている `SceneDirector` と `Argument` はメモリ解放されます

### SceneTransition(画面遷移)
画面遷移ロジックを定義したProtocolです。  
このSceneTransitionを実装したクラス自体が画面遷移を行うわけではなく、  
このSceneTransitionを受け取ったSceneDirectorクラスが画面遷移を行います。

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
