import UIKit

class SpellStackWindowViewModel {
    // Массив карт
    private var cards: [CardModel] = []
    
    // Добавление карты
    func addCard(_ card: CardModel) {
        cards.append(card)
    }
    
    // Удаление последней карты
    func removeLastCard() {
        guard !cards.isEmpty else { return }
        cards.removeLast()
    }
    
    // Получение последней карты
    func getLastCard() -> CardModel? {
        return cards.last
    }
    
    func getAllCards() -> [CardModel] {
        return cards // cards - массив всех добавленных карт
    }
}
