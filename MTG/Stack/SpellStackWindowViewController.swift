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
        view.addSubview(cardImageView)
        
        let width = UIScreen.main.bounds.width / 1.2
        
        // Констрейнты для карты
        NSLayoutConstraint.activate([
            cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardImageView.widthAnchor.constraint(equalToConstant: width),
            cardImageView.heightAnchor.constraint(equalToConstant: width * 1.5)
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
        if let lastCard = viewModel.getLastCard() {
            cardImageView.image = UIImage(named: lastCard.imagePath)
        } else {
            cardImageView.image = nil
        }
    }
}

