//
//  Sample1BAction.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample1BAction: Action {
    
    typealias SceneType = Sample1BViewController
    
    unowned let label: UILabel
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton
    
    func start(transition: SceneTransition<Sample1BViewController.Sample1BLink>, context: ()?) -> [Observable<()>] {        
        return [
            self.nextButtonA.rx.tap.do(onNext: { () in transition.transitTo(link: Sample1BViewController.Sample1BLink.A)}),
            self.nextButtonB.rx.tap.do(onNext: { () in transition.transitTo(link: Sample1BViewController.Sample1BLink.B)}),
            self.prevButton.rx.tap.do(onNext: { () in transition.back()})
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
    
    
    init(label: UILabel, buttonA: UIButton, buttonB: UIButton, prevButton: UIButton) {
        self.label = label
        self.nextButtonA = buttonA
        self.nextButtonB = buttonB
        self.prevButton = prevButton
    }
}
