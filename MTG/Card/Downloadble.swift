//
//  Downloadable.swift
//  Images
//
//  Created by Леонид Шайхутдинов on 24.11.2024.
//

import Foundation
import UIKit
import Combine

protocol Downloadable {
    func loadImage(url: String)
}

extension Downloadable where Self: UIImageView {
    func loadImage(url: String) {
        let cancellable = ImageLoader.shared.fetchImage(url: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Процесс завершен.")
                case .failure(let error):
                    print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                }
            }, receiveValue: { image in
                print("Изображение успешно получено.")
                self.image = image
            })
    }
}

class DownloadableImageView: UIImageView, Downloadable {}

