//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift

/**
 RxSwiftのObservable<E>をこのフレームワークのSubscribeTargetに変換するための
 カテゴリ拡張です
 
 */
extension Observable {
    
    /**
     ObservableなオブジェクトをSubscribeTargetに変換します
     
     
     ```Swift
     let target: SubscribeTarget = Observable<Int>.just(1).toTarget
     
     ```
     */
    public var toTarget: SubscribeTarget {
        return SubscribeTarget(observable: self)
    }
    
    /**
     Observableのstreamに名前をつけます.
     ActionそれによりAction側でErrorが起きた時にどのストリームでエラーが起きたか、
     などを知ることができるようになります
     
     - example:
     
     ```Swift
     let target: SubscribeTarget = Observable<Int>.just(1)["SampleStream"]
     
     ```
     
     */
    public subscript(label: String) -> SubscribeTarget {
        return SubscribeTarget(observable: self, label: label)
    }
}
