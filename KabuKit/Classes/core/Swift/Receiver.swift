import Foundation

internal protocol LinkHandler {
    

    /**
     
     */
    func handle<P: Page, T>(_ from: P, _ link: Link<T>)
    
    
    func handle<P: Page, T>(_ from: P, _ link: Link<T>) where P: Scenario
}
