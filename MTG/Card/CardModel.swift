struct CardModel: Codable {
    let id: Int
    let imagePath: String
    let cardName: String
    //let cardColors: [CardColor]
    //var linkedCards: [CardModel]
}

enum CardColor: String {
    case white
    case blue
    case black
    case red
    case green
}

