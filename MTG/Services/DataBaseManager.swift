//
//  DataBaseManager.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 07.12.2024.
//

protocol DataBaseManager {
    func getCard(id: Int) -> CardModel?
    func getImagePath(id: Int) -> String?
    func getAllCards() -> [CardModel]
    func insertCard(id: Int, name: String, imageUrl: String) -> Bool
    func insertCards(cards: [CardModel])
}

