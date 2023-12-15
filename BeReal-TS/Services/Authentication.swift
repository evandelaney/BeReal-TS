//
//  Created by Evan DeLaney on 12/15/23.
//

import Foundation
import KeychainSwift

final class Authentication {
    
    private let keychain: KeychainSwift
    
    var username: String? {
        get {
            keychain.get("com.bereal.username")
        }
        set {
            if let newValue {
                keychain.set(newValue, forKey: "com.bereal.username")
            }
            else {
                keychain.delete("com.bereal.username")
            }
        }
    }
    
    var password: String? {
        get {
            keychain.get("com.bereal.password")
        }
        set {
            if let newValue {
                keychain.set(newValue, forKey: "com.bereal.password")
            }
            else {
                keychain.delete("com.bereal.password")
            }
        }
    }
    
    init(keychain: KeychainSwift = .init())
    {
        self.keychain = keychain
    }
}

extension Authentication: AuthorizationDelegate {
    
    func getBasicAuth() throws -> String
    {
        guard let username, let password else {
            throw NSError(domain: "com.bereal.authentication", code: 1001)
        }
        
        let loginString = String(format: "%@:%@", username, password)
        
        guard let loginData = loginString.data(using: .utf8) else {
            throw NSError(domain: "com.bereal.authentication", code: 1002)
        }
        
        let base64LoginString = loginData.base64EncodedString()

        return "Basic \(base64LoginString)"
    }
}
