//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct Folder: Item {
    
    let identifier: String
    
    let parent: FolderIdentifier?
    
    let isDirectory: Bool
    
    let modified: Date
    
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case parent = "parentId"
        case isDirectory = "isDir"
        case modified = "modificationDate"
        case name
    }
}

extension Folder: Equatable {

    static func == (lhs: Folder, rhs: Folder) -> Bool
    {
        lhs.identifier == rhs.identifier
    }
}
