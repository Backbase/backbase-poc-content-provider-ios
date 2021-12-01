//
//  DrupalPostClient.swift
//  CMSWhitePaper
//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import Foundation

public struct DrupalPostClient: CMSClient {
    private let dataClient: DataClient
    private let baseURLString = "http://localhost:8888/drupal-hello-world" // Replace with your own url

    public init(client: DataClient) {
        self.dataClient = client
    }

    public func loadItem(withID id: String, completion: @escaping (Result<CMSItem, Error>) -> Void) {
        guard let url = URL(string: baseURLString + "/jsonapi/node/article/\(id)?include=field_image_url") else {
            completion(.failure(ClientError.invalidUrl))
            return
        }

        dataClient.data(url: url, headers: nil) { result in
            let parsed: Result<DrupalPost, Error> = DataParser.parse(result)
            switch parsed {
            case .success(let post):
                let item = CMSItem(
                    id: post.data.id,
                    title: post.data.attributes.title,
                    content: post.data.attributes.fieldDescription,
                    imageUrl: "http://localhost:8888\(post.included?.first?.attributes.uri.url ?? "")")
                completion(.success(item))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    // MARK: - DrupalPost
    private struct DrupalPost: Codable {
        let data: DrupalPostData
        let included: [Included]?
    }

    // MARK: - DrupalPostData
    private struct DrupalPostData: Codable {
        let type, id: String
        let attributes: DataAttributes
    }

    // MARK: - DataAttributes
    private struct DataAttributes: Codable {
        let title: String
        let fieldDescription: String

        enum CodingKeys: String, CodingKey {
            case title
            case fieldDescription = "field_description"
        }
    }

    // MARK: - Included
    private struct Included: Codable {
        let type, id: String
        let attributes: IncludedAttributes
    }

    // MARK: - IncludedAttributes
    private struct IncludedAttributes: Codable {
        let uri: URI
    }

    // MARK: - URI
    private struct URI: Codable {
        let url: String
    }
}

extension DrupalPostClient: CMSListClient {
    public func loadItems(completion: @escaping (Result<[CMSItem], Error>) -> Void) {
        // Replace `post` in the url with whatever your custom content type is called!
        guard let url = URL(string: baseURLString + "/jsonapi/node/post?include=field_image_url") else {
            completion(.failure(ClientError.invalidUrl))
            return
        }

        dataClient.data(url: url, headers: nil) { result in
            let parsed: Result<DrupalPosts, Error> = DataParser.parse(result)
            switch parsed {
            case .success(let posts):
                var items = [CMSItem]()
                posts.data.enumerated().forEach { (index, data) in
                    let imageUrl = index < (posts.included?.count ?? 0) ? posts.included?[index].attributes.uri.url : ""
                    items.append(
                        CMSItem(
                            id: data.id,
                            title: data.attributes.title,
                            content: data.attributes.fieldDescription,
                            imageUrl: "http://localhost:8888\(imageUrl ?? "")")
                    )
                }
                completion(.success(items))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    private struct DrupalPosts: Decodable {
        let data: [DrupalPostData]
        let included: [Included]?
    }
}
