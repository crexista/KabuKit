//
//  MockStage.swift
//  KabuKit
//
//  Created by crexista on 2017/06/13.
//  Copyright © 2017年 crexi. All rights reserved.
//

import Foundation
import KabuKit

class MockStage {
    
    var page: Screen?
    
    func setScene<S: Scene>(scene: S) {
        page = scene
    }
}
