//
//  XIBFile.swift
//  KabuKit
//
//  Created by crexista on 2016/11/23.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public struct ViewControllerXIBFile : SceneGenerator {
    
    public typealias implType =  UIViewController
    public typealias argType = (String?, Bundle?)
    
    public let argument: argType?
    
    public func generater(impl: implType.Type, argument: argType?) -> implType {
        return impl.init(nibName: argument!.0, bundle: argument!.1)
    }
    
    public init (_ fileName: String?, _ bundle: Bundle?) {
        self.argument = (fileName, bundle)
    }
}


