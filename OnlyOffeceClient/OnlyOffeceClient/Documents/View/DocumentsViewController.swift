//
//  DocumentsTableViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit
import Combine

class DocumentsViewController: UIViewController {
    private let documentInteractionController = UIDocumentInteractionController()
    private let viewModel: DocumentsViewModelType
    private var currentlyLoadingSubscription: AnyCancellable?
    
    let reuseIdentifier = "document"
    private let tableView = UITableView()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var requestFactory: RequestFactory
    // MARK: - init
    init(viewModel: DocumentsViewModelType, requestFactory: RequestFactory) {
        self.viewModel = viewModel
        self.requestFactory = requestFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        documentInteractionController.delegate = self
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
    
    // MARK: - Alert
    func showErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(
            title: "Error".localized(),
            message: message,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
                                    title: "OK".localized(),
                                    style: .default))
        self.present(alertController, animated: true, completion: nil)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DocumentCellViewType else {
            fatalError("Couldn't cast cell with id \(reuseIdentifier) to DocumentCellViewType")
        }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - Table view delegate
extension DocumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRow(forIdexPath: indexPath)
        
        guard openFolder(indexPath: indexPath) == false else {
            return
        }
        
        onpenDocument()
    }
    
    private func openFolder(indexPath: IndexPath) -> Bool {
        guard let documentsViewModel = viewModel.viewModelForSelectedRow() else {
            return false
        }
        let viewController = DocumentsViewController(viewModel: documentsViewModel, requestFactory: requestFactory)
        if let cell = viewModel.cellViewModel(forIndexPath: indexPath) {
            viewController.title = cell.title
        }
        self.navigationController?.pushViewController(viewController, animated: false)
        return true
    }
    
    private func onpenDocument() {
        viewModel.storeDocumentForSelectedRow { (url, errorMessage) in
            guard let url = url else {
                if let errorMessage = errorMessage {
                    DispatchQueue.main.async {
                        self.showErrorAlert(withMessage: errorMessage)
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self.share(url: url)
            }
        }
    }
}

// MARK: - UIDocumentInteractionControllerDelegate
extension DocumentsViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension DocumentsViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
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
                                                            logger: NothingLogger()),
                                                          requestFactory: RequestFactory(portalAdressStorage: PortalAddressStorageUserDafaults(), tokenStorage: TokenStorageUserDefaults()))
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
