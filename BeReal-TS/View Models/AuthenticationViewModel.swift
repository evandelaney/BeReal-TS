//
//  Created by Evan DeLaney on 12/15/23.
//

import Observation
import Combine

/// `AuthenticationCredentialStore` inherits from `AuthorizationDelegate`. It
/// defines the requirements for an object that can store authentication
/// credentials.
///
/// Objects conforming to this protocol must have a `username` and `password`
/// property. These properties are used to store the username and password of
/// the user.
protocol AuthenticationCredentialStore: AuthorizationDelegate {
    
    var username: String? { get set }

    var password: String? { get set }

    func clear()
}

extension  Authentication: AuthenticationCredentialStore { }

/// `AuthenticationClient` defines the requirements for objects that authenticate
/// a user. Objects conforming to this protocol must be a class (`AnyObject`).
///
/// The `getMe` method uses the `authorizationDelegate` to make an asynchronous
/// fetch for the authenticated user. If a user cannot be fectched, it throws an
/// error.
protocol AuthenticationClient: AnyObject {

    var authorizationDelegate: AuthorizationDelegate? { get set }

    func getMe() async throws -> User
}

extension APIClient: AuthenticationClient { }

@Observable
final class AuthenticationViewModel {
    
    enum Error: Swift.Error {
        case invalidCredentials
    }
    
    private(set) var state: AuthenticationState.State
    
    var error: Swift.Error? {
        if case let .error(error) = state {
            return error
        }
        return nil
    }
    
    var authenticatedUser: User? {
        if case let .authenticated(user) = state {
            return user
        }
        return nil
    }
    
    let credentialStore: AuthenticationCredentialStore
    
    let client: AuthenticationClient
    
    private var stateMachine: AuthenticationState
    
    init(authentication: AuthenticationCredentialStore, client: AuthenticationClient)
    {
        self.credentialStore = authentication
        self.client = client
        self.client.authorizationDelegate = self.credentialStore
        self.stateMachine = AuthenticationState(initialState: .unauthenticated)
        self.state = .unauthenticated
        
        Task {
            await authenticateUser()
        }
    }
    
    func logIn(username: String, password: String) async
    {
        guard !username.isEmpty && !password.isEmpty else {
            await stateMachineTransition(to: .error(Error.invalidCredentials))
            return
        }
        
        credentialStore.username = username
        credentialStore.password = password
        
        await authenticateUser()
    }
    
    func authenticateUser() async
    {
        guard credentialStore.password != nil && credentialStore.username != nil else { return }
        
        do {
            await stateMachineTransition(to: .loading)
            let user = try await client.getMe()
            await stateMachineTransition(to: .authenticated(user))
        }
        catch {
            credentialStore.clear()
            await stateMachineTransition(to: .error(error))
        }
    }
    
    func logOut() async
    {
        credentialStore.clear()
        await stateMachineTransition(to: .unauthenticated)
    }
    
    private func stateMachineTransition(to newState: AuthenticationState.State) async
    {
        do {
            try await stateMachine.transition(to: newState)
            await MainActor.run {
                state = newState
            }
        }
        catch {
            print(error)
            fatalError()
        }
    }
}
