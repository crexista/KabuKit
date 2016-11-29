//
//  Scenario.swift
//  KabuKit
//
//  Created by crexista on 2016/11/11.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Scenario : class {
    
    func onEvent<StageType: AnyObject, EventType>(currentStage: StageType,
                                                  currentSequence: SceneSequence<StageType>,
                                                  currentScene: Frame,
                                                  event: EventType)
}
