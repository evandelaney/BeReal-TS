//
//  Created by Evan DeLaney on 12/17/23.
//

import XCTest
@testable import BeReal_TS

final class FolderStateTests: XCTestCase {
    
    private var machine: ItemState<[ any Item ]>!
    
    override func setUpWithError() throws
    {
        try super.setUpWithError()
        
        machine = ItemState()
    }
    
    override func tearDownWithError() throws
    {
        machine = nil
        
        try super.tearDownWithError()
    }
    
    func testInitialState() async
    {
        let state = await machine.state
        
        AssertStateEmpty(state)
    }
    
    func testTransitionFromEmptyToLoading() async throws
    {
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        AssertStateLoading(state)
    }
    
    func testTransitionFromContentToLoading() async throws
    {
        machine = ItemState(initialState: .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
        
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        AssertStateLoading(state)
    }
    
    func testTransitionFromErrorToLoading() async throws
    {
        machine = ItemState(initialState: .error(NSError(domain: "UnitTest", code: 42)))
        
        try await machine.transition(to: .loading)
        let state = await machine.state
        
        AssertStateLoading(state)
    }
    
    func testTransitionFromLoadingToContent() async throws
    {
        machine = ItemState(initialState: .loading)
        
        try await machine.transition(to: .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
        let state = await machine.state
        
        AssertStateContent(state)
    }
    
    func testTransitionFromLoadingToEmpty() async throws
    {
        machine = ItemState(initialState: .loading)
        
        try await machine.transition(to: .empty)
        let state = await machine.state
        
        AssertStateEmpty(state)
    }
    
    func testTransitionFromLoadingToError() async throws
    {
        machine = ItemState(initialState: .loading)
        let error = NSError(domain: "UnitTest", code: 42)
        
        try await machine.transition(to: .error(error))
        let state = await machine.state
        
        AssertStateError(state)
    }
    
    func testTransitionFromContentToEmpty() async throws
    {
        machine = ItemState(initialState: .content([
            Folder.make(identifier: "UNIT TEST 1"),
            File.make(identifier: "UNIT TEST 2")
        ]))
        
        do {
            try await machine.transition(to: .empty)
        }
        catch {
            XCTAssertTrue(error is StateMachineError<ItemState<[ any Item ]>.State>)
            return
        }
        
        XCTFail()
    }
}

public func AssertStateEmpty<U>(
    _ expression: @autoclosure () -> ItemState<U>.State,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard case .empty = expression() else {
        XCTFail()
        return
    }
}

public func AssertStateContent<U>(
    _ expression: @autoclosure () -> ItemState<U>.State,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard case .content = expression() else {
        XCTFail()
        return
    }
}

public func AssertStateError<U>(
    _ expression: @autoclosure () -> ItemState<U>.State,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard case .error = expression() else {
        XCTFail()
        return
    }
}

public func AssertStateLoading<U>(
    _ expression: @autoclosure () -> ItemState<U>.State,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard case .loading = expression() else {
        XCTFail()
        return
    }
}

