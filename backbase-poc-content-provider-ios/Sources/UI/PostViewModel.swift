//
//  PostViewModel.swift
//  backbase-poc-content-provider-ios
//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import UIKit

struct PostViewModel {
    private let cmsClient: CMSClient
    private let apiClient: ApiClient

    init(cmsClient: CMSClient, apiClient: ApiClient) {
        self.cmsClient = cmsClient
        self.apiClient = apiClient
    }

    func loadItem(withID id: String, completion: @escaping (Swift.Result<CMSItem, Error>) -> Void) {
        cmsClient.loadItem(withID: id, completion: completion)
    }

    func uiimage(for item: CMSItem, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = item.imageUrl, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        apiClient.uiimage(from: url) {result in
            switch result {
            case .success(let image): completion(image)
            case .failure: completion(nil)
            }
        }
    }
}
