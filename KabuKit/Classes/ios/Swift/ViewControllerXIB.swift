//
//  Copyright © 2017年 crexista
//

import Foundation

public struct ViewControllerXIB<SceneType: Scene>: SceneGenerator2 {

    private let sceneClass: SceneType.Type
    
    private let nibName: String?
    
    private let bundle: Bundle?
    
    public func generate() -> SceneType {
        guard let vcClass = sceneClass as? UIViewController.Type else {
            assert(false, "")
        }
        guard let scene = vcClass.init(nibName: self.nibName, bundle: self.bundle) as? SceneType else {
            assert(false, "")
        }
        return scene
    }
    
    init(sceneClass: SceneType.Type, nibName: String?, bundle: Bundle?) {

        self.sceneClass = sceneClass
        self.nibName = nibName
        self.bundle = bundle
    }
}
