//
//  PostsViewModel.swift
//  CMSWhitePaper
//
//  Created by Aly Yakan on 01/12/2021.
//

import UIKit

struct PostsViewModel {
    private let cmsClient: CMSListClient
    private let apiClient: ApiClient

    init(cmsClient: CMSListClient, apiClient: ApiClient) {
        self.cmsClient = cmsClient
        self.apiClient = apiClient
    }

    func loadItems(completion: @escaping (Swift.Result<[CMSItem], Error>) -> Void) {
        cmsClient.loadItems(completion: completion)
    }

    func uiimage(for item: CMSItem, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = item.imageUrl, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        apiClient.uiimage(from: url) { result in
            switch result {
            case .success(let image): completion(image)
            case .failure: completion(nil)
            }
        }
    }
}

extension ApiClient {
    func uiimage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        data(url: url) { result in
            switch result {
            case.success(let data): completion(.success(UIImage(data: data)))
            case .failure(_): print("Failed to complete image fetching.")
            }
        }
    }
}
