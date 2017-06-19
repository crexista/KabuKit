import Foundation
import KabuKit

class SampleARequest : Request<Bool> {}
class SampleBRequest : Request<Void> {}

class SampleSequenceRule : Guide {
    typealias Stage = UINavigationController
    
    func start(with operation: KabuKit.Operation<UINavigationController>) {
        operation.at(Sample1AViewController.self) { (scenario) in
            scenario.given(link: SampleARequest.self, to: { () in
                return Sample1AViewController()
            }, begin: { (args) in
                let next = args.next
                args.stage.pushViewController(next, animated: true)
            }, end: { (args) in
                args.stage.popViewController(animated: true)
            })
            
            scenario.given(link: SampleBRequest.self, to: { () in
                return Sample1BViewController()
            }, begin: { (args) in
                let next = args.next
                args.stage.pushViewController(next, animated: true)
            }, end: { (args) in
                args.stage.popViewController(animated: true)
            })
        }
        
        operation.at(Sample1BViewController.self) { (scenario) in
            scenario.given(link: SampleARequest.self, to: { () in
                return Sample1AViewController()
            }, begin: { (args) in
                let next = args.next
                args.stage.pushViewController(next, animated: true)
            }, end: { (args) in
                args.stage.popViewController(animated: true)
            })
            
            scenario.given(link: SampleBRequest.self, to: { () in
                return Sample1BViewController()
            }, begin: { (args) in
                let next = args.next
                args.stage.pushViewController(next, animated: true)
            }, end: { (args) in
                args.stage.popViewController(animated: true)
            })
        }
    }

}
