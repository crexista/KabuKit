//
//  SceneBackRequestFactory.swift
//  KabuKit
//
//  Created by crexista on 2016/11/28.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class SceneBackRequestFactory<StageType: AnyObject> {
    
    private let stage: StageType
    
    public func createBackRequest(_ setup: @escaping (StageType) -> Bool) -> SceneBackRequest {
        return SceneBackRequestImpl<StageType>(stage: stage, f: setup)
    }
    
    init(stage: StageType) {
        self.stage = stage
    }
}
