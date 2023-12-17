//
//  Created by Evan DeLaney on 12/17/23.
//

import XCTest
@testable import BeReal_TS

final class AuthenticatedUserViewModelTests: XCTestCase {
    
    func testFullNameReturnsExpectedValue()
    {
        let user = User.make()
        let viewModel = AuthenticatedUserViewModel(user: user, logOut: { })
        
        XCTAssertEqual(viewModel.fullName, "Evan DeLaney")
    }
    
    func testRootReturnsExpectedValue()
    {
        let user = User.make()
        let viewModel = AuthenticatedUserViewModel(user: user, logOut: { })
        
        XCTAssertEqual(viewModel.root, user.rootItem)
    }
    
    func testLogOutFiresClosure() async
    {
        var isLogOutCalled = false
        let user = User.make()
        let viewModel = AuthenticatedUserViewModel(user: user, logOut: { isLogOutCalled = true })
        
        await viewModel.logOut()
        
        XCTAssertTrue(isLogOutCalled)
    }
}
