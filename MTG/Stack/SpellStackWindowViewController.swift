import UIKit

class SpellStackWindowViewController: UIViewController {
    private let viewModel = SpellStackWindowViewModel()
    
    // MARK: - UI Elements
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cardStackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        // Создаем кнопки + и -
        let plusButton = createRoundButton(
            title: "+",
            backgroundColor: .systemPurple,
            action: #selector(addCardButtonTapped)
        )
        
        let minusButton = createRoundButton(
            title: "-",
            backgroundColor: .systemPurple,
            action: #selector(removeCardButtonTapped)
        )
        
        // Создаем заголовок
        let titleLabel = UILabel()
        titleLabel.text = "Stack"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        // Создаем горизонтальный стек для размещения кнопок и заголовка
        let stackView = UIStackView(arrangedSubviews: [minusButton, titleLabel, plusButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        // Устанавливаем стек как titleView
        navigationItem.titleView = stackView
    }
    
    private func createRoundButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupUI() {
        view.addSubview(cardStackView)
        
        // Констрейнты для cardStackView
        NSLayoutConstraint.activate([
            cardStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cardStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addCardButtonTapped() {
        // Открываем экран выбора карты
        let cardCollectionVC = CardCollectionWindowViewController()
        cardCollectionVC.onCardSelected = { [weak self] selectedCard in
            guard let self = self else { return }
            self.viewModel.addCard(selectedCard) // Сохраняем карту в массив
            self.updateUI() // Обновляем интерфейс
        }
        navigationController?.pushViewController(cardCollectionVC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemPurple
    }
    
    @objc private func removeCardButtonTapped() {
        // Удаляем последнюю карту
        viewModel.removeLastCard()
        updateUI()
    }
    
    // MARK: - Update UI
    private func updateUI() {
        // Очистка старых карт
        cardStackView.subviews.forEach { $0.removeFromSuperview() }
        
        // Добавление каждой карты из модели
        let cards = viewModel.getAllCards() // Предполагается, что метод возвращает массив всех карт
        
        for (index, card) in cards.enumerated() {
            let imageView = DownloadableImageView()
            imageView.loadImage(url: card.picture.url!)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cardStackView.addSubview(imageView)
            
            // Смещение карты
            let offset = CGFloat(index * 35) // Смещение между картами
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: cardStackView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: cardStackView.centerYAnchor, constant: offset),
                imageView.widthAnchor.constraint(equalTo: cardStackView.widthAnchor, multiplier: 0.8),
                imageView.heightAnchor.constraint(equalTo: cardStackView.heightAnchor, multiplier: 0.8)
            ])
        }
    }
}
