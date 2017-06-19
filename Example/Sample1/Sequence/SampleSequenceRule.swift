import Foundation
import KabuKit

class SampleARequest : Request<Bool> {}
class SampleBRequest : Request<Void> {}

class SampleSequenceRule : Guide {
    typealias Stage = UINavigationController
    
    func start(with operation: SceneOperation<UINavigationController>) {
        operation.at(Sample1AViewController.self) { (scenario) in
            scenario.given(SampleARequest.self, { Sample1AViewController() }) { (args) in
                args.stage.pushViewController(args.next, animated: true)
                return {
                    args.stage.popViewController(animated: true)
                }
            }
            scenario.given(SampleBRequest.self, { Sample1BViewController() }) { (args) in
                args.stage.pushViewController(args.next, animated: true)
                return {
                    args.stage.popViewController(animated: true)
                }
            }

        }
        
        operation.at(Sample1BViewController.self) { (scenario) in
            scenario.given(SampleARequest.self, { Sample1AViewController() }) { (args) in
                args.stage.pushViewController(args.next, animated: true)
                return {
                    args.stage.popViewController(animated: true)
                }
            }
            scenario.given(SampleBRequest.self, { Sample1BViewController() }) { (args) in
                args.stage.pushViewController(args.next, animated: true)
                return {
                    args.stage.popViewController(animated: true)
                }
            }
        }
    }

}
