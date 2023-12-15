//
//  Created by Evan DeLaney on 12/14/23.
//

import XCTest
@testable import BeReal_TS

final class UserTests: XCTestCase {

        override func setUpWithError() throws
        {
            try super.setUpWithError()
        }

        override func tearDownWithError() throws
        {
            try super.tearDownWithError()
        }

        func testDecodeExampleJSON() throws
        {
            let json = """
                    {
                       "firstName": "Evan",
                       "lastName": "DeLaney",
                       "rootItem": {
                           "id": "4b8e41fd4a6a89712f15bbf102421b9338cfab11",
                           "parentId": "",
                           "name": "dossierTest",
                           "isDir": true,
                           "modificationDate": "2021-11-29T10:57:13Z"
                       }
                    }
                    """.data(using: .utf8)!
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .apiFormat

            let user = try decoder.decode(User.self, from: json)

            XCTAssertEqual(user.firstName, "Evan")
            XCTAssertEqual(user.lastName, "DeLaney")
            XCTAssertEqual(user.rootItem.identifier, "4b8e41fd4a6a89712f15bbf102421b9338cfab11")
            XCTAssertEqual(user.rootItem.isDirectory, true)
            XCTAssertEqual(user.rootItem.name, "dossierTest")
        }
}
