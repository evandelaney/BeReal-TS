//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

struct FolderIdentifier: Decodable, RawRepresentable, Equatable {
    let rawValue: String
}

protocol Item: Decodable, Hashable, ItemCellDisplayable {
    
    var identifier: String { get }
    
    var parent: FolderIdentifier? { get }
    
    var name: String { get }
    
    var modified: Date { get }
}

extension Item {
    
    var localizedHeadline: String {
        name
    }    
}
