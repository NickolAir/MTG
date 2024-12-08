//
//  DataSyncService.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 08.12.2024.
//
import Foundation
import Combine

class DataSyncService {
    var DBManager: DataBaseManager
    var APIService: APIService
    
    var cards: [CardModel] = []
    
    private var cancellables: Set<AnyCancellable> = [] // Хранилище подписок Combine
    
    let serverURL = "http://37.46.135.99"
    
    static let shared = DataSyncService(DBManager: SQLiteManager(), APIService: HTTPService())
    
    func fetchAllCards() -> AnyPublisher<Void, Error> {
        guard let serverURL = URL(string: serverURL) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 400, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return APIService.fetchAllCards(from: serverURL) // Получаем карты с сервера
            .handleEvents(receiveOutput: { [weak self] cards in
                // Сохраняем полученные карты во временную переменную
                self?.cards = cards
                // Логируем
                print("Полученные карты (\(cards.count)):")
                cards.forEach { card in
                    print("ID: \(card.id), Name: \(card.name)")
                }
            })
            .flatMap { [weak self] cards in
                // Вставляем карты в базу данных
                guard let self = self else {
                    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                
                // Асинхронно вставляем данные в базу на фоновом потоке
                return Future { promise in
                    DispatchQueue.global(qos: .background).async {
                        self.DBManager.insertCards(cards: cards)
                        print("Карты успешно добавлены в базу данных.")
                        promise(.success(())) // Завершаем
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
    init(DBManager: DataBaseManager, APIService: APIService) {
        self.APIService = APIService
        self.DBManager = DBManager
    }
}
