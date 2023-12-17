//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation
@testable import BeReal_TS

extension Folder {
    
    static func make(identifier: String, modified: Date = .now) -> Folder
    {
        Folder(
            identifier: identifier,
            parent: nil,
            modified: modified,
            name: "Test Folder"
        )
    }
}


