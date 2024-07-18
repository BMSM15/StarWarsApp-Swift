import UIKit

// Classe personalizada para a célula da CollectionView
class StarWarsCell: UICollectionViewCell {
    let nameLabel = UILabel()
    let genderLabel = UILabel()

    // Inicializador padrão
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    // Inicializador necessário para conformidade com o protocolo NSCoding (não implementado)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configuração das views da célula
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(genderLabel)
        
        // Configurações das labels
        nameLabel.textColor = .white
        genderLabel.textColor = .white
        nameLabel.frame = CGRect(x: 10, y: 10, width: contentView.frame.width, height: 20)
        genderLabel.frame = CGRect(x: 10, y: 40, width: contentView.frame.width, height: 20)

        // Configurações do conteúdo da célula
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .gray
    }
}
