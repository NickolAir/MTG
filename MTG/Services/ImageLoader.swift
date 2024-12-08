//  ImageLoader.swift
//  Images
//
//  Created by Леонид Шайхутдинов on 24.11.2024.
//
import Foundation
import UIKit
import Combine

class ImageLoader {
    private var activeRequests = [NSString: [((UIImage?) -> Void)]]()
    static let shared = ImageLoader()
    let dbManager = SQLiteManager()

    func fetchImage(id: Int) -> AnyPublisher<UIImage, Error> {
        guard let url = dbManager.getImageUrl(id: id) else {
            return Fail<UIImage, Error>(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        guard let imageURL = URL(string: url) else {
            return Fail<UIImage, Error>(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return CacheStorage.shared.getImage(forKey: "CardImage_\(id)")
            .flatMap { image -> AnyPublisher<UIImage, Error> in
                if let image = image {
                    // Картинка найдена в кэше
                    print("Изображение id: \(id) загружено из кэша")
                    return Just(image)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return DiskStorage.shared.getImage(forKey: "CardImage_\(id)")
                        .flatMap { image -> AnyPublisher<UIImage, Error> in
                            if let image = image {
                                // Картинка найдена на диске
                                print("Изображение id: \(id) загружено с диска")
                                return Just(image)
                                    .setFailureType(to: Error.self)
                                    .eraseToAnyPublisher()
                            } else {
                                
                                // Картинка не найдена, скачиваем с сервера
                                return URLSession.shared.dataTaskPublisher(for: imageURL)
                                    .tryMap { data, response -> UIImage in
                                        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                                            throw URLError(.badServerResponse)
                                        }
                                        guard let image = UIImage(data: data) else {
                                            throw URLError(.cannotDecodeContentData)
                                        }
                                        print("Изображение id: \(id) загружено с сервера")
                                        // Сохраняем изображение на диск
                                        let fileName = "CardImage_\(id)"
                                        CacheStorage.shared.saveImage(image, forKey: fileName)
                                        return image
                                    }
                                    .eraseToAnyPublisher()
                            }
                        }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
       
    }
}

