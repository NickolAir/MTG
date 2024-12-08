import Foundation
import Combine

class CardCollectionViewModel {
    private var allCards: [CardModel] = [] // Полный список карт из модели
    var cards: [CardModel] = [] // Текущий список для отображения
    
    var DBManager: DataBaseManager

    private var cancellables: Set<AnyCancellable> = [] // Хранилище подписок Combine
    
    init(dbManager: DataBaseManager, isOnlinePull: Bool = false) {
        self.DBManager = dbManager
    }

    func loadCards() -> AnyPublisher<Bool, Error> {
        print("Loading cards")
        
        // TODO: Сделать загрузку карт из локального хранилища
        
        return Future { promise in
            self.DBManager.getAllCards()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Данные успешно получены.")
                    case .failure(let error):
                        print("Ошибка: \(error.localizedDescription)")
                        promise(.failure(error)) // Передаем ошибку в promise
                    }
                }, receiveValue: { cards in
                    self.cards = cards
                    self.allCards = cards
                    print("Получено \(cards.count) карт.")
                    promise(.success(true)) // Передаем данные в promise
                })
                .store(in: &self.cancellables) // Сохраняем подписку в cancellables
        }
        .eraseToAnyPublisher() // Возвращаем результат как AnyPublisher
    }
    
    func filterCards(by query: String) -> AnyPublisher<Void, Never> {
        Future<Void, Never> { promise in
            // Выполняем фильтрацию
            if query.isEmpty {
                self.cards = self.allCards // Если строка поиска пустая, показываем все карты
            } else {
                self.cards = self.allCards.filter { card in
                    card.name?.lowercased().contains(query.lowercased()) ?? false // Фильтрация по имени
                }
            }
            
            // Уведомляем о завершении обновления
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
            

//        HTTPService.shared.fetchAllCards(from: URL(string: "http://37.46.135.99")!)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    print("Данные успешно загружены.")
//                case .failure(let error):
//                    print("Ошибка при загрузке данных: \(error.localizedDescription)")
//                }
//            }, receiveValue: { cards in
//                print("Полученные карты (\(cards.count)):")
//                cards.forEach { card in
//                    print("ID: \(card.id), Name: \(card.name)")
//                }
//                self.cards = cards
//                self.onCardsUpdated?()
//            })
//            .store(in: &cancellables) // Сохраняем подписку
}
