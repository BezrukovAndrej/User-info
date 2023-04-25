import UIKit

final class MainViewController: UIViewController {
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mainTableView = MainTableView()
    private var userModel = UserModel()

    override func viewWillLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getUserModel()
        setConstraints()
        setValueArray()
        
    }
    
    private func setupViews() {
        title = "Просмотр"
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(editingTapped))
        view.addView(mainTableView)
        view.addView(userPhotoImageView)
    }
    
    @objc private func editingTapped() {
        let editingViewController = EditingViewController(userModel, userPhoto: userPhotoImageView.image)
        navigationController?.pushViewController(editingViewController, animated: true)
    }
    
    private func getUserModel() {
        userModel = UserDefaultsHelpers.getUserModel()
        let userPhoto = UserDefaultsHelpers.loadUserImage()
        userPhotoImageView.image = userPhoto
    }
    
    private func saveEditModel(_ model: UserModel) {
        UserDefaultsHelpers.saveUserValue(Resources.NameFields.firstName.rawValue, model.firstName)
        UserDefaultsHelpers.saveUserValue(Resources.NameFields.secondName.rawValue, model.secondName)
        UserDefaultsHelpers.saveUserValue(Resources.NameFields.thirdName.rawValue, model.thirdName)
        UserDefaultsHelpers.saveUserValue(Resources.NameFields.dateBirthday.rawValue, model.dateBirthday)
        UserDefaultsHelpers.saveUserValue(Resources.NameFields.gender.rawValue, model.gender)
    }
    
    private func getValueArray() -> [String] {
        var valueArray = [String]()
        for key in Resources.NameFields.allCases {
            let value = UserDefaultsHelpers.getUserValue(key.rawValue)
            valueArray.append(value)
        }
        return valueArray
    }
    
    private func setValueArray() {
        let valueArray = getValueArray()
        mainTableView.setValueArray(valueArray)
        mainTableView.reloadData()
    }
    
    public func changeUserModel(model: UserModel) {
        saveEditModel(model)
        userModel = model
        setValueArray()
        mainTableView.reloadData()
    }
    
    public func changeUserPhoto(image: UIImage?) {
        userPhotoImageView.image = image
        guard let userPhoto = image else { return }
        UserDefaultsHelpers.saveUserImage(image: userPhoto)
    }
}

// MARK: - Set Constraints

extension MainViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            mainTableView.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 10),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
