//
//  Action.swift
//  KabuKit
//
//  Created by crexista on 2016/11/10.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import RxSwift

public protocol Action : class, OnStop, OnError {
    
    associatedtype SceneType: Scene
    
    func start(transition: SceneTransition<SceneType.LinkType>, context: SceneType.ContextType?)->[Observable<()>]
}

public protocol OnStop {
    func onStop()
}

public protocol OnError {
    func onError(error: Error)
}
