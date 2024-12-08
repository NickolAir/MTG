//
//  DiskImageStorage.swift
//  Images
//
//  Created by Леонид Шайхутдинов on 24.11.2024.
//

import Foundation
import UIKit
import Combine

class DiskStorage {
    private var fileDirectory: URL? 
    private let concurrentQueue = DispatchQueue(label: "imageManagerQueue", attributes: .concurrent)
    
    static let shared = DiskStorage()
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else {
            return
        }
        
        self.fileDirectory = documentsDirectory
    }
    
    func saveImage(_ image: UIImage, forKey key: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let imageData = image.pngData() else {
                promise(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка преобразования изображения в данные"])))
                return
            }
            
            guard let filePath = self.fileDirectory?.appendingPathComponent(key) else {
                promise(.failure(NSError(domain: "StorageError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка получения пути для сохранения изображения"])))
                return
            }
            
            do {
                try imageData.write(to: filePath)
                print("Изображение \(key) успешно сохранено на диск")
                promise(.success(())) // Успешно записано, возвращаем Void
            } catch {
                print("Ошибка сохранения изображения \(key): \(error.localizedDescription), filePath = \(filePath)")
                promise(.failure(error)) // В случае ошибки передаем ошибку
            }
        }
        .eraseToAnyPublisher() // Возвращаем результат как AnyPublisher
    }
    
    func getImage(forKey: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { promise in
            self.concurrentQueue.async {
                guard let fileDirectory = self.fileDirectory else {
                    DispatchQueue.main.async {
                        promise(.success(nil))
                    }
                    return
                }
                do {
                    let files = try FileManager.default.contentsOfDirectory(at: fileDirectory, includingPropertiesForKeys: nil, options: [])
                    
                    for fileURL in files {
                        let fileName = fileURL.lastPathComponent
                        
                        if fileName == forKey {
                            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    promise(.success(image))
                                }
                                return
                            }
                        }
                    }
                } catch {
                    print("Ошибка считывания содержимого директории: \(error)")
                }
                
                DispatchQueue.main.async {
                    print("Картинка \(forKey) не найдена на диске")
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func clearStorage() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.concurrentQueue.async(flags: .barrier) { // Используем барьер для синхронизации
                guard let fileDirectory = self.fileDirectory else {
                    let error = NSError(domain: "DiskStorageError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Директория для хранения файлов не установлена."])
                    promise(.failure(error))
                    return
                }
                
                do {
                    let files = try FileManager.default.contentsOfDirectory(at: fileDirectory, includingPropertiesForKeys: nil, options: [])
                    for fileURL in files {
                        try FileManager.default.removeItem(at: fileURL)
                    }
                    print("Все данные успешно удалены из хранилища.")
                    promise(.success(())) // Возвращаем успешное завершение
                } catch {
                    print("Ошибка при очистке хранилища: \(error.localizedDescription)")
                    promise(.failure(error)) // Возвращаем ошибку
                }
            }
        }
        .eraseToAnyPublisher() // Преобразуем Future в AnyPublisher
    }
}



