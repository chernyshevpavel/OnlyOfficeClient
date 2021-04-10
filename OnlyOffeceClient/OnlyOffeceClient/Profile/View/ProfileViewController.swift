//
//  ProfileViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 10.04.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - View elements
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "Name"
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemRed
        btn.setTitle(NSLocalizedString("Logout", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 130).isActive = true
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return btn
    }()
    
    // MARK: - sizes fields
    private let imageSize: CGFloat
    private let topMargin: CGFloat
    private let generalStackSpace: CGFloat
    
    // MARK: - init
    init(
        imageSize: CGFloat = 80,
        topMargin: CGFloat = 60,
        generalStackSpace: CGFloat = 40
    ) {
        self.imageSize = imageSize
        self.topMargin = topMargin
        self.generalStackSpace = generalStackSpace
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurateNavigationBar()
        setupConstraints()
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
    
        let profileInfoStack = UIStackView(arrangedSubviews: [photoView, nameLabel, emailLabel], axis: .vertical, spacing: 15)
        profileInfoStack.alignment = .center
        
        let generalStackView = UIStackView(arrangedSubviews: [profileInfoStack, logoutButton], axis: .vertical, spacing: generalStackSpace)
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(generalStackView)
        
        NSLayoutConstraint.activate([
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            generalStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    // MARK: - NavigationBar configure
    private func configurateNavigationBar() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.topItem?.title = NSLocalizedString("Profile", comment: "")
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

// MARK: - SwiftUI for preview
import SwiftUI

struct ProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController: ProfileViewController
        init() {
            self.viewController = ProfileViewController()
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileViewControllerProvider.ContainerView>) -> ProfileViewController {
            viewController
        }
        
        func updateUIViewController(
            _ uiViewController: ProfileViewControllerProvider.ContainerView.UIViewControllerType,
            context: UIViewControllerRepresentableContext<ProfileViewControllerProvider.ContainerView>
        ) {
        }
    }
}

