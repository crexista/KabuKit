import Foundation

fileprivate var contextByScreen = [ScreenHashWrapper : Any]()
fileprivate var returnCallbacks: [ScreenHashWrapper : Any] = [ScreenHashWrapper : Any]()
fileprivate var onLeaveByScene: [ScreenHashWrapper : Any] = [ScreenHashWrapper : Any]()


public protocol Scene : Screen {
    
    associatedtype Context
    
    associatedtype ReturnValue = Void

}

public extension Scene {
    
    typealias Return = ((ReturnValue) -> Void)
    
    internal var scenario: TransitionProcedure? {
        return procedureByScene[ScreenHashWrapper(self)]
    }

    internal var returnCallback: Return? {
        get {
            return returnCallbacks[ScreenHashWrapper(self)] as? Return
        }
        set(value) {
            returnCallbacks[ScreenHashWrapper(self)] = value
        }
    }

    public internal(set) var context: Context {
        get {
            return contextByScreen[ScreenHashWrapper(self)] as! Self.Context
        }
        set(value) {
            contextByScreen[ScreenHashWrapper(self)] = value
        }
    }
    
    var onLeave: ((ReturnValue) -> Void)? {
        return onLeaveByScene[ScreenHashWrapper(self)] as? Return
    }
    
    internal func registerContext(_ value: Any?) {
        contextByScreen[ScreenHashWrapper(self)] = value as? Self.Context
    }
    
    internal func registerRewind(f: @escaping (ReturnValue) -> Void) {
        returnCallbacks[ScreenHashWrapper(self)] = f
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
    
    public func sendTransitionRequest<ContextType, ExpectedReturnType>(_ request: TransitionRequest<ContextType, ExpectedReturnType>,
                                                                       _ completion: @escaping (Bool) -> Void) -> Void {
        if let next = self.nextScreen {
            print("⚠️ [WARN][KabuKit.Screen:84] \(String(reflecting: next)) must be released, but that was retained!. So release it at any rate. Please call `leaveFromCurrent` correctly.")
        }
        self.nextScreen?.release()
        self.scenario?.start(atRequestOf: request, from: self, completion)
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue) {
        self.leaveFromCurrent(returnValue: returnValue, runTransition: true)
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue, runTransition: Bool) {
        self.leaveFromCurrent(returnValue: returnValue, runTransition: runTransition, { (Bool) in })
    }
    
    public func leaveFromCurrent(returnValue: ReturnValue, runTransition: Bool, _ completion: @escaping (Bool) -> Void) -> Void {
        guard let returnMethod = self.returnCallback else {
            completion(false)
            return
        }
        if (runTransition) {
            self.rewind?.backTransition?()
        }
        returnMethod(returnValue)
        onLeave?(returnValue)
        contextByScreen.removeValue(forKey: ScreenHashWrapper(self))
        returnCallback = nil
        completion(true)
        nextScreen?.release()
        release()
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
