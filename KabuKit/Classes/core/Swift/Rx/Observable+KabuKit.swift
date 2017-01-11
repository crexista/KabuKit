//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift

/**
 RxSwiftのObservable<E>をこのフレームワークのObserverTargetに変換するための
 カテゴリ拡張です
 
 */
extension Observable {
    
    /**
     ObservableなオブジェクトをObserverTargetに変換します
     
     
     ```Swift
     let target: ObserverTarget = Observable<Int>.just(1).toTarget
     
     ```
     */
    public var toTarget: ObserverTarget {
        return ObserverTarget(observable: self)
    }
    
    /**
     Observableのstreamに名前をつけます.
     ActionそれによりAction側でErrorが起きた時にどのストリームでエラーが起きたか、
     などを知ることができるようになります
     
     - example:
     
     ```Swift
     let target: ObserverTarget = Observable<Int>.just(1)["SampleStream"]
     
     ```
     
     */
    public subscript(label: String) -> ObserverTarget {
        return ObserverTarget(observable: self, label: label)
    }
}
