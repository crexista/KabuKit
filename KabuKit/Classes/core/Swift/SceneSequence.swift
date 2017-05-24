import Foundation

internal var containerByScean = [HashWrap : LinkHandler]()

public class SceneSequence<C, S: Scenario> : Scene, LinkHandler {

    public typealias ContextType = C
    
    public typealias StageType = S.StageType
    
    private var scenes: [HashWrap]
    
    private var isRecordable: Bool = true
    
    private var scenario: S?
    
    private var stage: S.StageType?
    
    internal func handle<P: Page, T>(_ from: P, _ link: Link<T>) {

        let nextPageRequest = from.requestNextPage(scenario: scenario!, link: link)

        nextPageRequest.execute(from: from, stage: stage!) { (nextPage) in
            let hashwrap = HashWrap(nextPage)
            scenes.append(hashwrap)
            containerByScean[hashwrap] = self
        }
    }
    
    internal func handle<P: Page, T>(_ from: P, _ link: Link<T>) where P: Scenario {
        
        let nextPageRequest = from.requestNextPage(scenario: from, link: link)

        nextPageRequest.execute(from: from, stage: stage as! P.StageType) { (nextPage) in
            let hashwrap = HashWrap(nextPage)
            scenes.append(hashwrap)
            containerByScean[hashwrap] = self
        }
    }

    
    public func startWith<T: Scene>(_ stage: S.StageType,
                                    _ scene: T,
                                    _ context: T.ContextType,
                                    _ setup: (_ scene: T, _ stage: S.StageType) -> Void) {
        self.stage = stage
        self.scenes.append(HashWrap(scene))
        scene.context = context
    }
    
    public init(_ scenario: S?) {
        scenes = [HashWrap]()
        self.scenario = scenario
    }
}


