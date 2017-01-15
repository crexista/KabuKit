//
//  Copyright © 2017年 crexista
//

import Foundation
import RxSwift

/**
 ActionEventのRxSwift実装です
 
 */
internal class RxSwiftEvent: ActionSignal {
    
    internal let observable: Observable<Void>
    internal var label: String?
    internal var disposable: Disposable?
    internal var isRunning: Bool = false
    
    internal func dispose() {
        disposable?.dispose()
        disposable = nil
    }
    
    /**
     Eventを開始します.
     内部でRxSwiftのObservableをsubscribeし、次へつなげます
     
     */
    internal func start<A: Action>(action: A, event: ActionEvent, recoverHandler: @escaping (ActionError<A>, RecoverPattern) -> Void) {
        disposable?.dispose()

        disposable = observable.subscribe (onError: { (error) in
            let actionError = ActionError(from: action, event: event, cause: error)
            recoverHandler(actionError, action.onError(error: error, label: event.label))
        }, onDisposed: {() in
            self.isRunning = false
        })
        isRunning = true
    }
        
    internal init<E>(observable: Observable<E>, label: String? = nil) {
        self.observable = observable.map { (element) -> Void in }
        self.label = label
    }

    
}
