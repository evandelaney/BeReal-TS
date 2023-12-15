//
//  Created by Evan DeLaney on 12/14/23.
//

import XCTest
@testable import BeReal_TS

final class FolderTests: XCTestCase {

    override func setUpWithError() throws
    {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws
    {
        try super.tearDownWithError()
    }

    func testDecodeExampleJSON() throws {
        let json = """
                   {
                       "id": "a8537d631d21a8b7fdbbcd11e4d2e5d09d61971d",
                       "isDir": true,
                       "modificationDate": "2023-12-06T14:05:45.624856899Z",
                       "name": "Documents",
                       "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7"
                   }
                   """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .apiFormat
        
        let file = try decoder.decode(File.self, from: json)

        XCTAssertEqual(file.identifier, "a8537d631d21a8b7fdbbcd11e4d2e5d09d61971d")
        XCTAssertEqual(file.parent?.rawValue, "ec94bd0365b352832710f171bd8463b6d9caf6e7")
        XCTAssertEqual(file.isDirectory, true)
        XCTAssertEqual(file.name, "Documents")
    }
}
