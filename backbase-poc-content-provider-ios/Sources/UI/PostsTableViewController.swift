//
//  PostsTableViewController.swift
//  CMSWhitePaper
//
//  Created by Aly Yakan on 01/12/2021.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    static let identifier = "PostsTableViewCell"
    @IBOutlet private(set) var titleLabel: UILabel?
    @IBOutlet private(set) var descriptionLabel: UILabel?
    @IBOutlet private(set) var customImageView: UIImageView?
}

class PostsTableViewController: UITableViewController {
    private let apiClient = ApiClient()
    private var viewModel: PostsViewModel?
    private var items: [CMSItem] = []
    private var selectedItem: CMSItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Ideally this would be passed as a dependency to the view controller.
        viewModel = PostsViewModel(cmsClient: DrupalPostClient(client: apiClient), apiClient: apiClient)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < items.count,
              let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier) as? PostsTableViewCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.titleLabel?.text = item.title
        cell.descriptionLabel?.text = item.content

        if cell.imageView?.image == nil {
            viewModel?.uiimage(for: item, completion: { [weak self] image in
                guard self != nil else { return }

                DispatchQueue.main.async {
                    cell.customImageView?.image = image
                }
            })
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        performSegue(withIdentifier: "showPostDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? PostViewController else { return }

        destination.viewModel = PostViewModel(cmsClient: DrupalPostClient(client: apiClient), apiClient: apiClient)
        destination.itemID = selectedItem?.id
    }

    @IBAction func didTapRefreshButton(_ sender: Any) {
        items = []
        tableView.reloadData()
        load()
    }

    private func load() {
        viewModel?.loadItems(completion: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                self.items = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
