//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation

final class ViewModelFactory {
        
    let client: APIClient
    let authentication: Authentication
    
    init(client: APIClient, authentication: Authentication)
    {
        self.authentication = authentication
        self.client = client
    }
    
    func makeAuthenticationViewModel() -> AuthenticationViewModel
    {
        AuthenticationViewModel(authentication: authentication, client: client)
    }
}
