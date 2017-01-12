//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift

/**
 SceneのActionを監視するクラスです.
 
 */
public class ActionActivator<DestinationType: Destination> {
    
    var actionTypeHashMap = [String : SignalClosable]()
    
    var disposableMap = [String : [SubscribeTarget]]()
    
    let director: Director<DestinationType>
    
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
    public func activate<A: Action>(action: A, onStart: () -> Void = {}) -> Bool where A.DestinationType == DestinationType{
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
    public func deactivate<A: Action>(actionType: A.Type) -> Bool where A.DestinationType == DestinationType{
        // 指定のクラス名に紐づくDisposableを取得し
        // 全て破棄し、DisposableMapも空にする
        let typeName = String(describing: actionType)
        return deactivateByTypeName(typeName: typeName)

    }
    
    /**
     このactivatorで管理されている全ての Actionをサスペンド状態にします
     
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
    public func isActive(actionType: SignalClosable.Type) -> Bool {
        let typeName = String(describing: actionType)
        return disposableMap[typeName] != nil
    }
    
    /**
     Actionの型情報をキーとしてactivate済みのActionのインスタンスを取得します
     
     - parameters: 
       - actionType: Actionの型
     */
    public func resolve<A: Action>(actionType: A.Type) -> A? where A.DestinationType == DestinationType{
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
        
        guard let Action = actionTypeHashMap[actionError.actionName] else {
            return
        }

        let target = actionError.target
        
        switch actionError.recoverPattern {

        case .reloadAction(let onStart):
            deactivateAll()
            onStart()
            
        case .reloadErrorSignal(let onStart):
            _ = self.subscribe(target: target, action: Action)
            onStart()

        default:
            break
        }
    }
    
    private func subscribe(target: SubscribeTarget, action: SignalClosable) -> SubscribeTarget {
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
    
    internal init(director: Director<DestinationType>) {
        self.director = director
    }
}
