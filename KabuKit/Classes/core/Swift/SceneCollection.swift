import Foundation

class SceneCollection<Stage> {
    
    private let operation: SceneOperation<Stage>
    
    let stage: Stage
    
    var screens: [Screen] = [Screen]()
    
    var currentTopScreen: Screen? {
        return screens.last
    }
    
    
    /**
     新しいSceneをCollectionに追加します
     追加される新しいSceneに紐づくScenarioがGuideによって設定されている場合
     新しいSceneにScenarioを登録します。
     
     設定されていない場合は登録しません
     
     - Parameters:
       - newScene: 新しいScene
       - context: 新しいSceneを起動する際に必要になるcontext
       - callback:
       - transition: 画面遷移ロジック
     */
    func stack<SceneType: Scene>(_ newScene: SceneType,
             with context: SceneType.Context,
             transition: (Stage, SceneType, Screen?) -> (() -> Void)?,
             callbackOf onPop: ((SceneType.ReturnValue?) -> Void)?) {
        
        
        let scenario = operation.resolve(from: newScene)
        newScene.registerContext(context)
        screens.last?.behavior?.isSuspended = true
        newScene.registerBehavior(behavior: ScreenBehavior())

        if let rewind = transition(stage, newScene, screens.last) {
            newScene.registerRewind { [weak self](returnValue) in
                rewind()
            }
        }
        
        newScene.behavior?.isStarted = true
        newScene.registerScenario(scenario: scenario)
        newScene.registerOnLeave { [weak self](returnValue) in
            onPop?(returnValue)
            _ = self?.screens.popLast()
        }
        screens.append(newScene)
    }
    
    init<GuideType: SequenceGuide>(stage:Stage, guide: GuideType) where GuideType.Stage == Stage {
        self.stage = stage
        self.operation = SceneOperation(stage: stage, queue: guide.transitioningQueue)
        self.operation.setup(collection: self)
        guide.start(with: operation)
        
    }
    
}
