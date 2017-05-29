import Foundation

public class Scenario<Stage> {
    
    private var anyWhereRouting: [String : Transition<Stage>]
    
    private var sceneRouting: [String : [String : Transition<Stage>]]
    
    public init(){
        self.sceneRouting = [String : [String : Transition<Stage>]]()
        self.anyWhereRouting = [String : Transition<Stage>]()
    }
    
    internal func resolve<T>(current: Page, link: Link<T>) -> Transition<Stage>? {
        let pageName = String(describing: type(of: current))
        let linkName = String(describing: type(of: link))
        var requestDic = sceneRouting[pageName]
        return requestDic?[linkName]
    }
    
    fileprivate func store(transition: Transition<Stage>, from: Page.Type? = nil) {
        guard (from != nil) else {
            anyWhereRouting[transition.name] = transition;
            return
        }
        let name = String(describing: from!)
        var requestDic = sceneRouting[name] ?? [String : Transition<Stage>]()
        requestDic[transition.name] = transition
        sceneRouting[name] = requestDic
        print(sceneRouting)
    }
    
    /**
     指定のシーンからあるLinkへリクエストが飛んだ時挙動を指定することができる
     
     ```
     at(ExampleScene.self) { (term) in
       term.when(ExpLink.self, to: NextScene()) { (from, next, stage)
     
       }
     }
     ```
     のようにかける
     
     - Attention: atよりもfromか?
     */
    public func at<From: Page>(_ scene: From.Type, _ connect: (Term<Stage>) -> Void) -> Self {
        let term = Term<Stage>(scenario: self, page: scene)
        connect(term)
        return self;
    }
    
    
    /**
     不特定多数のシーンからあるLinkへリクエストが飛んだ時挙動を指定することができる
     
     ```
     atAnyWhere { (term) in
       term.when(ExpLink.self, to: NextScene()) { (from, next, stage)
     
       }
     }
     ```
     のようにかける
     
     - Attention: atよりもfromか?
     
     */
    public func atAnyWhere(_ connect: (Term<Stage>) -> Void) -> Self {
        let term = Term<Stage>(scenario: self)
        connect(term)
        return self;
    }
        
}

import Foundation

/**
 画面遷移の条件を示すクラス
 
 */
public class Term<Stage> {
    
    private weak var scenario: Scenario<Stage>?
    private var pageType: Page.Type?
    
    /**
     Linkの飛び先と跳ぶ際の挙動を決める
     
     - Attention: whenというのはよいのか・・
     - Parameters:
     - link: Link
     - to: linkの飛び先
     - and: Sceneに遷移した際に行われる処理
     */
    public func when<Next: Scene>(_ link: Link<Next.ContextType>.Type, to: Next, _ and: @escaping (Page, Stage, Next) -> Void) {
        let transition = Transition<Stage>(link: link, next: to, f: and)
        scenario?.store(transition: transition, from: pageType)
    }
    
    
    public func when<Next: Scene>(_ link: Link<Next.ContextType>.Type, to: @escaping () -> Next, _ and: @escaping (Page, Stage, Next) -> Void) {
        let transition = Transition<Stage>(link: link, next: to, f: and)
        scenario?.store(transition: transition, from: pageType)
    }

    deinit {
        print("term deinit")
    }
    
    internal init(scenario: Scenario<Stage>, page: Page.Type? = nil) {
        self.scenario = scenario
        self.pageType = page
    }
    
}
