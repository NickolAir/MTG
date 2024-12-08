//
//  CacheStorage.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 09.12.2024.
//

import UIKit
import Combine

class CacheStorage {
    // Создаем кэш для хранения изображений
    private let imageCache = NSCache<NSString, UIImage>()
    
    // Синглтон для глобального доступа
    static let shared = CacheStorage()
    
    private init() {
        // Настроим кэш для изображения (неограниченное количество элементов и размер)
        imageCache.countLimit = 100  // Максимальное количество изображений в кэше
        imageCache.totalCostLimit = 50 * 1024 * 1024 // Ограничение по общему объему (50 MB)
    }
    
    // Метод для сохранения изображения в кэш
    func saveImage(_ image: UIImage, forKey key: String) {
        // Преобразуем ключ в NSString, чтобы использовать его в качестве ключа для NSCache
        let cacheKey = NSString(string: key)
        imageCache.setObject(image, forKey: cacheKey)
    }
    
    // Метод для получения изображения по ключу
    func getImage(forKey key: String) -> AnyPublisher<UIImage?, Never> {
            Future<UIImage?, Never> { promise in
                // Пытаемся получить изображение из кэша
                if let image = self.imageCache.object(forKey: NSString(string: key)) {
                    // Если изображение найдено, передаем его в promise
                    promise(.success(image))
                } else {
                    // Если изображение не найдено, создаем ошибку
                    promise(.success(nil))
                }
            }
            .eraseToAnyPublisher()
        }
    
    // Метод для удаления изображения из кэша
    func removeImage(forKey key: String) {
        let cacheKey = NSString(string: key)
        imageCache.removeObject(forKey: cacheKey)
    }
    
    // Метод для очистки всего кэша
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
