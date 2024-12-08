import UIKit
import Combine

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CardCollectionViewCell"
    
    private var cancellables: Set<AnyCancellable> = []
    
    var viewModel: CardModel?
    
    private lazy var cardImageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Лоадер
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true // Автоматически скрывается при остановке
        return indicator
    }()
    
    private lazy var downloadViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.tintColor = .purple
        button.backgroundColor = .systemGray.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func downloadButtonTapped() {
        guard let viewModel = viewModel, let pictureId = viewModel.picture.id, let image = cardImageView.image else {
            return
        }
        showLoader() // Показываем лоадер
        
        DiskStorage.shared.saveImage(image, forKey: "CardImage_\(pictureId)")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.hideLoader()
                case .failure(let error):
                    self.hideLoader()
                    print("Ошибка сохранения карты на диск: \(error.localizedDescription)")
                }
            }, receiveValue: {
                
            }).store(in: &cancellables)
    }
    
    // Показываем лоадер
    private func showLoader() {
        activityIndicator.startAnimating()
    }
    
    // Скрываем лоадер
    private func hideLoader() {
        activityIndicator.stopAnimating()
    }
    
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
    
    enum Constants {
        enum downloadButton {
            case height
            case width
            case rightPadding
            case topPadding
            
            var value: CGFloat {
                switch self {
                case .height:
                    return 30
                case .width:
                    return 30
                case .rightPadding:
                    return -16
                case .topPadding:
                    return 30
                }
            }
        }
    }
    
    private func setupUI() {
        contentView.addSubview(cardImageView)
        contentView.addSubview(cardNameLabel)
        contentView.addSubview(downloadViewButton)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            
            cardNameLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 4),
            cardNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            downloadViewButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.downloadButton.topPadding.value),
            downloadViewButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.downloadButton.rightPadding.value),
            downloadViewButton.widthAnchor.constraint(equalToConstant: Constants.downloadButton.width.value),
            downloadViewButton.heightAnchor.constraint(equalToConstant: Constants.downloadButton.height.value),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                   
        ])
        
        downloadViewButton.layer.cornerRadius = Constants.downloadButton.height.value / 2
    }
    
    func configure(with card: CardModel) {
        self.viewModel = card
        cardImageView.loadImage(id: card.picture.id!)
        cardNameLabel.text = card.name
    }
}
