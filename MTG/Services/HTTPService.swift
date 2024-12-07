//
//  HTTPService.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 07.12.2024.
//

import Foundation
import Combine


protocol APIService {
    func fetchCard(from url: URL) -> AnyPublisher<CardModel, Error>
    func fethcDeck(from url: URL) -> AnyPublisher<DeckModel, Error>
    func fetchAllCards(from url: URL) -> AnyPublisher<CardModel, Error> 
}

