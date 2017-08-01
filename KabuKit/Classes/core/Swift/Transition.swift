import Foundation

class Transition<CurrentScreenType: Screen> {

    private weak var scenario: TransitionProcedure?
    
    var rewindFunc: (() -> Void)?
    
    let sceneTransitioning: (CurrentScreenType, Any, Any?) -> Void
    
    func back() {
        rewindFunc?()
    }

    /*+
     画面遷移をスタートさせます
    
     - Parameters:
       - from: from
       - stage: stage
       - context: context
    */
    func start(from: CurrentScreenType, stage: Any, context: Any?) {
        sceneTransitioning(from, stage, context)
    }
    
    init<SceneType: Scene>(to: @escaping () -> SceneType,
                           container: SceneContainer,
                           with transitioning: @escaping (CurrentScreenType, SceneType, Any) -> () -> Void) {
        
        sceneTransitioning = { (from: CurrentScreenType, stage: Any, context: Any?) in
            let scene = to()
            scene.registerContext(context)
            container.add(screen: scene) {
                let f = transitioning(from, scene, stage)
                scene.registerRewind(f: f)
            }
        }

    }
}
