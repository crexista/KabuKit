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

final class Sample1BAction: Action {

    typealias SceneType = Sample1BViewController
    
    unowned let label: UILabel
    
    unowned let nextButtonA: UIButton
    
    unowned let nextButtonB: UIButton
    
    unowned let prevButton: UIButton

    
    public func invoke(director: Director<Sample1BViewController.Sample2Destination>) -> [ActionEvent] {
        return [
            self.nextButtonA.rx.tap.do(onNext: { () in director.forwardTo(Sample1BViewController.Sample2Destination.a)}).toTarget,
            self.nextButtonB.rx.tap.do(onNext: { () in director.forwardTo(Sample1BViewController.Sample2Destination.b)}).toTarget,
            self.prevButton.rx.tap.do(onNext: { () in director.back()}).toTarget
        ]
    }
    
    /**
     このActionのInvoke内で起動させたSignalの中で一つでもキャッチし損ねたエラーが発生したらこのメソッドが呼ばれます.
     
     - parameters:
       - error: キャッチし損ねたエラーのクラスです.
       - label: エラーを起こしたシグナルの名前です.
                設定している場合のみ取得できます. 設定していない場合は取得できません.
     */
    public func onError(error: Error, label: String?) -> RecoverPattern {
        return RecoverPattern.doNothing
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

