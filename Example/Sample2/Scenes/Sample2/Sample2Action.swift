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
    
    typealias SceneType = Sample2ViewController
    
    unowned let startButton: UIButton

    func start(director: SceneDirector<Sample2ViewController.Sample2Link>, argument: ()?) -> [Observable<()>] {

        return [
            startButton.rx.tap.do(onNext: { () in director.transitTo(link: Sample2ViewController.Sample2Link.A)})
        ]
    }
    
    func onStop() {
        print("onStop")
    }
    
    func onError(error: Error) {
    }
    
    deinit {
        print("Sample2 action deinit")
    }
    
    
    init(startButton: UIButton) {
        self.startButton = startButton
    }
}
