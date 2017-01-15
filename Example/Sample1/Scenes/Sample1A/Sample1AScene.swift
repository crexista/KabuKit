//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit


extension Sample1AViewController: Scene, SceneLinkage {
    
    enum Sample1Destination: Destination {
        typealias StageType = UIViewController
        // A Sceneに遷移
        case aScene
        // B Sceneに遷移
        case bScene
    }
    
    typealias DestinationType = Sample1Destination
    
    typealias ContextType = Bool

    func guide(to destination: Sample1Destination) -> SceneTransition<UIViewController>? {

        switch destination {
        case .aScene:
            let scene = Sample1AViewController(nibName: "Sample1AViewController", bundle: Bundle.main)
            return destination.specify(scene, true, { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            })
            
        case .bScene:
            let scene = Sample1BViewController(nibName: "Sample1BViewController", bundle: Bundle.main)
            return destination.specify(scene, nil, { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            })
            
        }
    }
    
    /**
     Sceneが削除されるときに呼ばれます.
     画面上から消すための処理をここに記述してください
     
     */
    public func willRemove(from stage: UIViewController) {
        _ = stage.navigationController?.popViewController(animated: true)
    }

    
    func onPressAButton(sender: UIButton) {
        director?.forwardTo(Sample1Destination.aScene)
    }
    
    func onPressBButton(sender: UIButton) {
        director?.forwardTo(Sample1Destination.bScene)
    }
    
    func onPressPrevButton(sender: UIButton) {
        director?.back()
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        if (context == true) {
            prevButton.isEnabled = true
            prevButton.alpha = 1.0
        } else {
            prevButton.isEnabled = false
            prevButton.alpha = 0.5
        }
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil) {
            director?.back()
        }
    }
}
