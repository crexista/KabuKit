import Foundation


/**
 特定の`Scene`を表示している最中Requestがきたらどの画面にどのように遷移するか、
 そしてどのように画面を戻るか、を規定したクラス
 
 一つのSceneごとにつくられる
 
 */
public class Scenario<From: Screen, Stage> : TransitionProcedure {
    

    public typealias Rewind = () -> Void
    
    typealias Transition = (Any, Stage, From, SceneOperation<Stage>) -> Void
    
    private let transitionQueue: DispatchQueue
    
    /**
     TransitionRequestのクラス名をKeyとしてValueに遷移時の関数が入る
     遷移時の関数はsceneとcontext
     
     */
    fileprivate var transitionStore = [String: Transition]()
    
    fileprivate var stage: Stage
    fileprivate weak var sceneCollection: SceneCollection<Stage>?
    
    var operation: SceneOperation<Stage>?
    
    
    init(_ stage: Stage, _ collection: SceneCollection<Stage>?, _ operation: SceneOperation<Stage>, _ queue: DispatchQueue) {
        self.sceneCollection = collection
        self.transitionQueue = queue
        self.stage = stage
        self.operation = operation
    }
    
    func start<ContextType, ExpectedResult, ScreenType: Screen>(atRequestOf request: TransitionRequest<ContextType, ExpectedResult>,
                                                                from screen: ScreenType,
                                                                _ completion: @escaping (Bool) -> Void) -> Void {
        guard let from = screen as? From else { return }
        self.doStart(atRequestOf: request, from: from, completion)
    }

    /**
     このScenarioを受け取ったリクエストに応じてスタートさせる
     transitionが成功すればこのScenarioが参照しているSceneCollectionに新しいSceneが追加され、completionの実行の際にtrueがわたされる
     
     一方、存在しないリクエストを受けtransitionが実行できなかった場合completionの実行の際にfalseが渡され、
     Sceneのコンテナに新しいSceneが追加されることもない
    
     - Parameters:
       - request: transitionの契機となるrequest
       - completion: requestの実行結果。transitionが実行されなかった場合、引数がfalseで渡って来ます
     */
    func doStart<ContextType, ExpectedResult>(atRequestOf request: TransitionRequest<ContextType, ExpectedResult>,
                                              from screen: From,
                                              _ completion: @escaping (Bool) -> Void) {
        transitionQueue.async {
            guard let transition = self.transitionStore[String(describing: request)] else {
                completion(false)
                return
            }
            // 新しいSceneを作り、そのSceneから戻り遷移(rewind)をそのSceneに追加する
            // そのあと、Sequenceに登録する。
            // 登録の際、そのSceneにあうシナリオを選別して登録する
            transition(request, self.stage, screen, self.operation!)
            completion(true)
        }
    }

}


public extension Scenario where From : Scene {
    
    public typealias Args<NextSceneType: Scene> = (stage: Stage, next: NextSceneType, from: From)
    
    /**
     TransitionRequestをKeyとしてValueに遷移時の関数が入る
     遷移時の関数はsceneとcontext
     
     */
    public func given<NextSceneType: Scene>(_ request: TransitionRequest<NextSceneType.Context, NextSceneType.ReturnValue>.Type,
                                            nextTo next: @escaping () -> NextSceneType,
                                            with transition: @escaping (Args<NextSceneType>) -> Rewind) -> Void {

        transitionStore[String(reflecting: request)] = { (transitionRequest: Any, stage: Stage, screen: From, operation: SceneOperation<Stage>) in
            guard let request = transitionRequest as? TransitionRequest<NextSceneType.Context, NextSceneType.ReturnValue> else { return }
            let nextScene = next()
            screen.nextScreen = nextScene
            nextScene.context = request.context
            nextScene.returnCallback = request.callback
            nextScene.rewind = Rollback(backTransition:transition((stage: stage, next: nextScene, from: screen)), previousScreen:screen)
            nextScene.registerScenario(scenario: self.operation?.resolve(from: nextScene))
        }
    }
}

