//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation
@testable import BeReal_TS

extension File {
    
    static func make(identifier: String, modified: Date = .now) -> File
    {
        File(
            identifier: identifier,
            parent: nil,
            isDirectory: false,
            modified: modified,
            name: "Test File",
            size: 0,
            contentType: nil
        )
    }
}
