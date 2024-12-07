import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CardCollectionViewCell"
    
    private lazy var cardImageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1 // Ограничиваем текст одной строкой
        label.adjustsFontSizeToFitWidth = true // Включаем автоуменьшение шрифта
        label.minimumScaleFactor = 0.7 // Минимальный масштаб шрифта 
        label.lineBreakMode = .byTruncatingTail // Обрываем текст с троеточием, если он не помещается
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cardImageView)
        contentView.addSubview(cardNameLabel)
        
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            
            cardNameLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 4),
            cardNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with card: CardModel) {
        cardImageView.loadImage(url: card.picture.url!)
        cardNameLabel.text = card.name
    }
}
