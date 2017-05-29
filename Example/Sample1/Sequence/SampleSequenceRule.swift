import Foundation
import KabuKit

class SampleALink : Link<Bool> {}
class SampleBLink : Link<Void> {}

class SampleSequenceRule : SequenceRule {
    typealias StageType = UINavigationController
    
    let scenario = Scenario<UINavigationController>()
        // このような感じでroutingを書く
    .at(Sample1AViewController.self) { (term) in
        term.when(SampleALink.self, to: { Sample1AViewController() }) { (from, stage, next) in
            stage.pushViewController(next, animated: true)
        }
        
        term.when(SampleBLink.self, to: { Sample1BViewController() }) { (from, stage, next) in
            stage.pushViewController(next, animated: true)
        }
        
    }.at(Sample1BViewController.self) { (term) in
        
        term.when(SampleALink.self, to: { Sample1AViewController() }) { (from, stage, next) in
            stage.pushViewController(next, animated: true)
        }
        
        term.when(SampleBLink.self, to: { Sample1BViewController() }) { (from, stage, next) in
            stage.pushViewController(next, animated: true)
        }
    }
    
    
    func onEnd<S>(page: S, stage: UINavigationController) where S : Page {
        stage.popViewController(animated: true)
    }

}
