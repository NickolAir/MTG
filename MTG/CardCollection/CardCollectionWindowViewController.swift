import UIKit
import Combine

class CardCollectionWindowViewController: UIViewController {
    private let viewModel: CardCollectionViewModel
    
    init() {
        self.viewModel = CardCollectionViewModel(dbManager: SQLiteManager())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    var onCardSelected: ((CardModel) -> ())?
    
    
    // Поисковая строка
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for cards"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // Рассчитываем ширину ячейки как половину ширины экрана с учетом отступов
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let itemWidth = (screenWidth - 3 * spacing) / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CardCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadCards()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Карты успешно загружены.")
                        self.collectionView.reloadData()
                    case .failure(let error):
                        print("Ошибка: \(error.localizedDescription)")
                    }
                }, receiveValue: {_ in })
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
    }

//    private func bindViewModel() {
//        viewModel.onCardsUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//            }
//        }
//    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CardCollectionWindowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCollectionViewCell.self), for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        let card = viewModel.cards[indexPath.row]
        cell.configure(with: card)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCard = viewModel.cards[indexPath.row]
        onCardSelected?(selectedCard) // Уведомляем другой экран о выборе карты
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension CardCollectionWindowViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCards(by: searchText)
            .sink(receiveCompletion: {_ in
                self.collectionView.reloadData()
            }, receiveValue: {}
            ).store(in: &cancellables)// Сбрасываем поиск
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Скрываем клавиатуру при нажатии кнопки поиска
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.filterCards(by: "")
            .sink(receiveCompletion: {_ in 
                self.collectionView.reloadData()
                searchBar.resignFirstResponder() // Скрываем клавиатуру
            }, receiveValue: {}
            ).store(in: &cancellables)// Сбрасываем поиск
         
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            // Скрыть клавиатуру
            view.endEditing(true)
        }
}
