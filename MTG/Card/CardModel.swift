import Foundation
struct CardModel: Decodable {
    let id: Int
    let imageUrl: String
    let name: String
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

