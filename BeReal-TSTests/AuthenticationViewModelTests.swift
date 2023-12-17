//
//  Created by Evan DeLaney on 12/17/23.
//

import XCTest
@testable import BeReal_TS

final class AuthenticationViewModelTests: XCTestCase {
    
    private var sut: AuthenticationViewModel!
    private var mockAuthentication: MockAuthentication!
    private var mockClient: MockAPIClient!
    
    override func setUpWithError() throws
    {
        try super.setUpWithError()
        
        mockAuthentication = MockAuthentication()
        mockClient = MockAPIClient()
        sut = AuthenticationViewModel(authentication: mockAuthentication, client: mockClient)
    }
    
    override func tearDownWithError() throws
    {
        sut = nil
        mockAuthentication = nil
        mockClient = nil
        
        try super.tearDownWithError()
    }
    
    func testAuthenticatedUserReturnsNil()
    {
        XCTAssertEqual(sut.state, .unauthenticated)
        XCTAssertNil(sut.authenticatedUser)
    }
    
    func testErrorReturnsNil()
    {
        XCTAssertEqual(sut.state, .unauthenticated)
        XCTAssertNil(sut.error)
    }
    
    func testSuccessfulLogin() async
    {
        mockClient.user = .make()
        
        await sut.logIn(username: "test", password: "password")
        
        XCTAssertEqual(sut.state, .authenticated(mockClient.user!))
    }
    
    func testAuthenticatedUserIsAvailableAfterSuccessfulLogin() async
    {
        mockClient.user = .make()
        
        await sut.logIn(username: "test", password: "password")
        
        XCTAssertNotNil(sut.authenticatedUser)
        XCTAssertIdentical(sut.authenticatedUser, mockClient.user)
    }
    
    func testLoginWithInvalidCredentials() async
    {
        mockClient.error = NSError(domain: "UnitTest", code: 42, userInfo: nil)
        
        await sut.logIn(username: "test", password: "wrongpassword")
        
        XCTAssertEqual(sut.state, .error(mockClient.error!))
    }
    
    func testErrorIsAvailableAfterFailedLogin() async
    {
        mockClient.error = NSError(domain: "UnitTest", code: 42, userInfo: nil)
        
        await sut.logIn(username: "test", password: "wrongpassword")
        
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(
            sut.error?.localizedDescription,
            mockClient.error?.localizedDescription
        )
    }
    
    func testLogoutAfterSuccessfulLogin() async
    {
        mockClient.user = .make()
        
        await sut.logIn(username: "test", password: "password")
        await sut.logOut()
        
        XCTAssertEqual(sut.state, .unauthenticated)
    }
    
    func testLoginWithEmptyCredentials() async
    {
        await sut.logIn(username: "", password: "")
        
        XCTAssertEqual(sut.state, .error(AuthenticationViewModel.Error.invalidCredentials))
    }
}

private final class MockAuthentication: AuthenticationCredentialStore {
    
    var username: String?
    var password: String?
    
    func clear()
    {
        username = nil
        password = nil
    }
    
    func getBasicAuth() throws -> String
    {
        "UNIT-TEST"
    }
}

private final class MockAPIClient: AuthenticationClient {
    
    var user: User?
    var error: Error?
    var authorizationDelegate: AuthorizationDelegate?
    
    func getMe() async throws -> User
    {
        if let error = error {
            throw error
        }
        
        return user!
    }
}
