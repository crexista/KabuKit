//
//  Copyright © 2017年 crexista
//

import Foundation

public protocol SceneGenerator2 {
    
    associatedtype SceneType: Scene
    
    /**
     Sceneを生成する
     
     */
    func generate() -> SceneType
}
