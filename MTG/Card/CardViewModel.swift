//
//  CardViewModel.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 06.12.2024.
//

import Foundation

struct CardViewModel {
    var imagePath: String
    let cardName: String
    let cardColors: [CardColor]
    var linkedCards: [CardModel]
    let cardColor: CardColor
}
