//
//  Created by Evan DeLaney on 12/17/23.
//

import XCTest
@testable import BeReal_TS

final class FolderStateTests: XCTestCase {
    
    private var machine: FolderState!
    
    override func setUpWithError() throws
    {
        try super.setUpWithError()
        
        machine = FolderState()
    }
    
    override func tearDownWithError() throws
    {
        machine = nil
        
        try super.tearDownWithError()
    }
    
    func testInitialState() async
    {
        let state = await machine.state
        
        XCTAssertEqual(state, .empty)
    }
    
    func testTransitionFromEmptyToLoading() async throws
    {
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        XCTAssertEqual(state, .loading)
    }
    
    func testTransitionFromContentToLoading() async throws
    {
        machine = FolderState(initialState: .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
        
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        XCTAssertEqual(state, .loading)
    }
    
    func testTransitionFromErrorToLoading() async throws
    {
        machine = FolderState(initialState: .error(NSError(domain: "UnitTest", code: 42)))
        
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        XCTAssertEqual(state, .loading)
    }
    
    func testTransitionFromLoadingToContent() async throws
    {
        machine = FolderState(initialState: .loading)
        
        try await machine.transition(to: .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
        let state = await machine.state
        
        XCTAssertEqual(state, .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
    }
    
    func testTransitionFromLoadingToEmpty() async throws
    {
        machine = FolderState(initialState: .loading)
        
        try await machine.transition(to: .empty)
        let state = await machine.state
        
        XCTAssertEqual(state, .empty)
    }
    
    func testTransitionFromLoadingToError() async throws
    {
        machine = FolderState(initialState: .loading)
        let error = NSError(domain: "UnitTest", code: 42)
        
        try await machine.transition(to: .error(error))
        let state = await machine.state
        
        XCTAssertEqual(state, .error(error))
    }
    
    func testTransitionFromContentToEmpty() async throws
    {
        machine = FolderState(initialState: .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
        
        do {
            try await machine.transition(to: .empty)
        }
        catch {
            XCTAssertTrue(error is StateMachineError<FolderState.State>)
            return
        }
        
        XCTFail()
    }
}
