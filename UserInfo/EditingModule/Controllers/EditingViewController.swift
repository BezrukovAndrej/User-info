import UIKit
import PhotosUI

final class EditingViewController: UIViewController {
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let editingTableView = EditingTableView()
    private var userModel = UserModel()
    private var userPhotoIsChange = false
    
    override func viewWillLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addTaps()
    }
    
    init(_ userModel: UserModel, userPhoto: UIImage?) {
        self.userModel = userModel
        self.userPhotoImageView.image = userPhoto
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
        view.addView(userPhotoImageView)
        view.addView(editingTableView)
    }
    
    @objc private func backButtonTapped() {
        let editUserModel = editingTableView.getUserModel()
        if authField(model: editUserModel) == false {
            presentSimpleAlert(title: "Ошибка", message: "Заполните все поля!")
            return 
        }
        if editUserModel == userModel && userPhotoIsChange == false {
            navigationController?.popViewController(animated: true)
        } else {
            presentChangeAlert {[weak self] value in
                guard let self = self else { return }
                if value {
                    guard let firstVC = self.navigationController?.viewControllers.first as? MainViewController else {
                        return
                    }
                    firstVC.changeUserModel(model: editUserModel)
                    firstVC.changeUserPhoto(image: userPhotoImageView.image)
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
            model.firstName == "" ||
            model.secondName == "Введите данные" ||
            model.secondName == "" ||
            model.dateBirthday == "" ||
            model.gender == "" ||
            model.gender == "Не указано" {
            return false
        }
        return true
    }
    
    private func addTaps() {
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        userPhotoImageView.isUserInteractionEnabled = true
        userPhotoImageView.addGestureRecognizer(tapImageView)
    }
    
    @objc func setUserPhoto() {
        if #available(iOS 14, *) {
            presentPhotoPicker()
        } else {
            presentImagePicker()
        }
    }
}

//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension EditingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.allowsEditing = true
            imagepicker.sourceType = .photoLibrary
            present(imagepicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userPhotoImageView.image = image
        userPhotoIsChange = true
        dismiss(animated: true)
    }
}

//MARK: - PHPickerViewControllerDelegate

@available(iOS 14, *)
extension EditingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.userPhotoImageView.image = image
                }
                self.userPhotoIsChange = true
            }
        }
    }
    
    private func presentPhotoPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.images
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}

// MARK: - Set Constraints

extension EditingViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            editingTableView.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 10),
            editingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            editingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            editingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
