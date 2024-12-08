import Foundation
import Combine

class CardCollectionViewModel {
    var isOnlineSource = false
    private var allCards: [CardModel] = [] // Полный список карт из модели
    var cards: [CardModel] = [] // Текущий список для отображения
    
    var onCardsUpdated: (() -> Void)? // Callback для обновления UI
    private var cancellables: Set<AnyCancellable> = [] // Хранилище подписок Combine
    
    func loadCards() {
        print("Loading cards")
        
        HTTPService.shared.fetchAllCards(from: URL(string: "http://37.46.135.99")!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Данные успешно загружены.")
                case .failure(let error):
                    print("Ошибка при загрузке данных: \(error.localizedDescription)")
                }
            }, receiveValue: { cards in
                print("Полученные карты (\(cards.count)):")
                cards.forEach { card in
                    print("ID: \(card.id), Name: \(card.name)")
                }
                self.allCards = cards // Сохраняем полный список карт
                self.cards = cards // Изначально показываем все карты
                self.onCardsUpdated?()
            })
            .store(in: &cancellables) // Сохраняем подписку
    }
    
    func filterCards(by query: String) {
        if query.isEmpty {
            cards = allCards // Если строка поиска пустая, показываем все карты
        } else {
            cards = allCards.filter { card in
                card.name!.lowercased().contains(query.lowercased()) // Фильтрация по имени
            }
        }
        onCardsUpdated?() // Уведомляем UI об обновлении данных
    }
}
