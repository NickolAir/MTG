//
//  CardImageView.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 09.12.2024.
//

import UIKit
import Combine

class CardImageView: UIView {
    // Показывать ли кнопку скачивания картинки на диск
    lazy var isDownloadButton = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    var viewModel: CardModel? {
        didSet {
            updateUI()
        }
    }
    
    init(isDownloadButtonShowed: Bool = false) {
        super.init(frame: CGRect())
        self.isDownloadButton = isDownloadButtonShowed
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Лоадер
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true // Автоматически скрывается при остановке
        return indicator
    }()
    
    lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        guard let pictureId = viewModel?.picture.id, let image = imageView.image else {
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
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(downloadViewButton)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
            
            downloadViewButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.downloadButton.topPadding.value),
            downloadViewButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Constants.downloadButton.rightPadding.value),
            downloadViewButton.widthAnchor.constraint(equalToConstant: Constants.downloadButton.width.value),
            downloadViewButton.heightAnchor.constraint(equalToConstant: Constants.downloadButton.height.value),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
        
        downloadViewButton.layer.cornerRadius = Constants.downloadButton.height.value / 2
        
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        imageView.loadImage(id: viewModel.picture.id!)
        if (!isDownloadButton) {
            downloadViewButton.isHidden = true
        }
        
        DiskStorage.shared.getImage(forKey: "CardImage_\(viewModel.picture.id!)")
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { image in
                // Изображение загружено с диска, можем переводить кнопку в состояние загружено
                if let image = image {
                    self.downloadViewButton.setImage(UIImage(systemName: "internaldrive"), for: .normal)
                }
                
            }).store(in: &cancellables)
    }
}
