//
//  Created by Evan DeLaney on 12/16/23.
//

import XCTest
@testable import BeReal_TS

final class AuthenticationStateTests: XCTestCase {
    
    private var machine: AuthenticationState!
    private var user: User!
    
    override func setUpWithError() throws
    {
        try super.setUpWithError()
        
        machine = AuthenticationState()
        user = .make()
    }
    
    override func tearDownWithError() throws
    {
        machine = nil
        user = nil
        
        try super.tearDownWithError()
    }
    
    func testInitialState() async
    {
        let state = await machine.state
        
        XCTAssertEqual(state, .unauthenticated)
    }
    
    func testTransitionToLoadingFromUnauthenticated() async throws
    {
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        XCTAssertEqual(state, .loading)
    }
    
    func testTransitionToAuthenticatedFromLoading() async throws
    {
        machine = AuthenticationState(initialState: .loading)
        
        try await machine.transition(to: .authenticated(user))
        let state = await machine.state
        
        XCTAssertEqual(state, .authenticated(user))
    }
    
    func testTransitionToErrorFromLoading() async throws
    {
        machine = AuthenticationState(initialState: .loading)
        let error = AuthenticationState.Error.invalidStateTransition
        
        try await machine.transition(to: .error(error))
        let state = await machine.state
        
        XCTAssertEqual(state, .error(error))
    }
    
    func testTransitionToErrorFromUnauthenticated() async throws
    {
        let error = NSError(domain: "UnitTest", code: 42)
        
        try await machine.transition(to: .error(error))
        let state = await machine.state
        
        XCTAssertEqual(state, .error(error))
    }
    
    func testTransitionToUnauthenticatedFromAuthenticated() async throws
    {
        machine = AuthenticationState(initialState: .authenticated(user))
        
        try await machine.transition(to: .unauthenticated)
        let state = await machine.state
        
        XCTAssertEqual(state, .unauthenticated)
    }
    
    func testTransitionToLoadingFromError() async throws
    {
        machine = AuthenticationState(initialState: .error(NSError(domain: "UnitTest", code: 42)))
        
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        XCTAssertEqual(state, .loading)
    }
    
    func testTransitionToLoadingFromAuthenticatedFails() async throws
    {
        machine = AuthenticationState(initialState: .authenticated(user))
        
        do {
            try await machine.transition(to: .loading)
        }
        catch {
            XCTAssertEqual(error as? AuthenticationState.Error, .invalidStateTransition)
            return
        }
        
        XCTFail()
    }
    
    func testTransitionToErrorFromAuthenticatedFails() async throws
    {
        machine = AuthenticationState(initialState: .authenticated(user))
        
        do {
            try await machine.transition(to: .error(NSError(domain: "UnitTest", code: 42)))
        }
        catch {
            XCTAssertEqual(error as? AuthenticationState.Error, .invalidStateTransition)
            return
        }
        
        XCTFail()
    }
}
