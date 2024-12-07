import Foundation
struct CardModel: Decodable {
    
    struct Picture: Decodable {
        let id: Int?
        let url: String?
    }
    let id: Int?
    let name: String?
    let picture: Picture
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

