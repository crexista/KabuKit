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
    

    
    func start(director: SceneDirector<Sample2BViewController.Sample2Link>?, context: Bool?) -> [Observable<()>] {
        prevButton.isEnabled = context!
        return [
            nextButtonA.rx.tap.do(onNext: { () in director?.changeScene(transition: Sample2BViewController.Sample2Link.A)}),
            nextButtonB.rx.tap.do(onNext: { () in director?.changeScene(transition: Sample2BViewController.Sample2Link.B)}),
            prevButton.rx.tap.do(onNext: { () in _ = director?.exitScene()})
        ]
    }
    
    func onStop() {

    }
    
    func onError(error: Error) {

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
