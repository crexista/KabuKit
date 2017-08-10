import Foundation

class Transition<CurrentScreenType: Screen> {

    typealias TransitioningParameter = (from: CurrentScreenType, stage: Any, context: Any?, callback: (Any) -> Void)
    
    private weak var scenario: TransitionProcedure?
    
    var rewindFunc: (() -> Void)?
    
    let sceneTransitioning: (TransitioningParameter) -> Void
    
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
    func start<C, E>(from: CurrentScreenType, on stage: Any, with request: TransitionRequest<C, E>) {
        let f = { (hoge: Any) in            
            request.callback(hoge as! E)
        }
        sceneTransitioning((from, stage, request.context, f))
    }
    
    init<SceneType: Scene>(to: @escaping () -> SceneType,
                           iterator: SceneIterator,
                           with transitioning: @escaping (CurrentScreenType, SceneType, Any) -> () -> Void) {
        
        sceneTransitioning = { (param: TransitioningParameter) in
            let scene = to()
            scene.registerContext(param.context)
            iterator.add(screen: scene) {
                let rollback = transitioning(param.from, scene, param.stage)
                let rewind = { (result: Any) in
                    param.callback(result)
                    rollback()
                    iterator.remove(screen: scene)
                }

                scene.registerRewind(f: rewind)
            }
        }

    }
}
