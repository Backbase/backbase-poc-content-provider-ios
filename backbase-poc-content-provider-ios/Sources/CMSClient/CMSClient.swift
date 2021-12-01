//
//  CMSClient.swift
//  CMSWhitePaper
//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import Foundation

public struct CMSItem: Identifiable {
    public var id: String
    public var title: String?
    public var content: String?
    public var imageUrl: String?
}

public protocol CMSClient {
    func loadItem(withID id: String, completion: @escaping (Swift.Result<CMSItem, Error>) -> Void)
}

public protocol CMSListClient {
    func loadItems(completion: @escaping (Swift.Result<[CMSItem], Error>) -> Void)
}
