//
//  DocumentsTableViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit

class DocumentsViewController: UIViewController {
    
    let reuseIdentifier = "document"
    private let tableView = UITableView()
    
    // MARK: - init
    init() {
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
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
}

// MARK: - Table view data source
extension DocumentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DocumentCellViewType else { fatalError() }
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
            self.viewController = DocumentsViewController()
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

