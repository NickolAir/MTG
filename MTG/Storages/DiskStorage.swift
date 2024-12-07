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
    
    func saveImage(_ image: UIImage, forKey key: String) {
        concurrentQueue.async(flags: .barrier) {
            if let imageData = image.pngData() {
                if let filePath = self.fileDirectory?.appendingPathComponent("\(key)") {
                    do {
                        try imageData.write(to: filePath)
                    } catch {
                        print("Ошибка сохранения изображения \(key): \(error.localizedDescription)")
                    }
                }
            }
        }
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
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}



