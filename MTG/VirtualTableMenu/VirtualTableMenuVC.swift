import UIKit

class VirtualTableVC: UIViewController {
    private let viewModel = VirtualTableViewModel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Virtual Table"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackBattlefieldSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemPurple
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private lazy var stackSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Stack"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var battlefieldSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Battlefield"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var offlineSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemPurple
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private lazy var offlineSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Offline"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(stackBattlefieldSwitch)
        view.addSubview(stackSwitchLabel)
        view.addSubview(battlefieldSwitchLabel)
        view.addSubview(offlineSwitch)
        view.addSubview(offlineSwitchLabel)
        view.addSubview(startButton)
        
        // Констрейнты для titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Констрейнты для первого Switch и его лейбла
        NSLayoutConstraint.activate([
            stackBattlefieldSwitch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackBattlefieldSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackSwitchLabel.centerYAnchor.constraint(equalTo: stackBattlefieldSwitch.centerYAnchor),
            stackSwitchLabel.trailingAnchor.constraint(equalTo: stackBattlefieldSwitch.leadingAnchor, constant: -10),
            battlefieldSwitchLabel.centerYAnchor.constraint(equalTo: stackBattlefieldSwitch.centerYAnchor),
            battlefieldSwitchLabel.leadingAnchor.constraint(equalTo: stackBattlefieldSwitch.trailingAnchor, constant: 10)
            
        ])
        
        // Констрейнты для второго Switch и его лейбла
        NSLayoutConstraint.activate([
            offlineSwitch.topAnchor.constraint(equalTo: stackBattlefieldSwitch.bottomAnchor, constant: 40),
            offlineSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            offlineSwitchLabel.centerYAnchor.constraint(equalTo: offlineSwitch.centerYAnchor),
            offlineSwitchLabel.trailingAnchor.constraint(equalTo: offlineSwitch.leadingAnchor, constant: -10)
        ])
        
        // Констрейнты для кнопки Start
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: offlineSwitch.bottomAnchor, constant: 60),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func startButtonTapped() {
        let spellStackVC = SpellStackWindowViewController()
        self.navigationController?.pushViewController(spellStackVC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemPurple
    }
}
