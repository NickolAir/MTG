import UIKit
import Combine

class VirtualTableVC: UIViewController {
    private let viewModel = VirtualTableViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Virtual Table"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextWindowSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemPurple
        toggle.addTarget(self, action: #selector(nextWindowToggled), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    @objc func nextWindowToggled() {
        viewModel.toggleStackBattlefieldOption(to: nextWindowSwitch.isOn)
    }
    
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
    
    private lazy var onlineSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemPurple
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private lazy var offlineSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Online"
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
    
    // Лоадер
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true // Автоматически скрывается при остановке
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
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
        view.addSubview(titleLabel)
        view.addSubview(nextWindowSwitch)
        view.addSubview(stackSwitchLabel)
        view.addSubview(battlefieldSwitchLabel)
        view.addSubview(onlineSwitch)
        view.addSubview(offlineSwitchLabel)
        view.addSubview(startButton)
        view.addSubview(activityIndicator)
        
        // Констрейнты для titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Констрейнты для первого Switch и его лейбла
        NSLayoutConstraint.activate([
            nextWindowSwitch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nextWindowSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackSwitchLabel.centerYAnchor.constraint(equalTo: nextWindowSwitch.centerYAnchor),
            stackSwitchLabel.trailingAnchor.constraint(equalTo: nextWindowSwitch.leadingAnchor, constant: -10),
            battlefieldSwitchLabel.centerYAnchor.constraint(equalTo: nextWindowSwitch.centerYAnchor),
            battlefieldSwitchLabel.leadingAnchor.constraint(equalTo: nextWindowSwitch.trailingAnchor, constant: 10)
            
        ])
        
        // Констрейнты для второго Switch и его лейбла
        NSLayoutConstraint.activate([
            onlineSwitch.topAnchor.constraint(equalTo: nextWindowSwitch.bottomAnchor, constant: 40),
            onlineSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            offlineSwitchLabel.centerYAnchor.constraint(equalTo: onlineSwitch.centerYAnchor),
            offlineSwitchLabel.trailingAnchor.constraint(equalTo: onlineSwitch.leadingAnchor, constant: -10)
        ])
        
        // Констрейнты для кнопки Start
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: onlineSwitch.bottomAnchor, constant: 60),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func startButtonTapped() {
        var nextVC: UIViewController
        
        if (nextWindowSwitch.isOn) {
            nextVC = BattlefieldViewController()
        }
        else {
            nextVC = SpellStackWindowViewController(isOnlinePull: onlineSwitch.isOn)

        }
        
        // Настройка navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemPurple
        
        // Удаляем данные в базе данных (для теста) и скачиваем их с сервера
        if onlineSwitch.isOn {
            showLoader()
            DataSyncService.shared.DBManager.deleteAllData()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        DataSyncService.shared.fetchAllCards()
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    DataSyncService.shared.DBManager.printAllCards()
                                    DispatchQueue.main.async {
                                        self.hideLoader()
                                        self.navigationController?.pushViewController(nextVC, animated: true)
                                    }
                                case .failure(let error):
                                    self.hideLoader()
                                    print("Ошибка при синхронизации данных: \(error.localizedDescription)")

                                }
                            
                            }, receiveValue: {
                                
                            }).store(in: &self.cancellables)
                    case .failure(let error):
                        print("Ошибка удаления данных из базы данных: \(error.localizedDescription)")
                    }
                }, receiveValue: {})
                .store(in: &self.cancellables)
            
        }
        
        else {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
        
    }
    
    
}
