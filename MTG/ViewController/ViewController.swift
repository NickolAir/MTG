import UIKit

class ViewController: UIViewController {
    private let viewModel = ViewModel() // Инициализируем ViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TOKENIZER"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tabletopButton: UIButton = {
        let button = UIButton()
        button.setTitle("VIRTUAL TABLETOP", for: .normal)
        button.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapTabletopButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var totalsButton: UIButton = {
        let button = UIButton()
        button.setTitle("TOTALS", for: .normal)
        button.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapTotalsButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Настраиваем обратные вызовы навигации
        viewModel.onNavigateToVirtualTabletop = { [weak self] in
            let virtualTableVC = VirtualTableVC()
            self?.navigationController?.pushViewController(virtualTableVC, animated: true)
        }
        
        viewModel.onNavigateToTotals = { [weak self] in
            let totalsVC = TotalsViewController() // Этот экран вы можете создать по аналогии
            self?.navigationController?.pushViewController(totalsVC, animated: true)
        }
        
        // Добавляем элементы на экран
        view.addSubview(titleLabel)
        view.addSubview(tabletopButton)
        view.addSubview(totalsButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            
            tabletopButton.widthAnchor.constraint(equalToConstant: 150),
            tabletopButton.heightAnchor.constraint(equalToConstant: 150),
            tabletopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tabletopButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            tabletopButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            
            totalsButton.widthAnchor.constraint(equalToConstant: 150),
            totalsButton.heightAnchor.constraint(equalToConstant: 150),
            totalsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            totalsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            totalsButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
        ])
    }
    
    // Действие при нажатии на кнопку "VIRTUAL TABLETOP"
    @objc private func didTapTabletopButton() {
        viewModel.navigateToVirtualTabletop()
    }
    
    // Действие при нажатии на кнопку "TOTALS"
    @objc private func didTapTotalsButton() {
        viewModel.navigateToTotals()
    }
}
