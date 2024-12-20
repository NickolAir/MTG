import UIKit

class ManaPoolViewController: UIViewController {
    private let viewModel = ManaViewModel()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var containerViews: [UIView] = viewModel.manaImages.enumerated().map { index, image in
        createManaCounterRow(index: index, image: image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        containerViews.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func bindViewModel() {
        viewModel.onManaUpdated = { [weak self] index, count in
            self?.updateManaLabel(at: index, with: count)
        }
    }
    
    private func createManaCounterRow(index: Int, image: UIImage?) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        lazy var manaImageView: UIImageView = {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        lazy var counterLabel: UILabel = {
            let label = UILabel()
            label.text = "\(viewModel.manaCounters[index])"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        lazy var minusButton: UIButton = createRoundButton(title: "-", tag: index, action: #selector(decrementMana(_:)))
        lazy var plusButton: UIButton = createRoundButton(title: "+", tag: index, action: #selector(incrementMana(_:)))
        
        containerView.addSubview(manaImageView)
        containerView.addSubview(counterLabel)
        containerView.addSubview(minusButton)
        containerView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            manaImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            manaImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            manaImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            manaImageView.widthAnchor.constraint(equalToConstant: 80),
            manaImageView.heightAnchor.constraint(equalToConstant: 80),
            
            minusButton.centerYAnchor.constraint(equalTo: manaImageView.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: manaImageView.trailingAnchor, constant: 20),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            minusButton.heightAnchor.constraint(equalToConstant: 40),
            
            counterLabel.centerYAnchor.constraint(equalTo: manaImageView.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 20),
            counterLabel.widthAnchor.constraint(equalToConstant: 50),
            
            plusButton.centerYAnchor.constraint(equalTo: manaImageView.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: counterLabel.trailingAnchor, constant: 20),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            
            containerView.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor),
        ])
        
        return containerView
    }
    
    @objc private func incrementMana(_ sender: UIButton) {
        viewModel.incrementMana(for: sender.tag)
    }
    
    @objc private func decrementMana(_ sender: UIButton) {
        viewModel.decrementMana(for: sender.tag)
    }
    
    private func updateManaLabel(at index: Int, with count: Int) {
        guard let row = stackView.arrangedSubviews[index] as? UIView,
              let counterLabel = row.subviews.first(where: { $0 is UILabel }) as? UILabel else {
            return
        }
        counterLabel.text = "\(count)"
    }
    
    private func createRoundButton(title: String, tag: Int, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.tag = tag
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Устанавливаем фон и границы
        button.backgroundColor = UIColor.systemPurple
        button.layer.cornerRadius = 20 // Половина ширины/высоты кнопки для полного круга
        button.layer.masksToBounds = true // Убеждаемся, что кнопка полностью круглая
        
        // Тени для кнопок
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        
        // Ограничиваем размеры через Auto Layout
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50), // Кнопка шириной 50
            button.heightAnchor.constraint(equalTo: button.widthAnchor) // Высота равна ширине
        ])
        
        return button
    }
}
