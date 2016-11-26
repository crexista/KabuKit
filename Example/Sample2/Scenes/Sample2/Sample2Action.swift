//
//  Sample2Action.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample2Action: Action {
    
    typealias linkType = Sample2ViewController.Sample2Link
    typealias contextType = Void
    
    unowned let startButton: UIButton

    func start(transition: SceneTransition<Sample2ViewController.Sample2Link>, context: ()?) -> [Observable<()>] {
        return [
            startButton.rx.tap.do(onNext: { () in transition.transitTo(link: Sample2ViewController.Sample2Link.A)})
        ]
    }
    
    func onStop() {
        print("onStop")
    }
    
    func onError(error: Error) {
    }
    
    deinit {
        print("action deinit")
    }
    
    
    init(startButton: UIButton) {
        self.startButton = startButton
    }
}
