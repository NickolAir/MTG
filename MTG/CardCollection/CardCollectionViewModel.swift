class CardCollectionViewModel {
    private var allCards: [CardModel] = [] // Полный список карт из модели
    var cards: [CardModel] = [] // Текущий список для отображения

    var onCardsUpdated: (() -> ())? // Callback для обновления UI

    func loadCards() {
        // Имитируем загрузку карт
        allCards = [
            CardModel(id: 0, imageUrl: "card1", cardName: "Card 1"),
            CardModel(id: 1, imageUrl: "card2", cardName: "Card 2"),
            CardModel(id: 2, imageUrl: "card3", cardName: "Card 3"),
        ]
        cards = allCards
        onCardsUpdated?()
    }
}
