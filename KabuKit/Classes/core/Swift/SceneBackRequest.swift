//
//  SceneBackRequest.swift
//  KabuKit
//
//  Created by crexista on 2016/11/28.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol SceneBackRequest {    
    func execute() -> Bool
}


struct SceneBackRequestImpl<StageType: AnyObject> : SceneBackRequest {
    
    let method: (StageType) -> Bool
    
    let stage: StageType
    
    public func execute() -> Bool {
        return method(stage)
    }
    
    init(stage: StageType, f: @escaping (StageType) -> Bool) {
        self.stage = stage
        self.method = f
    }
}
