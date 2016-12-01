//
//  SceneGenerator.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © crexista. All rights reserved.
//

import Foundation

public protocol SceneGenerator {
    
    associatedtype argType
    
    associatedtype implType
    
    var argument: argType? { get }
    
    func generater(impl: implType.Type, argument: argType?) -> implType
    
}
