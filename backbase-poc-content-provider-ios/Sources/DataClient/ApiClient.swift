//
//  ApiClient.swift
//  backbase-poc-content-provider-ios
//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import Foundation

public class ApiClient: DataClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func data(url: URL, headers: [String: String]? = nil, _ completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)

        if let headers = headers {
            for (key, val) in headers {
                request.addValue(val, forHTTPHeaderField: key)
            }
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:::\(error)")
                completion(.failure(error))
                return
            }

            if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode != 200 {
                print("Error:::Received an invalid status Code \(httpResponse.statusCode)")
                completion(.failure(ClientError.invalidStatusCode))
                return
            }

            guard let data = data else {
                print("Error:::Couldn't find data")
                completion(.failure(ClientError.missingData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}

public enum ClientError: Error {
    case invalidUrl
    case missingData
    case invalidStatusCode
}
