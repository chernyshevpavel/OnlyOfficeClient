//
//  AuthViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 09.04.2021.
//

import UIKit
import Combine

class AuthViewController: UIViewController {
    
    // MARK: - View elements
    private lazy var welocomeLabel = labelBuilder(text: "Welcom back")
    private lazy var titleLabel: UILabel = {
        let label = labelBuilder(text: "Login to ONLYOFFICE")
        label.font = UIFont.boldSystemFont(ofSize: 26)
        
        return label
    }()
    
    private lazy var portalInputLabel = labelBuilder(text: "Portal")
    private lazy var portalInput = inputBuilder(placeholder: "personal.onlyoffice.com", contentType: .URL)
    
    private lazy var emailInputLabel = labelBuilder(text: "Email")
    private lazy var emailInput = inputBuilder(placeholder: "user@email.com", contentType: .emailAddress)
    
    private lazy var passwordInputLabel = labelBuilder(text: "Password")
    private lazy var passwordInput = inputBuilder(placeholder: "Your password", contentType: .emailAddress)
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("Login now", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    private let scrollView = UIScrollView()
    private let generalStackView = UIStackView()
    
    // MARK: - sizes fields
    private let leftMargin: CGFloat
    private let rightMargin: CGFloat
    private let groupStacksSpacing: CGFloat
    
    // MARK: - init
    init(
        leftMargin: CGFloat = 20,
        rightMargin: CGFloat = 20,
        groupStacksSpacing: CGFloat = 40
    ) {
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.groupStacksSpacing = groupStacksSpacing
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupConstraints()
    }
    
    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard handlers
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo = sender.userInfo
        
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let bottomFreeSpace = (UIScreen.main.bounds.height - generalStackView.frame.height) / 2 - 20
        
        guard let keyboardSizeUnwraped = keyboardSize, keyboardSizeUnwraped.height > bottomFreeSpace else {
            return
        }
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardSizeUnwraped.height - bottomFreeSpace)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    // MARK: - Interface element builders
    private func labelBuilder(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString(text, comment: "")
        return label
    }
    
    private func inputBuilder(placeholder: String, contentType: UITextContentType) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.placeholder = NSLocalizedString(placeholder, comment: "")
        textField.textContentType = contentType
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 4
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        
        return textField
    }
    
    // MARK: - Set constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        scrollView.frame = view.frame
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let welcomeStackView = UIStackView(arrangedSubviews: [welocomeLabel, titleLabel], axis: .vertical, spacing: 10)
        
        let portalStackView = UIStackView(arrangedSubviews: [portalInputLabel, portalInput], axis: .vertical, spacing: 5)
        let emailStackView = UIStackView(arrangedSubviews: [emailInputLabel, emailInput], axis: .vertical, spacing: 5)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordInputLabel, passwordInput], axis: .vertical, spacing: 5)
        
        let inputStackView = UIStackView(arrangedSubviews: [portalStackView, emailStackView, passwordStackView], axis: .vertical, spacing: 15)
        
        generalStackView.addArrangedSubview(welcomeStackView)
        generalStackView.addArrangedSubview(inputStackView)
        generalStackView.addArrangedSubview(loginButton)
        generalStackView.axis = .vertical
        generalStackView.spacing = groupStacksSpacing
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(generalStackView)
        
        NSLayoutConstraint.activate([
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftMargin),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightMargin),
            generalStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - SwiftUI for preview
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController: AuthViewController
        init() {
            self.viewController = AuthViewController()
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) -> AuthViewController {
            viewController
        }
        
        func updateUIViewController(
            _ uiViewController: AuthViewControllerProvider.ContainerView.UIViewControllerType,
            context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>
        ) {
        }
    }
}
