//
//  Created by Evan DeLaney on 12/14/23.
//

import Foundation

protocol URLSessionAsync {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionAsync { }

protocol AuthorizationDelegate: AnyObject {
    func getBasicAuth() throws -> String
}

final class APIClient {
    
    let hostname: String
    let urlSession: URLSessionAsync
    let decoder: JSONDecoder
    weak var authorizationDelegate: AuthorizationDelegate?
    
    init(hostname: String, urlSession: URLSessionAsync, decoder: JSONDecoder = .init())
    {
        self.hostname = hostname
        self.urlSession = urlSession
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .apiFormat
    }
    
    private func makeRequest(with endpoint: String, httpMethod: String = "GET") async throws -> (Data, URLResponse)
    {
        guard let authorizationDelegate else { throw NSError(domain: "com.bereal.apiclient" , code: 4001) }
        let basicAuth = try authorizationDelegate.getBasicAuth()
        
        var request = URLRequest(url: URL(string: "http://\(hostname)/\(endpoint)")!)
        request.httpMethod = httpMethod
        request.setValue(basicAuth, forHTTPHeaderField: "Authorization")
        
        return try await urlSession.data(for: request, delegate: nil)
    }
    
    private func decode<T>(from result: (Data, URLResponse)) throws -> T where T: Decodable
    {
        let (data, _) = result
        return try decoder.decode(T.self, from: data)
    }
    
    func getMe() async throws -> User
    {
        try decode(from:
                    try await makeRequest(with: "me")
        )
    }
    
    func getItems(at folder: Folder) async throws -> [ any Item ]
    {
        try (decode(from:
                        try await makeRequest(with: "items/\(folder.identifier)")
                   ) as ItemsResponse).items
    }
    
    func delete(item: any Item) async throws -> Bool
    {
        let (_, response) = try await makeRequest(with: "items/\(item.identifier)", httpMethod: "DELETE")
        guard let response = response as? HTTPURLResponse else { return false }
        
        return response.statusCode == 204
    }
    
    func getData(for file: File) async throws -> Data
    {
        try await makeRequest(with: "items/\(file.identifier)/data").0
    }

    func upload(data: Data, filename: String, to folder: Folder) async throws -> File
    {
        guard let authorizationDelegate else { throw NSError(domain: "com.bereal.apiclient" , code: 4001) }
        let basicAuth = try authorizationDelegate.getBasicAuth()
        
        var request = URLRequest(url: URL(string: "http://\(hostname)/items/\(folder.identifier)")!)
        request.httpMethod = "POST"
        
        request.setValue(basicAuth, forHTTPHeaderField: "Authorization")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("attachment;filename*=utf-8''\(filename)", forHTTPHeaderField: "Content-Disposition")
        
        request.httpBody = data
        
        let (data, _) = try await urlSession.data(for: request, delegate: nil)
        return try decoder.decode(File.self, from: data)
    }
}
