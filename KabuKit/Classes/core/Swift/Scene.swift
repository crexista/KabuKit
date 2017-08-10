import Foundation

internal var contextByScreen = [ScreenHashWrapper : Any]()
internal var rewindByScene: [ScreenHashWrapper : Any] = [ScreenHashWrapper : Any]()


public protocol Scene : class, Screen {
    
    associatedtype Context
    
    associatedtype ReturnValue = Void

}

public extension Scene {
    
    internal var scenario: TransitionProcedure? {
        return procedureByScene[ScreenHashWrapper(self)]
    }

    internal var rewind: ((ReturnValue?) -> Void)? {
        return rewindByScene[ScreenHashWrapper(self)] as? (ReturnValue?) -> Void
    }

    public var context: Context {
        return contextByScreen[ScreenHashWrapper(self)] as! Self.Context
    }
    
    internal func registerContext(_ value: Any?) {
        contextByScreen[ScreenHashWrapper(self)] = value as? Self.Context
    }
    
    internal func registerRewind(f: @escaping (ReturnValue?) -> Void) {
        rewindByScene[ScreenHashWrapper(self)] = f
    }
    
    internal func registerScenario(scenario: TransitionProcedure?) {
        procedureByScene[ScreenHashWrapper(self)] = scenario
    }
    
    
    public func sendTransitionRequest<ContextType, ExpectedReturnType>(_ request: TransitionRequest<ContextType, ExpectedReturnType>) -> Void {
        self.sendTransitionRequest(request, {(Bool) in })
    }
    
    public func sendTransitionRequest<ContextType, ExpectedReturnType>(_ request: TransitionRequest<ContextType, ExpectedReturnType>, _ completion: @escaping (Bool) -> Void) -> Void {
        self.scenario?.start(from: self, at: request, completion)
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue?) {
        self.leaveFromCurrent(returnValue: returnValue, runTransition: true)
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue?, runTransition: Bool) {
        self.leaveFromCurrent(returnValue: returnValue, runTransition: runTransition, { (Bool) in })
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue?, runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void {
        if let method = rewind {
            if (runTransition) {
                method(returnValue)
            }
            rewindByScene.removeValue(forKey: ScreenHashWrapper(self))
            completion(true)
            return
        }
        completion(false)
    }
}


public extension Scene where Self.ReturnValue == Void {
    
    public func leaveFromCurrent() {
        leaveFromCurrent(returnValue: ())
    }
    
    public func leaveFromCurrnt(runTransition: Bool) {
        leaveFromCurrent(returnValue: (), runTransition: runTransition)
    }
    
    public func leaveFromCurrent(completion: @escaping (Bool) -> Void) -> Void {
        leaveFromCurrent(returnValue: (), runTransition: true, completion)
    }
    
    public func leaveFromCurrnt(runTransition: Bool, completion: @escaping (Bool) -> Void) -> Void {
        leaveFromCurrent(returnValue: (), runTransition: runTransition, completion)
    }
}
