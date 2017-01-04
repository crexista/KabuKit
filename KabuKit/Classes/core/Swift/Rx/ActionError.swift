//
//  Copyright © 2017 crexista
//

import Foundation

struct ActionError: Error {
    let recoverPattern: ActionRecoverPattern
    let target: ObserverTarget
    let onError: (Error, String?) -> ActionRecoverPattern
    let actionName: String
}
