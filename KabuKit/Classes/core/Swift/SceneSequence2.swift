//
//  Copyright © 2017年 crexista
//

import Foundation

public class SceneSequence2<StageType: AnyObject> {
    
    internal let manager: SceneManager2
    
    private let stage: StageType
    
    private var startFunc: () -> Void = {}
    
    private var producer: Producer? = nil
    
    public private(set) var isStarted: Bool = false
    
    
    public func currentScene<S: Scene2>() -> S? {
        return manager.currentScene()
    }
    
    
    /**
     追加したシーンのセットアップを行い、その後
     onPushを呼びシーンを追加する際の関数を呼び出します。
     
     このメソッドを呼ぶ前にSceneを呼ぶとdirectorはnil
     
     */
    public func push(transition: Transition<StageType>) {
        transition.setupScene(sequence: self)
        transition.onTransition(stage: stage)
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
    public func release<S: Scene2>(scene: S) -> Bool where S.RouterType.DestinationType.StageType == StageType {
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
    
    internal func start(producer: Producer?) {
        self.producer = producer
        self.startFunc()
        self.startFunc = {}
        isStarted = true
    }
    
    private func end() {
        self.startFunc = {}
        self.manager.dispose()
        isStarted = false
    }
    
    internal func raiseEvent<E>(event: E) {
        producer?.scenario?.handleEvent(sequence: self, event: event, producer: producer)
    }
    
    deinit {
        end()
    }
    
    init<S: Scene2>(stage: StageType, scene: S, argument:S.ArgumentType?, _ onAdd: @escaping (StageType, S) -> Void) where StageType == S.RouterType.DestinationType.StageType {
        self.manager = SceneManager2()
        self.stage = stage
        self.startFunc = { () -> Void in
            scene.setup(sequence: self, arguments: argument)
            onAdd(stage, scene)
        }
        
    }
}
