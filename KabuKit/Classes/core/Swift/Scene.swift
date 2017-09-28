import Foundation

fileprivate var contextByScreen = [ScreenHashWrapper : Any]()
fileprivate var rewindByScene: [ScreenHashWrapper : Any] = [ScreenHashWrapper : Any]()
fileprivate var onLeaveByScene: [ScreenHashWrapper : Any] = [ScreenHashWrapper : Any]()


public protocol Scene : class, Screen {
    
    associatedtype Context
    
    associatedtype ReturnValue = Void

}

public extension Scene {
    
    typealias Rewind = ((ReturnValue) -> Void)
    
    internal var scenario: TransitionProcedure? {
        return procedureByScene[ScreenHashWrapper(self)]
    }

    internal var rewind: Rewind? {
        return rewindByScene[ScreenHashWrapper(self)] as? Rewind
    }

    public var context: Context {
        return contextByScreen[ScreenHashWrapper(self)] as! Self.Context
    }
    
    var onLeave: ((ReturnValue) -> Void)? {
        return onLeaveByScene[ScreenHashWrapper(self)] as? Rewind
    }
    
    internal func registerContext(_ value: Any?) {
        contextByScreen[ScreenHashWrapper(self)] = value as? Self.Context
    }
    
    internal func registerRewind(f: @escaping (ReturnValue) -> Void) {
        rewindByScene[ScreenHashWrapper(self)] = f
    }
    
    internal func registerScenario(scenario: TransitionProcedure?) {
        procedureByScene[ScreenHashWrapper(self)] = scenario
    }
    
    internal func registerOnLeave(f: @escaping (ReturnValue) -> Void) {
        onLeaveByScene[ScreenHashWrapper(self)] = f
    }
    
    public func sendTransitionRequest<ContextType, ExpectedReturnType>(_ request: TransitionRequest<ContextType, ExpectedReturnType>) -> Void {
        self.sendTransitionRequest(request, {(Bool) in })
    }
    
    public func sendTransitionRequest<ContextType, ExpectedReturnType>(_ request: TransitionRequest<ContextType, ExpectedReturnType>, _ completion: @escaping (Bool) -> Void) -> Void {
        self.scenario?.start(atRequestOf: request, completion)
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue) {
        self.leaveFromCurrent(returnValue: returnValue, runTransition: true)
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue, runTransition: Bool) {
        self.leaveFromCurrent(returnValue: returnValue, runTransition: runTransition, { (Bool) in })
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue, runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void {
        guard let rewindMethod = rewind else {
            completion(false)
            return
        }

        if (runTransition) {
            rewindMethod(returnValue)
        }
        onLeave?(returnValue)
        onLeaveByScene.removeValue(forKey: ScreenHashWrapper(self))
        rewindByScene.removeValue(forKey: ScreenHashWrapper(self))
        completion(true)
    }
}


public extension Scene where Self.ReturnValue == Void {
    
    public func leaveFromCurrent() {
        leaveFromCurrent(returnValue: ())
    }
    
    public func leaveFromCurrent(runTransition: Bool) {
        leaveFromCurrent(returnValue: (), runTransition: runTransition)
    }
    
    public func leaveFromCurrent(completion: @escaping (Bool) -> Void) -> Void {
        leaveFromCurrent(returnValue: (), runTransition: true, completion)
    }
    
    public func leaveFromCurrent(runTransition: Bool, completion: @escaping (Bool) -> Void) -> Void {
        leaveFromCurrent(returnValue: (), runTransition: runTransition, completion)
    }
}
