//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import Foundation

public protocol DataClient {
    func data(url: URL, headers: [String: String]?, _ completion: @escaping (Result<Data, Error>) -> Void)
}
