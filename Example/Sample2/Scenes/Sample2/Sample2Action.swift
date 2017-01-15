//
//  Sample2Action.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample2Action: Action {
    
    typealias SceneType = Sample2ViewController
    
    unowned let startButton: UIButton

    func invoke(director: Director<Sample2ViewController.Sample2Destination>) -> [ActionEvent] {
        return [startButton.rx.tap.do(onNext: {() in director.report(event: "start")}).toEvent]
    }


    func onStop() {
        print("onStop")
    }
    
    func onError(error: Error, label: String?) -> RecoverPattern {
        return RecoverPattern.doNothing
    }
    
    deinit {
        print("Sample2 action deinit")
    }
    
    
    init(startButton: UIButton) {
        self.startButton = startButton
    }
}
