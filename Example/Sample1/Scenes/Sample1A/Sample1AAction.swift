//
//  Sample1AAction.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

/*
class Sample1AAction: Action {
    
    unowned let label: UILabel
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton
    
    typealias SceneType = Sample1AViewController
    
    func start(director: SceneDirector<Sample1AViewController.Sample1Link>?, argument: Bool?) -> [Observable<()>] {
        return [
            self.nextButtonA.rx.tap.do(onNext: { () in director?.changeScene(transition: Sample1AViewController.Sample1Link.A)}),
            self.nextButtonB.rx.tap.do(onNext: { () in director?.changeScene(transition: Sample1AViewController.Sample1Link.B)}),
            self.prevButton.rx.tap.do(onNext: { () in _ = director?.exitScene()})
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
 */
