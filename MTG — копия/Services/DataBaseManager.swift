//
//  DataBaseManager.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 07.12.2024.
//
import Combine

protocol DataBaseManager {
    func getCard(id: Int) -> CardModel?
    func getImageUrl(id: Int) -> String?
    func getAllCards() -> AnyPublisher<[CardModel], Error>
    func insertCard(id: Int, name: String, picture: CardModel.Picture) -> Bool
    func insertCards(cards: [CardModel])
    func printAllCards()
    func deleteAllData()
}

