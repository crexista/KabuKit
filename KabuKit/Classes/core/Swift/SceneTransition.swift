//
//  SceneTransition.swift
//  KabuKit
//
//  Created by crexista on 2016/11/15.
//  Copyright © crexista. All rights reserved.
//

import Foundation

public protocol SceneTransition {
    
    associatedtype StageType: AnyObject
    
    func request(context: SceneContext<StageType>) -> SceneRequest?
}
