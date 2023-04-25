import UIKit

final class MainViewController: UIViewController {
    
    private let mainTableView = MainTableView()
    private var userModel = UserModel()

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
    }
    
    @objc private func editingTapped() {
        let editingViewController = EditingViewController(userModel)
        navigationController?.pushViewController(editingViewController, animated: true)
    }
    
    private func getUserModel() {
        userModel = UserDefaultsHelpers.getUserModel()
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
        mainTableView.reloadData()
    }
}

// MARK: - Set Constraints

extension MainViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
