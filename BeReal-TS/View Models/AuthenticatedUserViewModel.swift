//
//  Created by Evan DeLaney on 12/17/23.
//

import Observation

@Observable
final class AuthenticatedUserViewModel {
    
    let user: User
    
    let logOut: () async -> Void

    var root: Folder {
        user.rootItem
    }
    
    var fullName: String {
        user.firstName + " " + user.lastName
    }
    
    init(user: User, logOut: @escaping () async -> Void)
    {
        self.user = user
        self.logOut = logOut
    }
}

