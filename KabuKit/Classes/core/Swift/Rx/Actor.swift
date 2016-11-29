//
//  Actor.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import RxSwift

public class Actor {
    
    fileprivate var actions: NSMapTable<AnyObject, AnyObject>
    
    public func activate<T: Action>(action: T, director: SceneDirector<T.SceneType.LinkType>, context: T.SceneType.ContextType?) {

        let disposables = action.start(director: director, context: context).map { (observable) -> Disposable in
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
