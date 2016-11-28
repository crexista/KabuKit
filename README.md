# KabuKit
KabuKit is Simple & Tiny Application Framework
--
このFrameworkはつい膨れ上がってしまうViewControllerの肥大化を防ぎ、
かつ乱雑になりがちな画面操作周りのコードを整理し保守性を高めるという目的で作られました。
すでにあるAppleのUIKitといったFrameworkとの親和性も考えて作られてあります。
なお、このFrameworkが主にサポートするのは以下の3点(4点)です

1. 画面の描画ロジックと遷移ロジックの分離
2. 画面の描画初期時に必要となるデータの受け渡し
3. 画面のライフサイクル管理
4. RxSwiftのサポート(optional)

## Installation
TODO

## Requirements
- Xcode 8.1+
- Swift 3.0+

## Get Started
### Example. Simple Push/Pop Application
at AppDelegate
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

at ViewController
```Swift
extension Sample1AViewController: ActionScene {
    
    enum Sample1Link : SceneLink {
        case A
        case B
    }
    
    typealias StageType = UIViewController
    typealias ContextType = Bool
    typealias LinkType = Sample1Link
    
    override func viewDidLoad() {
        let action = Sample1AAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: self.transition, context: self.context)
    }
    
//画面遷移リクエストがくるとこのメソッドがよばれ、Router的な役目を果たします
    func onChangeSceneRequest(link: Sample1Link, factory: SceneChangeRequestFactory<UIViewController>) -> SceneChangeRequest? {
        
        switch link {
        case .A:
        // 同じ画面を新しく作り、その画面に遷移します
            let xib = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
            let vc = factory.createSceneChangeRequest(xib, Sample1AViewController.self, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            return vc
        case .B:
        // 違う画面を新しく作り、その画面に遷移します
            let xib = ViewControllerXIBFile("Sample1BViewController", Bundle.main)
            let vc = factory.createSceneChangeRequest(xib, Sample1BViewController.self, nil) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            return vc
        }
    }
    
    func onBackRequest(factory: SceneBackRequestFactory<UIViewController>) -> SceneBackRequest? {
        return factory.createBackRequest({ (stage) -> Bool in
            _ = stage.navigationController?.popViewController(animated: true)
            return true
        })
    }
}
```

at Action (RxSwift)
```Swift
import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample1AAction: Action {
    
    typealias SceneType = Sample1AViewController
    
    unowned let label: UILabel
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton
    
    func start(transition: SceneTransition<Sample1AViewController.Sample1Link>, context: Bool?) -> [Observable<()>] {
        return [
            self.nextButtonA.rx.tap.do(onNext: { () in transition.transitTo(link: Sample1AViewController.Sample1Link.A)}),
            self.nextButtonB.rx.tap.do(onNext: { () in transition.transitTo(link: Sample1AViewController.Sample1Link.B)}),
            self.prevButton.rx.tap.do(onNext: { () in transition.back()})
        ]
    }
    
    func onStop() {
        print("onStop")
    }
    
    func onError(error: Error) {
    }
    
    deinit {
        print("action deinit")
    }
    
    
    init(label: UILabel, buttonA: UIButton, buttonB: UIButton, prevButton: UIButton) {
        self.label = label
        self.nextButtonA = buttonA
        self.nextButtonB = buttonB
        self.prevButton = prevButton
    }
}
```
