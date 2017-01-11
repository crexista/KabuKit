//
//  Sample1BAction.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit
import RxSwift
import RxCocoa

class Sample1BAction: Action {

    typealias DestinationType = Sample1BViewController.Sample2Destination
    
    unowned let label: UILabel
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton

    public func invoke(director: Director<Sample1BViewController.Sample2Destination>) -> [ObserverTarget] {
        return [
            self.nextButtonA.rx.tap.do(onNext: { () in director.transitTo(Sample1BViewController.Sample2Destination.a)}).toTarget,
            self.nextButtonB.rx.tap.do(onNext: { () in director.transitTo(Sample1BViewController.Sample2Destination.b)}).toTarget,
            self.prevButton.rx.tap.do(onNext: { () in director.back()}).toTarget
        ]
    }
    
    public func onError(error: Error, label: String?) -> ActionRecoverPattern {
        return ActionRecoverPattern.doNothing
    }
    
    public func onStop() {

    }
    
    init(label: UILabel, buttonA: UIButton, buttonB: UIButton, prevButton: UIButton) {
        self.label = label
        self.nextButtonA = buttonA
        self.nextButtonB = buttonB
        self.prevButton = prevButton
    }
}

