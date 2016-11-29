//
//  Transition.swift
//  KabuKit
//
//  Created by crexista on 2016/11/15.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol SceneTransition {
    
    associatedtype StageType: AnyObject
    
    func request(factory: SceneChangeRequestFactory<StageType>) -> SceneChangeRequest?
}
