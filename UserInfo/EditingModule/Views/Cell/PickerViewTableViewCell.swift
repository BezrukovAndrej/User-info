import UIKit

final class PickerViewTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let gengerPickerView = GenderPickerView()
    private let gendertextField = GenderTextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        nameLabel.font = Resources.Fonts.avenirNextRegular(18)
        addView(nameLabel)
        
        gengerPickerView.genderDelegate = self
        
        gendertextField.inputView = gengerPickerView
        contentView.addView(gendertextField)
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
}

extension PickerViewTableViewCell: GenderPickerViewProtocol {
    func didSelect(row: Int) {
        gendertextField.text = Resources.Gender.allCases[row].rawValue
        gendertextField.resignFirstResponder()
    }
}

// MARK: - Set Constraints

extension PickerViewTableViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            
            gendertextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            gendertextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            gendertextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            gendertextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

