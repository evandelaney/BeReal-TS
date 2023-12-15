//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct ItemsResponse: Decodable {
    
    var items: [ Item ]

    var folders: [ Folder ] {
        items.compactMap { $0 as? Folder }
    }

    var files: [ File ] {
        items.compactMap { $0 as? File }
    }

    private enum CodingKeys: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws
    {
        var items: [ Item ] = []
        var container = try decoder.unkeyedContainer()
        
        while !container.isAtEnd {
            if let folder = try? container.decode(Folder.self) {
                items.append(folder)
            }
            else if let file = try? container.decode(File.self) {
                items.append(file)
            }
            else {
                let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown item type")
                throw DecodingError.dataCorrupted(context)
            }
        }
        self.items = items
    }

    init(items: [ Item ])
    {
        self.items = items
    }
}
