//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

final class User: Decodable {

    let firstName: String
    let lastName: String
    let rootItem: Folder

    init(firstName: String, lastName: String, rootItem: Folder)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.rootItem = rootItem
    }
}
