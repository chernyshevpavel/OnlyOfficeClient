//
//  ProfileViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 10.04.2021.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelType
    private var profileModelSubscription: AnyCancellable?
    private var loadingProfileModelSubscription: AnyCancellable?
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = ""
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemRed
        btn.setTitle("Logout".localized(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.addTarget(self, action: #selector(logout(selector:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var logoutActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var loadingProfileActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - sizes fields
    private let imageSize: CGFloat
    private let topMargin: CGFloat
    private let generalStackSpace: CGFloat
    private let profileInfoPadding: CGFloat
    private let logoutBtnWidth: CGFloat
    
    // MARK: - init
    init(
        viewModel: ProfileViewModelType,
        imageSize: CGFloat = 80,
        topMargin: CGFloat = 60,
        generalStackSpace: CGFloat = 40,
        profileInfoPadding: CGFloat = 20,
        logoutBtnWidth: CGFloat = 150
    ) {
        self.viewModel = viewModel
        self.imageSize = imageSize
        self.topMargin = topMargin
        self.generalStackSpace = generalStackSpace
        self.profileInfoPadding = profileInfoPadding
        self.logoutBtnWidth = logoutBtnWidth
        
        super.init(nibName: nil, bundle: nil)
        
        profileModelSubscription = viewModel.profilePublisher.sink { [weak self] profile in
            guard let self = self else { return }
            self.photoView.image = profile.image
            self.nameLabel.text = profile.fullName
            self.emailLabel.text = profile.email
        }
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurateNavigationBar()
        setupConstraints()
        loadingProfileActivityIndicator.startAnimating()
        loadingProfileModelSubscription = viewModel.profilePublisher.sink(receiveValue: { [weak self] (model) in
            if !model.email.isEmpty {
                self?.loadingProfileActivityIndicator.stopAnimating()
            }
        })
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.loadProfile()
        }
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
    
        let profileInfoStack = UIStackView(arrangedSubviews: [photoView, nameLabel, emailLabel], axis: .vertical, spacing: 15)
        profileInfoStack.alignment = .center
        
        let generalStackView = UIStackView(arrangedSubviews: [profileInfoStack], axis: .vertical, spacing: generalStackSpace)
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        logoutActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(generalStackView)
        view.addSubview(logoutButton)
        view.addSubview(logoutActivityIndicator)
        view.addSubview(loadingProfileActivityIndicator)
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            emailLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            generalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: self.profileInfoPadding),
            generalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -self.profileInfoPadding)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: generalStackSpace),
            logoutButton.widthAnchor.constraint(equalToConstant: self.logoutBtnWidth),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logoutActivityIndicator.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor),
            logoutActivityIndicator.centerXAnchor.constraint(equalTo: logoutButton.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingProfileActivityIndicator.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            loadingProfileActivityIndicator.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor)
        ])
    }
    // MARK: - button actions
    @objc func logout(selector: UIButton) {
        startLoggoutLoadingAnimation()
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.logout { viewController in
                DispatchQueue.main.async {
                    self.stopLoggoutLoadingAnimation()
                    self.view.window?.rootViewController = viewController
                }
            }
        }
    }
    
    // MARK: - NavigationBar configure
    private func configurateNavigationBar() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.topItem?.title = "Profile".localized()
            navigationController.navigationBar.backgroundColor = .secondarySystemBackground
            let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = .secondarySystemBackground
            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController.navigationBar.prefersLargeTitles = true
        }
    }
    
    // MARK: - Loading animation
    private func startLoggoutLoadingAnimation() {
        logoutButton.alpha = 0.5
        logoutButton.isEnabled = false
        logoutActivityIndicator.startAnimating()
    }
    
    private func stopLoggoutLoadingAnimation() {
        logoutButton.alpha = 1
        logoutButton.isEnabled = true
        logoutActivityIndicator.stopAnimating()
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
            let portalStorage = PortalAddressStorageUserDafaults()
            let tokenStorage = TokenStorageUserDefaults()
            let requestFactory = RequestFactory(portalAdressStorage: portalStorage, tokenStorage: tokenStorage)
            self.viewController = ProfileViewController(viewModel: ProfileViewModel(
                                                            requestFactory: requestFactory,
                                                            portalAddressStorage: portalStorage,
                                                            tokenStorage: tokenStorage,
                                                            logger: NothingLogger()))
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
