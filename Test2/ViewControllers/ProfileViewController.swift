//
//  ProfileViewController.swift
//  Test2
//
//  Created by Рамил Гаджиев on 09.10.2021.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    var currentUser: UserModel
    
    var multiplier:CGFloat = 1
    let hobbies = ["Авто", "Бизнес", "Инвестиции", "Спорт", "Саморазвитие", "Здоровье", "Еда", "Семья", "Дети", "Домашние питомцы", "Фильмы","Компьютерные игры","Музыка"]
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        return scrollView
    }()
    
    var profileImage = ProfileCircleImage()
    
    var datePicker = UIDatePicker()
    var hobbyPickerView = UIPickerView()
    
    let lastNameLabel = UILabel(text: "Ваша фамилия")
    let nameLabel = UILabel(text: "Ваше имя")
    let fathernamesLabel = UILabel(text: "Ваше отчество")
    let placeOfBirthLabel = UILabel(text: "Место рождения")
    let dateOfBirthLabel = UILabel(text: "Дата рождения")
    let companyLabel = UILabel(text: "Организация")
    let positionLabel = UILabel(text: "Должность")
    let hobbyLabel = UILabel(text: "Ваши увлечения")
    
    let lastNameTF = UITextField(placeholder: "Ваша фамилия", isPassword: false)
    let nameTF = UITextField(placeholder: "Ваше имя", isPassword: false)
    let fathernamesTF = UITextField(placeholder: "Ваше отчество", isPassword: false)
    let placeOfBirthTF = UITextField(placeholder: "Место рождения", isPassword: false)
    let dateOfBirthTF = UITextField(placeholder: "Дата рождения", isPassword: false)
    let companyTF = UITextField(placeholder: "Организация", isPassword: false)
    let positionTF = UITextField(placeholder: "Должность", isPassword: false)
    let hobbyTF = UITextField(placeholder: "Интересующие Вас темы", isPassword: false)
    
    let saveButton = UIButton(title: "Сохранить", hasBackgroundColor: true)
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        hobbyTF.text = "Авто"
        calculateMultiplier()
        setupUI()
        createDatePicker()
        createHobbyPicker()
        profileImage.button.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveUser), for: .touchUpInside)
    }
    
    @objc func saveUser () {
        let textFields = [lastNameTF, nameTF, placeOfBirthTF, dateOfBirthTF, companyTF, positionTF, hobbyTF]
        let placeholders = ["Ваша фамилия", "Ваше имя", "Место рождения", "Дата рождения", "Организация", "Должность", "Интересующие Вас темы"]
        
        guard let lastName = lastNameTF.text, lastName != "",
              let name = nameTF.text, name != "",
              let placeOfBirth = placeOfBirthTF.text, placeOfBirth != "",
              let dateOfBirth = dateOfBirthTF.text, dateOfBirth != "",
              let company = companyTF.text, company != "",
              let position = positionTF.text, position != "",
              let hobby = hobbyTF.text, hobby != "" else {
            
            for (textField, placeholder)  in zip(textFields, placeholders) {
                if textField.text == "" || textField.text == nil {
                    textField.fillTextField(placeholder: placeholder)
                }
            }
            return
        }
        
        currentUser.firstname = name
        currentUser.lastname = lastName
        currentUser.birthdate = dateOfBirth
        currentUser.birth_place = placeOfBirth
        currentUser.organization = company
        currentUser.position = position
        currentUser.preferences = [hobby]
        NetworkManager.shared.updateProfile(userToUpdate: currentUser) {[weak self] user, error in
            if let error = error {
                let alert = UIAlertController.showAlert(title: "Ошибка", message: error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            guard let user = user else { return }
            self?.currentUser = user
        }
    }
    
    @objc func setImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func createDatePicker() {
        datePicker.frame.size = CGSize(width: view.frame.width, height: 150)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dataDonePressed))
        toolBar.setItems([doneButton], animated: true)
        dateOfBirthTF.inputAccessoryView = toolBar
        dateOfBirthTF.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    func createHobbyPicker() {
        hobbyPickerView.frame.size = CGSize(width: view.frame.width, height: 200)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hobbyDonePressed))
        toolBar.setItems([doneButton], animated: true)
        hobbyTF.inputAccessoryView = toolBar
        hobbyTF.inputView = hobbyPickerView
        hobbyPickerView.delegate = self
        hobbyPickerView.dataSource = self
    }
    
    @objc func dataDonePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateOfBirthTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func hobbyDonePressed() {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - setup UI

extension ProfileViewController {
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
        let lastNameAndNameStack = UIStackView(firstView: lastNameStack, secondView: nameStack, axis: .horizontal, spacing: 10)
        lastNameAndNameStack.distribution = .fillEqually
        
        let fathernamesStack = UIStackView(firstView: fathernamesLabel, secondView: fathernamesTF, spacing: 10*multiplier)
        let placeOfBirthStack = UIStackView(firstView: placeOfBirthLabel, secondView: placeOfBirthTF, spacing: 10*multiplier)
        let fathernamesAndPlaceOfBirthStack = UIStackView(firstView: fathernamesStack, secondView: placeOfBirthStack, axis: .horizontal, spacing: 10)
        fathernamesAndPlaceOfBirthStack.distribution = .fillEqually
        
        let dateOfBirthStack = UIStackView(firstView: dateOfBirthLabel, secondView: dateOfBirthTF, spacing: 10*multiplier)
        let hobbyStack = UIStackView(firstView: hobbyLabel, secondView: hobbyTF, spacing: 10*multiplier)
        let dateOfBirthAndHobbyStack = UIStackView(firstView: dateOfBirthStack, secondView: hobbyStack, axis: .horizontal, spacing: 10)
        dateOfBirthAndHobbyStack.distribution = .fillEqually
        
        let companyStack = UIStackView(firstView: companyLabel, secondView: companyTF, spacing: 10*multiplier)
        let positionStack = UIStackView(firstView: positionLabel, secondView: positionTF, spacing: 10*multiplier)
        let companyAndPositionStack = UIStackView(firstView: companyStack, secondView: positionStack, axis: .horizontal, spacing: 10)
        companyAndPositionStack.distribution = .fillEqually
        
        let generalStack = UIStackView(arrangedSubviews: [lastNameAndNameStack, fathernamesAndPlaceOfBirthStack, dateOfBirthAndHobbyStack, companyAndPositionStack])
        generalStack.axis = .vertical
        generalStack.spacing = 30*multiplier
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        generalStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(generalStack)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100*multiplier),
            profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            generalStack.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 80*multiplier),
            generalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: generalStack.bottomAnchor, constant: 50*multiplier),
            saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 80),
            saveButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -80)
        ])
    }
}


//MARK: - UIPickerView

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        hobbies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        hobbies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hobbyTF.text = hobbies[row]
    }
}


//MARK: - UIImagePickerController

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImage.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - work with keyBoard appearence

extension ProfileViewController {
    
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

