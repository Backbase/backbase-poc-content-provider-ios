//
//  DataParser.swift
//  backbase-poc-content-provider-ios
//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import Foundation

public struct DataParser {
    public static func parse<T: Decodable>(_ result: Result<Data, Error>) -> Result<T, Error> {
        switch result {
        case .success(let data):
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return .success(object)
            } catch {
                return .failure(error)
            }
        case .failure(let error): return .failure(error)
        }
    }
}
