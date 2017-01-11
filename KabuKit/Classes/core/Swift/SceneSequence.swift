//
//  Copyright © 2017 crexista
//

import Foundation

public class SceneSequence<StageType: AnyObject> {
    
    typealias InvokeMethodType = (_ stage: StageType, _ scene: SceneBase) -> Void
    
    internal let manager: SceneManager
    
    private let stage: StageType
    
    private let baseScene: SceneBase
    
    private let baseSceneArgs: Any?
    
    private var producer: Producer? = nil
    
    private let invokeMethod: InvokeMethodType
    
    public private(set) var isStarted: Bool = false
    
    public func currentScene<S: Scene>() -> S? {
        return manager.currentScene()
    }
    
    /**
     指定のSceneを有効化させます
     
     */
    private func activateScene(_ stage: StageType, _ scene: SceneBase, _ args: Any?, _ onActivate: InvokeMethodType) {
        scene.setup(sequenceObject: self, argumentObject: args)
        onActivate(stage, scene)
    }
    
    internal func start(producer: Producer?) {
        self.producer = producer
        activateScene(stage, baseScene, baseSceneArgs, invokeMethod)
        isStarted = true
    }
    
    
    internal func raiseEvent<E>(event: E) {
        producer?.scenario?.handleEvent(sequence: self, event: event, producer: producer)
    }

    
    /**
     追加したシーンのセットアップを行い、その後
     onPushを呼びシーンを追加する際の関数を呼び出します。
     
     このメソッドを呼ぶ前にSceneを呼ぶとdirectorはnil
     
     */
    public func push(transition: Transition<StageType>) {
        activateScene(stage, transition.scene, transition.args, transition.execution)
    }
    
    
    /**
     指定されたSceneをSequenceから外します
     
     - attention: 以下の場合はSequenceからSceneを外せず、falseを返します
       - 指定したSceneがこのsequenceのcurrentSceneではない場合
       - このSequeceに乗っているSceneが1つだけの場合
       - 指定したSceneがそもそもこのSequeceに乗っかっていない場合
       - 外そうとはしたがScene側の方の理由で削除できない場合

     - parameters:
       - scene: Sequenceから外される予定のScene
     - returns: 成功した時はtrueを返します
     */
    public func release<S: Scene>(scene: S) -> Bool where S.RouterType.DestinationType.StageType == StageType {
        guard manager.count > 1 else {
            return false
        }

        guard manager.isCurrentScene(scene: scene) else {
            return false
        }
        
        guard scene.isRemovable else {
            return false
        }
        scene.onRemove(stage: stage)
        manager.release(scene: scene)
        return true
    }
    
    deinit {
        self.manager.dispose()
        isStarted = false
    }
    
    public init<S: Scene>(_ stage: StageType, _ scene: S, _ argument:S.ArgumentType?, _ onAdd: @escaping (StageType, S) -> Void) where StageType == S.RouterType.DestinationType.StageType {
        self.manager = SceneManager()
        self.stage = stage
        self.baseScene = scene
        self.baseSceneArgs = argument
        
        self.invokeMethod = { (_ stage: StageType, _ target: SceneBase) in
            guard let newScene = target as? S else { return }
            onAdd(stage, newScene)
        }
    }
}
