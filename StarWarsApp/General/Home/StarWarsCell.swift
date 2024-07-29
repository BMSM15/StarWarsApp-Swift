import UIKit

class StarWarsCell: UICollectionViewCell {
    let nameLabel = UILabel()
    let genderLabel = UILabel()
    let nameInputLabel = UILabel()
    let genderInputLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        genderLabel.text = ""
        nameInputLabel.text = ""
        genderInputLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(nameInputLabel)
        contentView.addSubview(genderInputLabel)
        
        // Configurações das labels
        nameLabel.textColor = .white
        genderLabel.textColor = .white
        nameInputLabel.textColor = .white
        genderInputLabel.textColor = .white

        // Configurações do conteúdo da célula
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .gray

        // Configurar content hugging e compression resistance
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        genderLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        genderLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        nameInputLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        genderInputLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameInputLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        genderInputLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        nameInputLabel.translatesAutoresizingMaskIntoConstraints = false
        genderInputLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Name Label and Input Label
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            nameInputLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameInputLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            nameInputLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Gender Label and Input Label
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            genderInputLabel.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            genderInputLabel.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 5),
            genderInputLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            genderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with person: Person) {
        nameInputLabel.text = person.name
        genderInputLabel.text = person.gender
        nameLabel.text = "Name:"
        genderLabel.text = "Gender:"
    }
}
