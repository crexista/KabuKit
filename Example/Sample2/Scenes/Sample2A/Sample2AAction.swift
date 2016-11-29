//
//  Sample2AAction.swift
//  Example
//
//  Created by crexista on 2016/11/26.
//  Copyright © 2016年 crexista. All rights reserved.
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
  
    func start(director: SceneDirector<Sample2AViewController.Sample2Link>, argument: Bool?) -> [Observable<()>] {
        prevButton.isEnabled = argument!
        return [
            nextButtonA.rx.tap.do(onNext: { () in director.transitTo(link: Sample2AViewController.Sample2Link.A)}),
            nextButtonB.rx.tap.do(onNext: { () in director.transitTo(link: Sample2AViewController.Sample2Link.B)}),
            prevButton.rx.tap.do(onNext: { () in _ = director.exit()})
        ]
    }

    func onStop() {

    }
    
    func onError(error: Error) {

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
