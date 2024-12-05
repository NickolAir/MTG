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
       title = "Stack"
       
       // Кнопка возврата - стрелка
       navigationItem.leftBarButtonItem = UIBarButtonItem(
           image: UIImage(systemName: "arrow.left"), // Стрелка назад
           style: .plain,
           target: self,
           action: #selector(backButtonTapped)
       )
       
       // Кнопки "+" и "-" с большим расстоянием
       let plusButton = UIBarButtonItem(
           title: "+",
           style: .plain,
           target: self,
           action: #selector(addCardButtonTapped)
       )
       
       let minusButton = UIBarButtonItem(
           title: "-",
           style: .plain,
           target: self,
           action: #selector(removeCardButtonTapped)
       )
       
        // Устанавливаем больший шрифт для кнопок
        plusButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        minusButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        
        // Устанавливаем кнопки в navigationItem
        navigationItem.rightBarButtonItems = [
            plusButton,
            minusButton
        ]
        
        // Задаем фиолетовый цвет для кнопок
        navigationItem.leftBarButtonItem?.tintColor = .systemPurple
        navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .systemPurple }
    }
    
    private func setupUI() {
        view.addSubview(cardImageView)
        
        // Констрейнты для карты
        NSLayoutConstraint.activate([
            cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardImageView.widthAnchor.constraint(equalToConstant: 200),
            cardImageView.heightAnchor.constraint(equalToConstant: 300)
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

