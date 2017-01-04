//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift

/**
 SceneのActionを監視するクラスです.
 
 */
public class SceneObserver2<RouterType: SceneRouter> {
    
    var actionTypeHashMap = [String : ActionTerminate]()
    
    var disposableMap = [String : [ObserverTarget]]()
    
    let director: Director<RouterType>
    
    /**
     指定のActionを有効化させます.
     
     - attention: activateできるActionのインスタンスには条件があります
     
       * activateできるActionは1クラスにつき1インスタンスまでです.
     
       * すでにactivateされているactionを再度activateしても何も起きません
     
       * ただし、deactivate済みのactionであれば再度activateをします
     
     - parameters:
       - action: activateされるActionプロトコルを実装したクラスインスタンス
       - onStart: actionが開始される直前に呼ばれるコールバック
     
     - returns: activateが実行され、actionが有効化されたらtrueを返します.
                すでにactivate済みのインスタンスがactionに指定された場合は何もされないため
                falseを返します
     */
    public func activate<A: Action2>(action: A, onStart: () -> Void = {}) -> Bool where A.RouterType == RouterType{
        let typeName = String(describing: type(of: action))
        
        guard disposableMap[typeName] == nil else {
            return false
        }

        actionTypeHashMap[typeName] = actionTypeHashMap[typeName] ?? action

        disposableMap[typeName] = action.invoke(director: director).map{ (target) in
            return self.subscribe(target: target, action: action)
        }
        
        onStart()
        return true
    }
    
    /**
     指定のActionをサスペンド状態にします.
     
     これで指定されたActionのSignalは全て破棄され、
     再度activateされるまでイベントを飛ばすことはありません
     
     */
    public func deactivate<A: Action2>(actionType: A.Type) -> Bool where A.RouterType == RouterType{
        // 指定のクラス名に紐づくDisposableを取得し
        // 全て破棄し、DisposableMapも空にする
        let typeName = String(describing: actionType)
        return deactivateByTypeName(typeName: typeName)

    }
    
    /**
     このObserverで管理されている全ての Actionをサスペンド状態にします
     
     */
    public func deactivateAll() {
        actionTypeHashMap.keys.forEach { (typeName) in
            _ = self.deactivateByTypeName(typeName: typeName)
        }
    }
    
    /**
     指定のActionが現在動いているか(activateされている状態か)どうかを返します
     
     - parameters:
       - actionType: Actionの型
     - returns: 指定のActionが現在動いている場合は `true` そうでない場合は `false` を返します
     */
    public func isActive(actionType: ActionTerminate.Type) -> Bool {
        let typeName = String(describing: actionType)
        return disposableMap[typeName] != nil
    }
    
    /**
     Actionの型情報をキーとしてactivate済みのActionのインスタンスを取得します
     
     - parameters: 
       - actionType: Actionの型
     */
    public func resolve<A: Action2>(actionType: A.Type) -> A? where A.RouterType == RouterType{
        let typeName = String(describing: actionType)

        return actionTypeHashMap[typeName] as? A
    }
    
    /**
     クラス名指定によってActionをサスペンド状態にします.

     - parameters:
       - typeName: クラス名
     
     - returns: サスペンドに成功したらtrue, サスペンドが行われなかったらfalseを返します
     */
    private func deactivateByTypeName(typeName: String) -> Bool {
        guard let disposables = disposableMap[typeName] else {
            return false
        }
        
        disposables.forEach { (disposable) in
            disposable.dispose()
        }
        actionTypeHashMap[typeName]?.onStop()
        disposableMap.removeValue(forKey: typeName)
        return true
    }
    
    /**
     キャッチしたエラーをハンドルして
     リカバリ処理を行います
     
     */
    private func recoverError(error: Error) {
        guard let actionError = error as? ActionError else {
            return
        }
        
        guard let action2 = actionTypeHashMap[actionError.actionName] else {
            return
        }

        let target = actionError.target
        
        switch actionError.recoverPattern {

        case .reloadAction(let onStart):
            deactivateAll()
            onStart()
            
        case .reloadErrorStream(let onStart):
            _ = self.subscribe(target: target, action: action2)
            onStart()

        default:
            break
        }
    }
    
    private func subscribe(target: ObserverTarget, action: ActionTerminate) -> ObserverTarget {
        let disposable = target.observable.catchError({ (error) -> Observable<()> in
            
            throw ActionError(recoverPattern: action.onError(error: error, label: target.label),
                              target: target,
                              onError: action.onError,
                              actionName: String(describing: type(of: action)))

        }).subscribe(onError: self.recoverError)
        target.disposable?.dispose()
        target.disposable = disposable
        return target
    }
    
    deinit {
        deactivateAll()
        actionTypeHashMap.removeAll()
    }
    
    internal init(director: Director<RouterType>) {
        self.director = director
    }
}
