//
//  Copyright © 2017年 crexista
//

import Foundation

/**
 Sceneを生成するクラスのprotocolです。
 Sceneを生成させるものはこのプロトコルに従って実装します
 
 */
public protocol SceneGenerator {
    
    associatedtype SceneType: Scene
    
    /**
     Sceneを生成する
     
     */
    func generate() -> SceneType?
}
