//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    
    static let apiFormat: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        
        if let parsed = DateFormatter.apiDateFormatter.date(from: rawString) {
            return parsed
        }
        else if let parsed = DateFormatter.iso8601Formatter.date(from: rawString) {
            return parsed
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode \(rawString)")
        }
    }
}
