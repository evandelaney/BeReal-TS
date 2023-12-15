//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct File: Item {
    
    let identifier: String
    
    let parent: FolderIdentifier?
    
    let isDirectory: Bool
    
    let modified: Date
    
    let name: String

    let size: Int?
    
    let contentType: String?
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case parent = "parentId"
        case isDirectory = "isDir"
        case modified = "modificationDate"
        case name
        case size
        case contentType
    }
}

extension File: Equatable {

    static func == (lhs: File, rhs: File) -> Bool
    {
        lhs.identifier == rhs.identifier
    }
}
