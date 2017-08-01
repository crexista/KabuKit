import Foundation


fileprivate var rewindByScene: [ScreenHashWrapper : () -> Void] = [ScreenHashWrapper : () -> Void]()

public protocol Screen : class {
    
    /**
     リンク先に遷移する
     
     - Attention:
     指定リンク先がなにであるかはScenario側で指定しておく必要がある
     
     それを忘れるとこのメソッドを呼んでもなにも起きない  

     
     - Parameters:
       - request: 遷移先へのリンク
     */
    func sendTransitionRequest<ContextType>(_ request: TransitionRequest<ContextType>, _ completion: @escaping (Bool) -> Void) -> Void
    
    
    func sendTransitionRequest<ContextType>(_ request: TransitionRequest<ContextType>) -> Void
    
    /**
     現在表示されているSceneを終了させ、前のSceneに戻る
     
     - Attention :
     ただし、前のシーンがない場合は戻らず、何も起きない
     */
    func leaveFromSequence() -> Void

    func leaveFromSequence(_ runTransition: Bool) -> Void

    func leaveFromSequence(_ completion: @escaping (Bool) -> Void) -> Void

    func leaveFromSequence(_ runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void
}

extension Screen {

    
    internal var TransitionProcedure: TransitionProcedure? {
        return procedureByScene[ScreenHashWrapper(self)]
    }
    
    internal var scenario: TransitionProcedure? {
        return procedureByScene[ScreenHashWrapper(self)]
    }
    
    internal var rewind: (() -> Void)? {
        return rewindByScene[ScreenHashWrapper(self)]
    }
    
    internal func registerScenario(scenario: TransitionProcedure?) {
        procedureByScene[ScreenHashWrapper(self)] = scenario
    }
    
    internal func registerRewind(f: @escaping () -> Void) {
        rewindByScene[ScreenHashWrapper(self)] = f
    }
    
    public func leaveFromSequence() -> Void {
        self.leaveFromSequence(true)
    }

    public func leaveFromSequence(_ runTransition: Bool) -> Void {
        self.leaveFromSequence(runTransition, { (Bool) in })
    }

    public func leaveFromSequence(_ completion: @escaping (Bool) -> Void) -> Void {
        self.leaveFromSequence(true, completion)
    }

    public func leaveFromSequence(_ runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void {

        if let method = rewind {
            if (runTransition) {
                method()
            }
            rewindByScene.removeValue(forKey: ScreenHashWrapper(self))
            completion(true)
            return
        }
        
        completion(false)
    }

    public func sendTransitionRequest<ContextType>(_ request: TransitionRequest<ContextType>) -> Void {
        self.sendTransitionRequest(request, {(Bool) in })
    }
    
    
    public func sendTransitionRequest<ContextType>(_ request: TransitionRequest<ContextType>, _ completion: @escaping (Bool) -> Void) -> Void {
        self.scenario?.start(from: self, at: request, completion)
    }

}


