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
    
    public func activate<T: Action>(action: T, transition: SceneTransition<T.linkType>, context: T.contextType?) {
        let disposables = action.start(transition: transition, context: context).map { (observable) -> Disposable in
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

    deinit {
        print("actor deinit")
    }
    
    internal func terminate(){
        actions.dictionaryRepresentation().forEach { (key, value) in
            (value as? [Disposable])?.forEach({ (disposable) in
                disposable.dispose()
            })
            (key as! OnStop).onStop()
        }
        actions.removeAllObjects()
    }
        
    init() {
        actions = NSMapTable.strongToStrongObjects()
    }
}
