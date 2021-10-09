//
//  RegistrationViewController.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import UIKit

protocol ShowLoginVC: AnyObject{
    func toLoginVC(user: UserModel)
}

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    var user: UserModel?
    weak var delegate: ShowLoginVC?
    
    var multiplier:CGFloat = 1
    
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
    
    let cancelButton: UIButton = {
        var button = UIButton(type: .system)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.setImage(UIImage(named: "cancelButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let lastNameLabel = UILabel(text: "Введите Вашу фамилию")
    let nameLabel = UILabel(text: "Введите Ваше имя")
    let fathernamesLabel = UILabel(text: "Введите Ваше отчество")
    let emailLabel = UILabel(text: "Введите адрес Вашей электронной почты")
    let passwordLabel = UILabel(text: "Введите пароль")
    let repeatPasswordLabel = UILabel(text: "Повторите пароль")
    
    let lastNameTF = UITextField(placeholder: "Ваша фамилия", isPassword: false)
    let nameTF = UITextField(placeholder: "Ваше имя", isPassword: false)
    let fathernamesTF = UITextField(placeholder: "Ваше отчество", isPassword: false)
    let emailTF = UITextField(placeholder: "Адрес электронной почты", isPassword: false)
    let passwordTF = UITextField(placeholder: "Пароль", isPassword: true)
    let repeatPasswordTF = UITextField(placeholder: "Пароль", isPassword: true)
    
    let registrButton = UIButton(title: "Регистрация", hasBackgroundColor: true)
    let showPasswordButton = UIButton(title: "Показать пароль", hasBackgroundColor: false)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        calculateMultiplier()
        setupUI()
        registrButton.addTarget(self, action: #selector(registrationUser), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    }
    
    @objc func showPassword() {
        passwordTF.isSecureTextEntry = false
        repeatPasswordTF.isSecureTextEntry = false
        showPasswordButton.setTitle("Показать пароль 👁", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.passwordTF.isSecureTextEntry = true
            self.repeatPasswordTF.isSecureTextEntry = true
            self.showPasswordButton.setTitle("Показать пароль", for: .normal)
        }
    }
    
    @objc func registrationUser () {
        let textFields = [lastNameTF, nameTF, fathernamesTF, emailTF, passwordTF, repeatPasswordTF]
        let placeholders = ["Ваша фамилия", "Ваше имя", "Ваше отчество", "Адрес электронной почты", "Пароль", "Пароль"]
        
        guard let lastName = lastNameTF.text, lastName != "",
              let name = nameTF.text, name != "",
              let fathernames = fathernamesTF.text, fathernames != "",
              let email = emailTF.text, email != "",
              let password = passwordTF.text, password != "",
              let repeatPassword = repeatPasswordTF.text, repeatPassword != "" else {
            
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
        
        guard Validators.isSimilarPasswords(password: password, repeatPassword: repeatPassword) else {
            let alert = UIAlertController.showAlert(title: "Ошибка", message: "Пароли не совпадают")
            present(alert, animated: true, completion: nil)
            return
        }
        
        let user = UserModel(lastname: lastName, firstname: name, fathername: fathernames, email: email, password: password)
        NetworkManager.shared.registerUser(userToRegistr: user) {[weak self] user, error in
            if let error = error {
                let alert = UIAlertController.showAlert(title: "Ошибка", message: error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            guard let user = user else { return }
            DispatchQueue.main.async {
                self?.dismiss(animated: true) {  [weak self] in
                    self?.delegate?.toLoginVC(user: user)
                }
            }  
        }
    }
    
    @objc func dismissVC () {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - setup UI

extension RegistrationViewController {
    
    func calculateMultiplier() {
        let viewHeight = UIScreen.main.bounds.height
        switch viewHeight {
        case 548..<736:
            multiplier = 0.6
        case 736...926:
            multiplier = 1
        default: multiplier = 1
        }
    }
    
    private func setupUI() {
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        
        let lastNameStack = UIStackView(firstView: lastNameLabel, secondView: lastNameTF, spacing: 10*multiplier)
        let nameStack = UIStackView(firstView: nameLabel, secondView: nameTF, spacing: 10*multiplier)
        let fathernamesStack = UIStackView(firstView: fathernamesLabel, secondView: fathernamesTF, spacing: 10*multiplier)
        let emailStack = UIStackView(firstView: emailLabel, secondView: emailTF, spacing: 10*multiplier)
        let passwordStack = UIStackView(firstView: passwordLabel, secondView: passwordTF, spacing: 10*multiplier)
        let repeatPasswordStack = UIStackView(firstView: repeatPasswordLabel, secondView: repeatPasswordTF, spacing: 10*multiplier)
        
        let generalStack = UIStackView(arrangedSubviews: [lastNameStack, nameStack, fathernamesStack, emailStack, passwordStack, repeatPasswordStack])
        generalStack.axis = .vertical
        generalStack.spacing = 15*multiplier
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        generalStack.translatesAutoresizingMaskIntoConstraints = false
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        registrButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(appleLogo)
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(generalStack)
        view.addSubview(showPasswordButton)
        view.addSubview(registrButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            appleLogo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.height*multiplier/13),
            appleLogo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            appleLogo.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25),
            appleLogo.heightAnchor.constraint(equalTo: appleLogo.widthAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 42),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: 42),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            generalStack.topAnchor.constraint(equalTo: appleLogo.bottomAnchor, constant: view.frame.height*multiplier/20),
            generalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            showPasswordButton.topAnchor.constraint(equalTo: generalStack.bottomAnchor, constant: 20*multiplier),
            showPasswordButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            registrButton.topAnchor.constraint(equalTo: showPasswordButton.bottomAnchor, constant: 20*multiplier),
            registrButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            registrButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 80),
            registrButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -80)
        ])
    }
}

//MARK: - work with keyBoard appearence

extension RegistrationViewController {
    
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





