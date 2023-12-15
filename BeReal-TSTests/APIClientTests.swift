//
//  Created by Evan DeLaney on 12/15/23.
//

import XCTest
@testable import BeReal_TS

final class APIClientTests: XCTestCase {

    private var sut: APIClient!
    private var mockSession: MockURLSession!
    private var mockAuthorizationDelegate: MockAuthorizationDelegate!

    override func setUp()
    {
        super.setUp()
        
        mockSession = MockURLSession()
        mockAuthorizationDelegate = MockAuthorizationDelegate()
        
        sut = APIClient(hostname: "test", urlSession: mockSession)
        sut.authorizationDelegate = mockAuthorizationDelegate
    }

    override func tearDown()
    {
        sut = nil
        mockSession = nil
        mockAuthorizationDelegate = nil
        
        super.tearDown()
    }

    func testGetMe() async throws
    {
        mockSession.nextData = """
                   {
                       "firstName" : "Test",
                       "lastName" : "User",
                       "rootItem" : {
                           "id" : "1",
                           "parent" : "",
                           "name" : "Unit Test Folder",
                           "isDir" : true,
                           "modificationDate": "2021-11-29T10:57:13Z"
                       }
                   }
                   """.data(using: .utf8)
        
        let result = try await sut.getMe()
        
        XCTAssertEqual(result.firstName, "Test")
        XCTAssertEqual(result.lastName, "User")
        XCTAssertEqual(result.rootItem.identifier, "1")
    }

    // TODO: More Testing
    //  - Test the remaining methods
    //  - Test requests sent to mock session are correct
}

private class MockURLSession: URLSessionAsync {
    
    var nextData: Data?

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
    {
        return (nextData ?? Data(), HTTPURLResponse())
    }
}

final class MockAuthorizationDelegate: AuthorizationDelegate
{
    func getBasicAuth() throws -> String
    {
        return "Basic test"
    }
}
