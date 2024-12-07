import Foundation
import Combine

class CardCollectionViewModel {
    var isOnlineSource = false
    private var allCards: [CardModel] = [] // Полный список карт из модели
    var cards: [CardModel] = [] // Текущий список для отображения

    var onCardsUpdated: (() -> Void)? // Callback для обновления UI
    private var cancellables: Set<AnyCancellable> = [] // Хранилище подписок Combine

    func loadCards(){
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
                self.cards = cards
                self.onCardsUpdated?()
            })
            .store(in: &cancellables) // Сохраняем подписку
    }
}
