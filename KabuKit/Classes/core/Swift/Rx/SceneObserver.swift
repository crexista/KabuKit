//
//  Copyright © 2016 crexista.
//

import Foundation
import RxSwift

public class SceneObserver {
    
    fileprivate var actions: NSMapTable<AnyObject, AnyObject>
    
    public func activate<T: Action>(action: T, director: SceneDirector<T.SceneType.TransitionType>?, argument: T.SceneType.ArgumentType?) {

        let disposables = action.start(director: director, argument: argument).map { (observable) -> Disposable in
            return observable.subscribe(onError: action.onError)
        }
        
        actions.setObject(disposables as AnyObject, forKey: action as AnyObject)

    }
    
    public func deactivate<T: Action>(action: T) {
        
        let disposables = actions.object(forKey: action as AnyObject) as? [Disposable]

        disposables?.forEach({ (disposable) in
            disposable.dispose()
        })
        action.onStop()
        actions.removeObject(forKey: action)
    }
    
    /**
     指定のActionが現在有効(動いている)かどうかを返します
     
     */
    public func isActive<T: Action>(action: T) -> Bool {
        if (actions.object(forKey: action) == nil) {
            return false
        }
        return true
    }

    /**
     保持しているActionを全て解放します
     internalにしているのはテストのためです
     
     */
    internal func release() {
        let enumerator = actions.keyEnumerator()
        while let key = enumerator.nextObject() {
            let disposables = actions.object(forKey: key as AnyObject) as? [Disposable]
            disposables?.forEach({ (disposable) in
                disposable.dispose()
            })
            (key as! OnStop).onStop()
        }
        actions.removeAllObjects()
    }
    
    deinit {
        print("actor deinit")
        release()
    }

    
    init() {
        actions = NSMapTable.strongToStrongObjects()
    }
}
