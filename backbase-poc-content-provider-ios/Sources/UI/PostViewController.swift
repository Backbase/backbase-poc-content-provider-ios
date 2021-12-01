//
//  ViewController.swift
//  backbase-poc-content-provider-ios
//
// Copyright © 2021 Backbase R&D B.V. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var descriptionLabel: UILabel?
    @IBOutlet private var customImageView: UIImageView?

    var itemID: String?
    var item: CMSItem? {
        didSet {
            titleLabel?.text = item?.title
            descriptionLabel?.text = item?.content
        }
    }
    var image: UIImage?
    var viewModel: PostViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Post"

        if let id = itemID {
            viewModel?.loadItem(withID: id, completion: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.item = item
                    }
                    self.viewModel?.uiimage(for: item, completion: { image in
                        DispatchQueue.main.async {
                            self.customImageView?.image = image
                        }
                    })
                case .failure(let error): print(error)
                }
            })
        }
    }
}
