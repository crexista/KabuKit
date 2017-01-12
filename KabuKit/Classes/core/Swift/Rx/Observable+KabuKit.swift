//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift

/**
 RxSwiftのObservable<E>をこのフレームワークのActionEventに変換するための
 カテゴリ拡張です
 
 */
extension Observable {
    
    /**
     ObservableなオブジェクトをActionEventに変換します
     
     
     ```Swift
     let target: ActionEvent = Observable<Int>.just(1).toTarget
     
     ```
     */
    public var toTarget: ActionEvent {
        return ActionEvent(observable: self)
    }
    
    /**
     Observableのstreamに名前をつけます.
     ActionそれによりAction側でErrorが起きた時にどのストリームでエラーが起きたか、
     などを知ることができるようになります
     
     - example:
     
     ```Swift
     let target: ActionEvent = Observable<Int>.just(1)["SampleStream"]
     
     ```
     
     */
    public subscript(label: String) -> ActionEvent {
        return ActionEvent(observable: self, label: label)
    }
}
