//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation
@testable import BeReal_TS

extension File {
    
    static func make(identifier: String) -> File
    {
        File(
            identifier: identifier,
            parent: nil,
            isDirectory: false,
            modified: Date(),
            name: "Test File",
            size: 0,
            contentType: nil
        )
    }
}