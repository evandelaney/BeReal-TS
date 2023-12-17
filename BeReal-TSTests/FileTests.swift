//
//  Created by Evan DeLaney on 12/14/23.
//

import XCTest
@testable import BeReal_TS

final class FileTests: XCTestCase {

    private var decoder: JSONDecoder!
    
    override func setUpWithError() throws
    {
        try super.setUpWithError()
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .apiFormat
    }

    override func tearDownWithError() throws
    {
        decoder = nil
        
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
        
        let file = try decoder.decode(File.self, from: json)

        XCTAssertEqual(file.identifier, "e788eb7b65f4f16cbfac9e50cbec7c01c1fb6e61")
        XCTAssertEqual(file.parent?.rawValue, "ec94bd0365b352832710f171bd8463b6d9caf6e7")
        XCTAssertEqual(file.name, "picture.jpg")
        XCTAssertEqual(file.size, 164568)
        XCTAssertEqual(file.contentType, "image/jpg")
    }
    
    func testWillNotDecodeFolderJSON() throws
    {
        let json = """
                   {
                       "id": "a8537d631d21a8b7fdbbcd11e4d2e5d09d61971d",
                       "isDir": true,
                       "modificationDate": "2023-12-06T14:05:45.624856899Z",
                       "name": "Documents",
                       "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7"
                   }
                   """.data(using: .utf8)!
        
        do {
            _ = try decoder.decode(File.self, from: json)
        }
        catch {
            XCTAssertNotNil(error)
            return
        }
        
        XCTFail()
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
        let file = File.make(identifier: "UNIT TEST", modified: .goodDate)
        
        XCTAssertEqual(
            file.localizedSubheadline(with: .unitTest),
            "10/8/11"
        )
    }
}
