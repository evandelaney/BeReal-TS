//
//  Created by Evan DeLaney on 12/17/23.
//

import XCTest
@testable import BeReal_TS

final class FolderViewModelTests: XCTestCase {
    
    private var sut: ItemViewModel<Folder, [ any Item ]>!
    private var root: Folder!
    private var mockClient: MockAPIClient!
    
    override func setUpWithError() throws
    {
        try super.setUpWithError()
        
        mockClient = MockAPIClient()
        root = Folder.make(identifier: "UNIT TEST ROOT")
        sut = ItemViewModel(
            root: root,
            getter: mockClient.getItems(at:)
        )
    }
    
    override func tearDownWithError() throws
    {
        sut = nil
        root = nil
        mockClient = nil
        
        try super.tearDownWithError()
    }
    
    func testItemsIsNil()
    {
        XCTAssertNil(sut.items)
    }
    
    func testErrorIsNil()
    {
        XCTAssertNil(sut.error)
    }
    
    func testIsLoadingIsFalse()
    {
        XCTAssertFalse(sut.isLoading)
    }
    
    func testIsEmptyIsTrue()
    {
        XCTAssertTrue(sut.isEmpty)
    }
    
    func testSuccessfulLoadItems() async
    {
        mockClient.items = [
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]
        
        await sut.load()
        
        AssertStateContent(sut.state)
    }
    
    func testItemsAreAvailableAfterSuccessfulLoad() async
    {
        mockClient.items = [
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]
        
        await sut.load()
        
        XCTAssertEqual(sut.items?.count, 2)
    }
    
    func testEmptyLoadItems() async
    {
        mockClient.items = []
        
        await sut.load()
        
        AssertStateEmpty(sut.state)
    }
    
    func testIsEmptyIsTrueAfterEmptyLoad() async
    {
        mockClient.items = []
        
        await sut.load()
        
        XCTAssertTrue(sut.isEmpty)
    }
    
    func testErrorLoadItems() async
    {
        mockClient.error = NSError(domain: "UnitTest", code: 42)
        
        await sut.load()
        
        AssertStateError(sut.state)
    }
    
    func testErrorIsAvailableAfterErrorLoad() async
    {
        mockClient.error = NSError(domain: "UnitTest", code: 42)
        
        await sut.load()
        
        XCTAssertNotNil(sut.error)
    }
}

private final class MockAPIClient {
    
    var items: [ any Item ]?
    var error: Error?
    
    func getItems(at folder: BeReal_TS.Folder) async throws -> [ any Item ]
    {
        if let error {
            throw error
        }
        
        guard let items else {
            throw NSError(domain: "UnitTest", code: 42)
        }
        
        return items
    }
}
