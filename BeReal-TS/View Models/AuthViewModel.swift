//
//  Created by Evan DeLaney on 12/15/23.
//

import Observation

@Observable
final class AuthViewModel {
    
    private(set) var isAuthenticated = false
    private(set) var error: Error?
    private(set) var authenticatedUser: User?
    
    let authentication: Authentication
    let client: APIClient
    
    init(authentication: Authentication, client: APIClient)
    {
        self.authentication = authentication
        self.client = client
        self.client.authorizationDelegate = self.authentication
        
        isAuthenticated = authentication.password != nil && authentication.username != nil
    }
    
    func logIn(username: String, password: String) async
    {
        authentication.username = username
        authentication.password = password
        
        await reloadUser()
    }
    
    func reloadUser() async
    {
        do {
            authenticatedUser = try await client.getMe()
            isAuthenticated = true
        }
        catch {
            logOut()
            self.error = error
        }
    }
    
    func logOut()
    {
        authentication.username = nil
        authentication.password = nil
        isAuthenticated = false
    }
}
