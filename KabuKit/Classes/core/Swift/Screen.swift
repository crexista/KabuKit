import Foundation


public protocol Screen : class {
    
    /**
     リンク先に遷移する
     
     - Attention:
     指定リンク先がなにであるかはScenario側で指定しておく必要がある
     
     それを忘れるとこのメソッドを呼んでもなにも起きない  

     
     - Parameters:
       - request: 遷移先へのリンク
     */
    func send<ContextType>(_ request: Request<ContextType>, _ completion: @escaping (Bool) -> Void) -> Void
    
    
    func send<ContextType>(_ request: Request<ContextType>) -> Void
    
    /**
     現在表示されているSceneを終了させ、前のSceneに戻る
     
     - Attention :
     ただし、前のシーンがない場合は戻らず、何も起きない
     */
    func leave() -> Void

    func leave(_ runTransition: Bool) -> Void

    func leave(_ completion: @escaping (Bool) -> Void) -> Void

    func leave(_ runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void
}

extension Screen {

    
    internal var TransitionProcedure: TransitionProcedure? {
        return procedureByScene[ScreenHashWrapper(self)]
    }
    
    public func leave() -> Void {
        self.leave(true)
    }

    public func leave(_ runTransition: Bool) -> Void {
        self.leave(runTransition, { (Bool) in })
    }

    public func leave(_ completion: @escaping (Bool) -> Void) -> Void {
        self.leave(true, completion)
    }

    public func leave(_ runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void {
        self.TransitionProcedure?.back(runTransition, completion)
    }

    public func send<ContextType>(_ request: Request<ContextType>) -> Void {
        self.send(request, {(Bool) in })
    }
    
    
    public func send<ContextType>(_ request: Request<ContextType>, _ completion: @escaping (Bool) -> Void) -> Void {
        TransitionProcedure?.start(at: request, completion)
    }

}


