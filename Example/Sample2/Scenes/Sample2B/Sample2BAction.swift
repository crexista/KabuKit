//
//  Sample2BAction.swift
//  Example
//
//  Created by crexista on 2016/11/26.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample2BAction : Action {
    
    typealias SceneType = Sample2BViewController
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton
    
    func invoke(director: Director<Sample2BViewController.SampleBDestination>) -> [ActionEvent] {
        return [
            nextButtonA.rx.tap.do(onNext: { () in director.forwardTo(Sample2BViewController.SampleBDestination.a) }).toEvent,
            nextButtonB.rx.tap.do(onNext: { () in director.forwardTo(Sample2BViewController.SampleBDestination.b) }).toEvent,
            prevButton.rx.tap.do(onNext: { () in _ = director.back()}).toEvent
        ]
    }
    
    func onStop() {

    }

    func onError(error: Error, label: String?) -> RecoverPattern {
        return RecoverPattern.doNothing
    }
    
    deinit {
        print("Sample2B action deinit")
    }

    
    init (nextButtonA: UIButton, nextButtonB: UIButton, prevButton: UIButton) {
        self.nextButtonA = nextButtonA
        self.nextButtonB = nextButtonB
        self.prevButton = prevButton
    }
}
