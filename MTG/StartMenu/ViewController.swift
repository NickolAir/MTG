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
            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self?.navigationItem.backBarButtonItem?.tintColor = .systemPurple
        }
        
        viewModel.onNavigateToTotals = { [weak self] in
            let totalsVC = TotalsViewController() // Этот экран вы можете создать по аналогии
            self?.navigationController?.pushViewController(totalsVC, animated: true)
            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self?.navigationItem.backBarButtonItem?.tintColor = .systemPurple
        }
        
        // Добавляем элементы на экран
        view.addSubview(titleLabel)
        view.addSubview(tabletopButton)
        view.addSubview(totalsButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            tabletopButton.heightAnchor.constraint(equalToConstant: 150),
            tabletopButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            tabletopButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            tabletopButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            
            totalsButton.heightAnchor.constraint(equalToConstant: 150),
            totalsButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            totalsButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            totalsButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: totalsButton.topAnchor, constant: -50),
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
