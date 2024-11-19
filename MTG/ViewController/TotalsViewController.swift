import UIKit

class TotalsViewController: UIViewController {
    private let viewModel = TotalsViewModel()
    private var counterLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // Добавляем центральный заголовок
        let titleLabel = UILabel()
        titleLabel.text = "LABEL"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        // Создаем 2x2 сетку кнопок и лейблов
        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 20
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 20
            rowStack.distribution = .fillEqually
            
            for col in 0..<2 {
                let index = row * 2 + col
                let counter = viewModel.getCounters()[index]
                
                // Создаем вертикальный стек
                let verticalStack = UIStackView()
                verticalStack.axis = .vertical
                verticalStack.alignment = .center
                verticalStack.spacing = 10
                
                // Минус кнопка
                let minusButton = UIButton(type: .system)
                minusButton.setTitle("-", for: .normal)
                minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                minusButton.tag = index
                minusButton.addTarget(self, action: #selector(decreaseCounter(_:)), for: .touchUpInside)
                
                // Лейбл для значения
                let counterLabel = UILabel()
                counterLabel.text = "\(counter.value)"
                counterLabel.textColor = .black
                counterLabel.font = UIFont.systemFont(ofSize: 18)
                counterLabel.textAlignment = .center
                counterLabels.append(counterLabel)
                
                // Плюс кнопка
                let plusButton = UIButton(type: .system)
                plusButton.setTitle("+", for: .normal)
                plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                plusButton.tag = index
                plusButton.addTarget(self, action: #selector(increaseCounter(_:)), for: .touchUpInside)
                
                // Добавляем кнопки и лейбл в вертикальный стек
                verticalStack.addArrangedSubview(minusButton)
                verticalStack.addArrangedSubview(counterLabel)
                verticalStack.addArrangedSubview(plusButton)
                
                rowStack.addArrangedSubview(verticalStack)
            }
            
            gridStack.addArrangedSubview(rowStack)
        }
        
        view.addSubview(gridStack)
        
        NSLayoutConstraint.activate([
            gridStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            gridStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func increaseCounter(_ sender: UIButton) {
        viewModel.increaseCounter(at: sender.tag)
        updateCounters()
    }
    
    @objc private func decreaseCounter(_ sender: UIButton) {
        viewModel.decreaseCounter(at: sender.tag)
        updateCounters()
    }
    
    private func updateCounters() {
        let counters = viewModel.getCounters()
        for (index, label) in counterLabels.enumerated() {
            label.text = "\(counters[index].value)"
        }
    }
}
