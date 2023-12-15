//
//  Created by Evan DeLaney on 12/14/23.
//

import XCTest
@testable import BeReal_TS

final class ItemsResponseTests: XCTestCase {
    
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
        let json =
"""
[
  {
    "id": "a8537d631d21a8b7fdbbcd11e4d2e5d09d61971d",
    "isDir": true,
    "modificationDate": "2023-11-02T15:14:17.945308005Z",
    "name": "Documents",
    "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7"
  },
  {
    "contentType": "image/jpg",
    "id": "e788eb7b65f4f16cbfac9e50cbec7c01c1fb6e61",
    "isDir": false,
    "modificationDate": "2023-12-04T15:28:12.221306486Z",
    "name": "picture.jpg",
    "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7",
    "size": 164568
  },
  {
    "contentType": "text/plain",
    "id": "bbb146a0d63a83c9a2903dd2e25c2db9b6429163",
    "isDir": false,
    "modificationDate": "2023-12-13T18:10:19.990876957Z",
    "name": "README.txt",
    "parentId": "ec94bd0365b352832710f171bd8463b6d9caf6e7",
    "size": 475
  }
]
""".data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.apiDateFormatter)
        let response = try decoder.decode(ItemsResponse.self, from: json)
        
        XCTAssertEqual(response.items.count, 3)
    }
    
    func testFoldersFiltersItems() throws
    {
        let folder1 = Folder.make(identifier: "unit-test-1")
        let folder2 = Folder.make(identifier: "unit-test-2")
        let response = ItemsResponse(items: [
            folder1, folder2,
            File.make(identifier: "unit-test-1"),
            File.make(identifier: "unit-test-2"),
            File.make(identifier: "unit-test-3"),
        ])
        
        XCTAssertEqual(response.folders, [ folder1, folder2 ])
    }
    
    func testFilesFiltersItems() throws
    {
        let file1 = File.make(identifier: "unit-test-1")
        let file2 = File.make(identifier: "unit-test-2")
        let file3 = File.make(identifier: "unit-test-3")
        let response = ItemsResponse(items: [
            Folder.make(identifier: "unit-test-1"),
            Folder.make(identifier: "unit-test-2"),
            file1, file2, file3,
        ])
        
        XCTAssertEqual(response.files, [ file1, file2, file3 ])
    }
}

