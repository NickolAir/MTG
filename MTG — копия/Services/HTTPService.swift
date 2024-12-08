//
//  HTTPService.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 07.12.2024.
//

import Foundation
import Combine


protocol APIService {
    // TODO: implement fetchDeck
    func fetchCard(from url: URL) -> AnyPublisher<CardModel, Error>
    //func fethcDeck(from url: URL) -> AnyPublisher<DeckModel, Error>
    func fetchAllCards(from url: URL) -> AnyPublisher<[CardModel], Error>
}

class HTTPService: APIService {
    static let shared = HTTPService()
    
    private lazy var session: URLSession = {
           let configuration = URLSessionConfiguration.default
           configuration.timeoutIntervalForRequest = 120 // Время ожидания для запросов (в секундах)
           configuration.timeoutIntervalForResource = 120 // Время ожидания для ресурсов
           return URLSession(configuration: configuration)
       }()
    
    func fetchCard(from url: URL) -> AnyPublisher<CardModel, any Error> {
        //let modifiedURL = url.appendingPathComponent("allcards")
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                // Проверяем статус ответа
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CardModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchAllCards(from url: URL) -> AnyPublisher<[CardModel], any Error> {
        // Добавляем /allcards/ к URL
        let modifiedURL = url.appendingPathComponent("allcards/")
        
        return session.dataTaskPublisher(for: modifiedURL)
            .tryMap { data, response in
                // Проверяем статус ответа
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [CardModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}
