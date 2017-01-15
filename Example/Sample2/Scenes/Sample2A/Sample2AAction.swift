//
//  Sample2AAction.swift
//  Example
//
//  Created by crexista on 2016/11/26.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxCocoa
import RxSwift

class Sample2AAction : Action {
    
    //typealias SceneType = Sample2AViewController
    typealias SceneType = Sample2AViewController
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton
  
    func invoke(director: Director<Sample2AViewController.Sample2Destination>) -> [ActionEvent] {


        return [
            nextButtonA.rx.tap.do(onNext: { () in director.forwardTo(Sample2AViewController.Sample2Destination.aScene) }).toEvent,
            nextButtonB.rx.tap.do(onNext: { () in director.forwardTo(Sample2AViewController.Sample2Destination.bScene) }).toEvent,
            prevButton.rx.tap.do(onNext: { () in _ = director.back()}).toEvent
        ]
    }

    func onStop() {

    }
    
    func onError(error: Error, label: String?) -> RecoverPattern {
        return RecoverPattern.doNothing
    }
    

    deinit {
        print("Sample2A action deinit")
    }

    
    init (nextButtonA: UIButton, nextButtonB: UIButton, prevButton: UIButton) {
        self.nextButtonA = nextButtonA
        self.nextButtonB = nextButtonB
        self.prevButton = prevButton
    }
}
