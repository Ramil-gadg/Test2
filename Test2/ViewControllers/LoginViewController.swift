//
//  ViewController.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var user: UserModel?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        return scrollView
    }()
    
    var appleLogo: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "appleLogo")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emailLabel = UILabel(text: "Введите адрес электронной почты")
    let passwordLabel = UILabel(text: "Введите пароль")
    let emailTF = UITextField(placeholder: "Адрес электронной почты", isPassword: false)
    let passwordTF = UITextField(placeholder: "Пароль", isPassword: true)
    let loginButton = UIButton(title: "Авторизация", hasBackgroundColor: true)
    let registrButton = UIButton(title: "Зарегистрироваться", hasBackgroundColor: false)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailTF.delegate = self
        passwordTF.delegate = self
        setupUI()
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        registrButton.addTarget(self, action: #selector(showRegistrationVC), for: .touchUpInside)
    }
    
    @objc func showRegistrationVC () {
        let vc = RegistrationViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    @objc func loginUser () {
        let textFields = [emailTF, passwordTF]
        let placeholders = ["Адрес электронной почты", "Пароль"]
        
        guard let email = emailTF.text, email != "",
              let password = passwordTF.text, password != ""  else {
            
            for (textField, placeholder)  in zip(textFields, placeholders) {
                if textField.text == "" || textField.text == nil {
                    textField.fillTextField(placeholder: placeholder)
                }
            }
            return
        }
        
        guard Validators.isValidEmail(emailID: email) else {
            let alert = UIAlertController.showAlert(title: "Ошибка", message: "Укажите корректный адрес электронной почты")
            present(alert, animated: true, completion: nil)
            return
        }
        
        let userData: [String: String] = ["email": email, "password" : password]
        
        NetworkManager.shared.checkLogin(userToLogin: userData) { [weak self] user, error in
            if let error = error {
                let alert = UIAlertController.showAlert(title: "Ошибка", message: error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            guard let user = user else { return }
            DispatchQueue.main.async {
                let profileVC = ProfileViewController(currentUser: user)
                profileVC.modalPresentationStyle = .fullScreen
                self?.show(profileVC, sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - setup UI

extension LoginViewController {
    
    private func setupUI() {
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        
        let emailStack = UIStackView(firstView: emailLabel, secondView: emailTF, spacing: 10)
        let passwordStack = UIStackView(firstView: passwordLabel, secondView: passwordTF, spacing: 10)
        let generalStack = UIStackView(firstView: emailStack, secondView: passwordStack, spacing: 30)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        generalStack.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registrButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(appleLogo)
        scrollView.addSubview(generalStack)
        view.addSubview(loginButton)
        view.addSubview(registrButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            appleLogo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.height/13),
            appleLogo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            appleLogo.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25),
            appleLogo.heightAnchor.constraint(equalTo: appleLogo.widthAnchor),
            
            generalStack.topAnchor.constraint(equalTo: appleLogo.bottomAnchor, constant: view.frame.height/20),
            generalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: generalStack.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registrButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registrButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            registrButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 80),
            registrButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -80)
        ])
    }
}

//MARK: - ShowLoginVC Protocol

extension LoginViewController: ShowLoginVC {
    func toLoginVC(user: UserModel) {
        self.user = user
        self.emailTF.text = user.email
        self.passwordTF.text = user.password
        let representation: [String: String] = ["email": user.email!, "password" : user.password!]
        
        NetworkManager.shared.checkLogin(userToLogin: representation) {[weak self] user, error in
            if let error = error {
                let alert = UIAlertController.showAlert(title: "Ошибка", message: error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            guard let user = user else { return }
            DispatchQueue.main.async {
                let profileVC = ProfileViewController(currentUser: user)
                profileVC.modalPresentationStyle = .fullScreen
                self?.show(profileVC, sender: nil)
            }
        }
    }
}


//MARK: - work with keyBoard appearence

extension LoginViewController {
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbFrameSize.height, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    @objc func kbDidHide() {
        UIView.animate(withDuration: 0) {
            
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

