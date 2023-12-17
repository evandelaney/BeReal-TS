//
//  Created by Evan DeLaney on 12/14/23.
//

import XCTest
@testable import BeReal_TS

final class FileTests: XCTestCase {

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
                     "contentType": "image/jpg",
                     "id": "e788eb7b65f4f16cbfac9e50cbec7c01c1fb6e61",
                     "isDir": false,
                     "modificationDate": "2023-12-11T12:13:28.382193563Z",
                     "name": "picture.jpg",
                     "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7",
                     "size": 164568
                   }
                   """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .apiFormat
        
        let file = try decoder.decode(File.self, from: json)

        XCTAssertEqual(file.identifier, "e788eb7b65f4f16cbfac9e50cbec7c01c1fb6e61")
        XCTAssertEqual(file.parent?.rawValue, "ec94bd0365b352832710f171bd8463b6d9caf6e7")
        XCTAssertEqual(file.isDirectory, false)
        XCTAssertEqual(file.name, "picture.jpg")
        XCTAssertEqual(file.size, 164568)
        XCTAssertEqual(file.contentType, "image/jpg")
    }
    
    // Item Displayable
    
    func testExepctedIconName()
    {
        let file = File.make(identifier: "UNIT TEST")
        
        XCTAssertEqual(file.iconName, "doc")
    }
    
    func testExpectedHeadline()
    {
        let file = File.make(identifier: "UNIT TEST")
        
        XCTAssertEqual(file.localizedHeadline, "Test File")
    }
    
    func testExpectedSubheadline()
    {
        let date = Date(timeIntervalSince1970: 1318106700)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        let file = File.make(identifier: "UNIT TEST", modified: date)
        
        XCTAssertEqual(
            file.localizedSubheadline(with: formatter),
            "10/8/11"
        )
    }
}
