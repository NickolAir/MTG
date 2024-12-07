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

    func fetchImage(url: String) -> AnyPublisher<UIImage, Error> {
        DiskStorage.shared.getImage(forKey: url)
            .flatMap { image -> AnyPublisher<UIImage, Error> in
                if let image = image {
                    // Картинка найдена на диске
                    return Just(image)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    // Картинка не найдена, скачиваем с сервера
                    return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
                        .tryMap { data, response -> UIImage in
                            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                                throw URLError(.badServerResponse)
                            }
                            guard let image = UIImage(data: data) else {
                                throw URLError(.cannotDecodeContentData)
                            }
                            // Сохраняем изображение на диск
                            DiskStorage.shared.saveImage(image, forKey: url)
                            return image
                        }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

