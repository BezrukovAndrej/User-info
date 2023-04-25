import UIKit

final class EditingViewController: UIViewController {
    
    private let editingTableView = EditingTableView()
    private var userModel = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    init(_ userModel: UserModel) {
        self.userModel = userModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        title = "Редактирование"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveTapped))
        let backBarButtonItem = UIBarButtonItem.createCustomButton(vc: self,
                                                                   selector: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backBarButtonItem
        editingTableView.setUserModel(userModel)
        view.addView(editingTableView)
    }
    
    @objc private func backButtonTapped() {
        let editUserModel = editingTableView.getUserModel()
        if editUserModel == userModel {
            navigationController?.popViewController(animated: true)
        } else {
            presentChangeAlert {[weak self] value in
                guard let self = self else { return }
                if value {
                    guard let firstVC = self.navigationController?.viewControllers.first as? MainViewController else {
                        return
                    }
                    firstVC.changeUserModel(model: editUserModel)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func saveTapped() {
        let editUserModel = editingTableView.getUserModel()
        if authField(model: editUserModel) {
            presentSimpleAlert(title: "Выполнено", message: "Все поля заполнены")
        } else {
            presentSimpleAlert(title: "Ошибка", message: "Заполните все поля!")
        }
    }
    
    private func authField(model: UserModel) -> Bool {
        if model.firstName == "Введите данные" ||
            model.secondName == "Введите данные" ||
            model.dateBirthday == "" ||
            model.gender == "" ||
            model.gender == "Не указано" {
            return false
        }
        return true
    }
}

// MARK: - Set Constraints

extension EditingViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            editingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            editingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            editingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            editingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
