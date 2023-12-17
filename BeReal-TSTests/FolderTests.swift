//
//  Created by Evan DeLaney on 12/14/23.
//

import XCTest
@testable import BeReal_TS

final class FolderTests: XCTestCase {
    
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
                       "id": "a8537d631d21a8b7fdbbcd11e4d2e5d09d61971d",
                       "isDir": true,
                       "modificationDate": "2023-12-06T14:05:45.624856899Z",
                       "name": "Documents",
                       "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7"
                   }
                   """.data(using: .utf8)!
        
        let folder = try decoder.decode(Folder.self, from: json)

        XCTAssertEqual(folder.identifier, "a8537d631d21a8b7fdbbcd11e4d2e5d09d61971d")
        XCTAssertEqual(folder.parent?.rawValue, "ec94bd0365b352832710f171bd8463b6d9caf6e7")
        XCTAssertEqual(folder.name, "Documents")
    }
    
    func testWillNotDecodeFileJSON() throws
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
        
        do {
            _ = try decoder.decode(Folder.self, from: json)
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
        let folder = Folder.make(identifier: "UNIT TEST")
        
        XCTAssertEqual(folder.iconName, "folder")
    }
    
    func testExpectedSubheadline()
    {
        let folder = Folder.make(identifier: "UNIT TEST", modified: .goodDate)
        
        XCTAssertEqual(
            folder.localizedSubheadline(with: .unitTest),
            "10/8/11"
        )
    }
}
