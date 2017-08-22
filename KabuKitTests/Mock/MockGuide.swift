import Foundation
import KabuKit

class MockGuide: SequenceGuide {
    typealias Stage = MockStage
    
    func start(with operation: SceneOperation<MockStage>) {
        operation.at(MockFirstScene.self) {
            $0.given(MockTransitionRequest.self, transitTo: { MockSecondScene() }) { args in
                args.from.nextScene = args.next
                return {}
            }
        }
    }
}
