//
//  DocumentsTableViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit
import Combine

class DocumentsViewController: UIViewController {
    
    private let viewModel: DocumentsViewModelType
    private var currentlyLoadingSubscription: AnyCancellable?
    
    let reuseIdentifier = "document"
    private let tableView = UITableView()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - init
    init(viewModel: DocumentsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateNavigationBar()
        tableView.dataSource = self
        tableView.delegate = self
        setupConstraints()
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.load()
        }
        self.currentlyLoadingSubscription = viewModel.currentlyLoadingPublisher.sink(receiveValue: { [weak self] currentlyLoading in
            guard let self = self else { return }
            if currentlyLoading {
                self.startLoadingAnimation()
            } else {
                self.tableView.reloadData()
                self.stopLoadingAnimation()
            }
        })
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - NavigationBar configure
    private func configurateNavigationBar() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.backgroundColor = .secondarySystemBackground
            let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = .secondarySystemBackground
            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController.navigationBar.prefersLargeTitles = true
        }
    }
    
    // MARK: - loading animation
    private func startLoadingAnimation() {
        loadingIndicator.startAnimating()
        tableView.alpha = 0.4
    }
    
    private func stopLoadingAnimation() {
        loadingIndicator.stopAnimating()
        tableView.alpha = 1
    }
}

// MARK: - Table view data source
extension DocumentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DocumentCellViewType else { fatalError() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - Table view delegate
extension DocumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - SwiftUI for preview
import SwiftUI

struct DocumentsViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController: DocumentsViewController
        init() {
            self.viewController = DocumentsViewController(viewModel: DocumentsViewModel(
                                                            documentsType: .my,
                                                            requestFactory: RequestFactory(portalAdressStorage: PortalAddressStorageUserDafaults(), tokenStorage: TokenStorageUserDefaults()),
                                                            errorParser: ErrorParser(),
                                                            logger: NothingLogger()))
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentsViewControllerProvider.ContainerView>) -> DocumentsViewController {
            viewController
        }
        
        func updateUIViewController(
            _ uiViewController: DocumentsViewControllerProvider.ContainerView.UIViewControllerType,
            context: UIViewControllerRepresentableContext<DocumentsViewControllerProvider.ContainerView>
        ) {
        }
    }
}

