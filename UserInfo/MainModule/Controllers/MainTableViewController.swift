import UIKit

final class MainTableViewController: UITableViewController {
    
    private var userModel = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getUserModel()
        tableView.register(MainTableViewCell.self)
    }
    
    private func setupViews() {
        title = "Просмотр"
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(editingTapped))
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
    
    public func changeUserModel(model: UserModel) {
        saveEditModel(model)
        userModel = model
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Resources.NameFields.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MainTableViewCell.self) else {
            return UITableViewCell()
        }
        let nameField = Resources.NameFields.allCases[indexPath.row].rawValue
        let value = UserDefaultsHelpers.getUserValue(Resources.NameFields.allCases[indexPath.row].rawValue)
        cell.configure(name: nameField, value: value)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 1 ? UITableView.automaticDimension : 44 
    }
}
