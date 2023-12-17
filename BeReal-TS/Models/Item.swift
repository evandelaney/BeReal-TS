//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct FolderIdentifier: Decodable, RawRepresentable, Equatable {
    let rawValue: String
}

protocol Item: Decodable, ItemCellDisplayable {
    
    var identifier: String { get }
    
    var parent: FolderIdentifier? { get }
    
    var name: String { get }
    
    var isDirectory: Bool { get }
    
    var modified: Date { get }
}

extension Item {
    
    var localizedHeadline: String {
        name
    }
    
    func localizedSubheadline(
        with dateFormatter: DateFormatter
    ) -> String {
        dateFormatter.string(from: modified)
    }
}
