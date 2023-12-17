//
//  Created by Evan DeLaney on 12/14/23.
//

@testable import BeReal_TS

extension User {
    
    static func make(
        firstName: String = "Evan",
        lastName: String = "DeLaney",
        rootItem: Folder = .make(identifier: "UNIT-TEST")
    ) -> User {
        User(
            firstName: firstName,
            lastName: lastName,
            rootItem: rootItem
        )
    }
}
