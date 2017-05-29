import Foundation

internal class Transition<Stage> : Hashable {
    
    private let execFunc: (_ stage: Stage, _ from: Page, _ prepare: (Page) -> Void) -> Void
    
    internal let hashValue: Int
    
    internal let name: String
    
    static public func ==(lhs: Transition, rhs: Transition) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
    
    internal func execute(from: Page, stage: Stage, _ prepare:(Page) -> Void) {
        execFunc(stage, from, prepare)
    }
    
    init<Next: Scene>(link: Link<Next.ContextType>.Type, next: @escaping () -> Next, f: @escaping (Page, Stage, Next) -> Void) {
        name = String(describing: link)
        hashValue = name.hashValue
        execFunc = { (stage: Stage, from: Page, prepare: (Page) -> Void) -> Void in
            let nextPage = next()
            prepare(nextPage)
            f(from, stage, nextPage)
        }
    }

    
    init<Next: Scene>(link: Link<Next.ContextType>.Type, next: Next, f: @escaping (Page, Stage, Next) -> Void) {
        name = String(describing: link)
        hashValue = name.hashValue
        execFunc = { (stage: Stage, from: Page, prepare: (Page) -> Void) -> Void in
            prepare(next)
            f(from, stage, next)
        }
    }
}
