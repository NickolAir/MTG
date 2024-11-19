import UIKit

class TotalsViewController: UIViewController {
    private let viewModel = TotalsViewModel()
    private var counterLabels: [UILabel] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "LABEL"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gridStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(gridStack)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            gridStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            gridStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        createGrid()
    }
    
    private func createGrid() {
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 100
            rowStack.distribution = .fillEqually
            
            for col in 0..<2 {
                let index = row * 2 + col
                let counter = viewModel.getCounters()[index]
                
                let verticalStack = createVerticalStack(index: index, counter: counter.value)
                rowStack.addArrangedSubview(verticalStack)
            }
            
            gridStack.addArrangedSubview(rowStack)
        }
    }
    
    private func createVerticalStack(index: Int, counter: Int) -> UIStackView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 20
        
        let minusButton = createRoundButton(title: "-", tag: index, action: #selector(decreaseCounter(_:)))
        let plusButton = createRoundButton(title: "+", tag: index, action: #selector(increaseCounter(_:)))
        
        let counterLabel = createCounterLabel(text: "\(counter)")
        counterLabels.append(counterLabel)
        
        verticalStack.addArrangedSubview(minusButton)
        verticalStack.addArrangedSubview(counterLabel)
        verticalStack.addArrangedSubview(plusButton)
        
        return verticalStack
    }
    
    private func createRoundButton(title: String, tag: Int, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.tag = tag
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = UIColor.systemPurple
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }
    
    private func createCounterLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
