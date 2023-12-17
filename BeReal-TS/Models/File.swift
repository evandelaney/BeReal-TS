//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct File: Item {
    
    let identifier: String
    
    let parent: FolderIdentifier?
    
    let modified: Date
    
    let name: String

    let size: Int?
    
    let contentType: String?
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isDirectory = try container.decode(Bool.self, forKey: .isDirectory)
        guard !isDirectory else {
            throw DecodingError.typeMismatch(
                File.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Item is a `Folder`, not `File`"
                )
            )
        }
        
        identifier = try container.decode(String.self, forKey: .identifier)
        parent = try container.decodeIfPresent(FolderIdentifier.self, forKey: .parent)
        modified = try container.decode(Date.self, forKey: .modified)
        name = try container.decode(String.self, forKey: .name)
        size = try container.decodeIfPresent(Int.self, forKey: .size)
        contentType = try container.decodeIfPresent(String.self, forKey: .contentType)
    }
    
    init(identifier: String,
         parent: FolderIdentifier?,
         modified: Date,
         name: String,
         size: Int?,
         contentType: String?
    ) {
        self.identifier = identifier
        self.parent = parent
        self.modified = modified
        self.name = name
        self.size = size
        self.contentType = contentType
    }
    
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

extension File: Hashable {
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(identifier)
    }
}

extension File: ItemCellDisplayable {
    
    var iconName: String {
        "doc"
    }
    
    func localizedSubheadline(
        with dateFormatter: DateFormatter
    ) -> String {
        dateFormatter.string(from: modified)
    }
}

