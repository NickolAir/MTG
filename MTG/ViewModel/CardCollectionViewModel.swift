class CardCollectionViewModel {
    private var allCards: [CardModel] = [] // Полный список карт из модели
    var cards: [CardModel] = [] // Текущий список для отображения

    var onCardsUpdated: (() -> Void)? // Callback для обновления UI

    func loadCards() {
        // Имитируем загрузку карт
        allCards = [
            CardModel(imagePath: "card1", cardName: "Card 1", cardColors: [.red], linkedCards: []),
            CardModel(imagePath: "card2", cardName: "Card 2", cardColors: [.blue], linkedCards: []),
            CardModel(imagePath: "card3", cardName: "Card 3", cardColors: [.green], linkedCards: []),
        ]
        cards = allCards
        onCardsUpdated?()
    }

    func selectCard(_ card: CardModel) {
        // Обрабатываем выбор карты (например, сохраняем в хранилище или уведомляем другой экран)
        print("Selected card: \(card.cardName)")
    }
}
