//
//  AuthViewController.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 09.04.2021.
//

import UIKit
import Combine

class AuthViewController: UIViewController {
    
    let viewModel: AuthViewModelType
    let succesAuthViewController: UIViewController
    
    // MARK: - View elements
    private lazy var welocomeLabel = labelBuilder(text: "Welcom back")
    private lazy var titleLabel: UILabel = {
        let label = labelBuilder(text: "Login to ONLYOFFICE")
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    private lazy var portalInputLabel = labelBuilder(text: "Portal")
    private lazy var portalInput = inputBuilder(placeholder: "personal.onlyoffice.com", contentType: .URL, keyboardType: .URL)
    
    private lazy var emailInputLabel = labelBuilder(text: "Email")
    private lazy var emailInput = inputBuilder(placeholder: "user@email.com", contentType: .emailAddress, keyboardType: .emailAddress)
    
    private lazy var passwordInputLabel = labelBuilder(text: "Password")
    private lazy var passwordInput = inputBuilder(placeholder: "Your password", contentType: .password)
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("Login now", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 4
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.addTarget(self, action: #selector(loginAction(selector:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let scrollView = UIScrollView()
    private let generalStackView = UIStackView()
    
    private let baseInputColor = UIColor.lightGray.cgColor
    private let errorInputColor = UIColor.systemRed.cgColor
    
    // MARK: - sizes fields
    private let leftMargin: CGFloat
    private let rightMargin: CGFloat
    private let groupStacksSpacing: CGFloat
    
    // MARK: - init
    init(
        viewModel: AuthViewModelType,
        succesAuthViewController: UIViewController,
        leftMargin: CGFloat = 20,
        rightMargin: CGFloat = 20,
        groupStacksSpacing: CGFloat = 40
    ) {
        self.viewModel = viewModel
        self.succesAuthViewController = succesAuthViewController
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
        let bottomFreeSpace = (UIScreen.main.bounds.height - view.safeAreaInsets.top - generalStackView.frame.height) / 2  - 20
        
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
    
    private func inputBuilder(placeholder: String, contentType: UITextContentType, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.placeholder = NSLocalizedString(placeholder, comment: "")
        textField.autocapitalizationType = .none
        textField.textContentType = contentType
        textField.isSecureTextEntry = contentType == .password
        textField.keyboardType = keyboardType
        textField.layer.borderWidth = 1
        textField.layer.borderColor = baseInputColor
        textField.layer.cornerRadius = 4
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        
        return textField
    }
    
    // MARK: - Setup constraints
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
        view.addSubview(activityIndicator)
        scrollView.addSubview(generalStackView)
        
        NSLayoutConstraint.activate([
            generalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            generalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            generalStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)
        ])
    }
    
    // MARK: - button actions
    @objc func loginAction(selector: UIButton) {
        if validate() {
            guard let portal = portalInput.text, let email = emailInput.text, let password = passwordInput.text else {
                showErrorAlert(withMessage: NSLocalizedString("Some fields are empty", comment: ""))
                return
            }
            startLoadingAnimation()
            DispatchQueue.global(qos: .userInitiated).async {
                self.viewModel.login(portal: portal, email: email, password: password) { (success, errorMessage) in
                    
                    DispatchQueue.main.async {
                        self.stopLoadingAnimation()
                        guard success == true else {
                            self.showErrorAlert(withMessage: errorMessage ?? NSLocalizedString("Somthig wrong", comment: ""))
                            return
                        }
                        self.view.window?.rootViewController = self.succesAuthViewController
                    }
                }
            }
        }
    }
    
    // MARK: - Validate text fields
    func validate() -> Bool {
        let validatorProviders: [(UITextField, ValidatorType)] = [
            (portalInput, .url),
            (emailInput, .email),
            (passwordInput, .requiredField(field: passwordInput.placeholder ?? "Password"))
        ]
        
        for (input, validationType) in validatorProviders {
            do {
                input.layer.borderColor = baseInputColor
                let _ = try input.validatedText(validationType: validationType)
            } catch (let error) {
                input.layer.borderColor = errorInputColor
                if let validateError = error as? ValidationError {
                    showErrorAlert(withMessage: validateError.message)
                }
                return false
            }
        }
        return true
    }
    
    // MARK: - Alert
    func showErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: message,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
                                    title: NSLocalizedString("OK", comment: "Default action"),
                                    style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading animation
    private func startLoadingAnimation() {
        loginButton.alpha = 0.5
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    private func stopLoadingAnimation() {
        loginButton.alpha = 1
        loginButton.isEnabled = true
        activityIndicator.stopAnimating()
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
            let portalAdressStorage = PortalAddressStorageUserDafaults()
            let tokenStorage = TokenStorageUserDefaults()
            let requestFactory = RequestFactory(portalAdressStorage: portalAdressStorage, tokenStorage: tokenStorage)
            
            let viewController = AuthViewController(viewModel: AuthViewModel(
                                                        portalAddressStorage: portalAdressStorage,
                                                        tokenStorage: tokenStorage,
                                                        requestFactory: requestFactory,
                                                        errorParser: ErrorParsersChain(errorParsers: [ErrorParserState<BaseErrorResponse>(), ErrorParserState()])), succesAuthViewController: UIViewController());
            self.viewController = viewController
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
