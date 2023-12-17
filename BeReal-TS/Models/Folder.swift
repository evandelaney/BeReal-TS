//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct Folder: Item {
    
    let identifier: String
    
    let parent: FolderIdentifier?
    
    let modified: Date
    
    let name: String
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isDirectory = try container.decode(Bool.self, forKey: .isDirectory)
        
        guard isDirectory else {
            throw DecodingError.typeMismatch(
                Folder.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Item is a `File`, not `Folder`"
                )
            )
        }
        
        identifier = try container.decode(String.self, forKey: .identifier)
        parent = try container.decodeIfPresent(FolderIdentifier.self, forKey: .parent)
        modified = try container.decode(Date.self, forKey: .modified)
        name = try container.decode(String.self, forKey: .name)
    }
    
    init(
        identifier: String,
        parent: FolderIdentifier?,
        modified: Date,
        name: String
    ) {
        self.identifier = identifier
        self.parent = parent
        self.modified = modified
        self.name = name
    }

    
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

extension Folder: Hashable {
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(identifier)
    }
}

extension Folder: ItemCellDisplayable {
    
    var iconName: String {
        "folder"
    }
    
    func localizedSubheadline(
        with dateFormatter: DateFormatter
    ) -> String {
        dateFormatter.string(from: modified)
    }
}
