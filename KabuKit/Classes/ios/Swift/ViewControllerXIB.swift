//
//  Copyright © 2017年 crexista
//

import Foundation

public struct ViewControllerXIB<SceneType: Scene>: SceneGenerator {

    private let sceneClass: SceneType.Type
    
    private let nibName: String?
    
    private let bundle: Bundle?
    
    public func generate() -> SceneType? {
        let vcClass = sceneClass as? UIViewController.Type
        let scene = vcClass?.init(nibName: self.nibName, bundle: self.bundle)
        
        return scene as? SceneType
    }
    
    init(sceneClass: SceneType.Type, nibName: String?, bundle: Bundle?) {

        self.sceneClass = sceneClass
        self.nibName = nibName
        self.bundle = bundle
    }
}
