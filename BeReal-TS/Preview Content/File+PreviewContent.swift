//
//  Created by Evan DeLaney on 12/15/23.
//

import Foundation

extension File {
    
    static let preview1 = File(
        identifier: "FILE-PREVIEW-1",
        parent: nil,
        modified: Date(),
        name: "Preview File #1",
        size: 2048,
        contentType: "image/png"
    )
    
    static let preview2 = File(
        identifier: "FILE-PREVIEW-2",
        parent: nil,
        modified: Date(),
        name: "Preview File #2",
        size: 1024,
        contentType: "image/jpeg"
    )
}
