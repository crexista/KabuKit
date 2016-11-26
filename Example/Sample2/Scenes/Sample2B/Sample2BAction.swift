//
//  Sample2BAction.swift
//  Example
//
//  Created by crexista on 2016/11/26.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample2BAction : Action {
    
    typealias contextType = Bool
    typealias linkType = Sample2BViewController.Sample2Link
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton

    
    func start(transition: SceneTransition<Sample2BViewController.Sample2Link>, context: Bool?) -> [Observable<()>] {
        prevButton.isEnabled = context!
        return [
            nextButtonA.rx.tap.do(onNext: { () in transition.transitTo(link: Sample2BViewController.Sample2Link.A)}),
            nextButtonB.rx.tap.do(onNext: { () in transition.transitTo(link: Sample2BViewController.Sample2Link.B)}),
            prevButton.rx.tap.do(onNext: { () in transition.back()})
        ]
    }
    
    func onStop() {

    }
    
    func onError(error: Error) {

    }
    
    init (nextButtonA: UIButton, nextButtonB: UIButton, prevButton: UIButton) {
        self.nextButtonA = nextButtonA
        self.nextButtonB = nextButtonB
        self.prevButton = prevButton
    }
}
