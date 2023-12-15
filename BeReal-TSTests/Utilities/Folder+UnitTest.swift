//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation
@testable import BeReal_TS

extension Folder {
    
    static func make(identifier: String) -> Folder
    {
        Folder(
            identifier: identifier,
            parent: nil,
            isDirectory: true,
            modified: Date(),
            name: "Test Folder"
        )
    }
}


