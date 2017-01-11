//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift

public class ObserverTarget {
    
    internal let observable: Observable<Void>
    internal var label: String?
    internal var disposable: Disposable?
    
    internal func dispose() {
        disposable?.dispose()
        disposable = nil
    }
    
    internal init<E>(observable: Observable<E>, label: String? = nil) {
        self.observable = observable.map { (element) -> Void in }
        self.label = label
    }
}
