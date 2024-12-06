//
//  CardView.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 06.12.2024.
//
import UIKit

class CardView: UIView {
    var viewModel: CardViewModel? {
        didSet {
            
        }
    }
    
    init(frame: CGRect, color: UIColor) {
            super.init(frame: frame)
            self.backgroundColor = color
            self.layer.cornerRadius = 10
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.shadowRadius = 4
            addPanGesture()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func addPanGesture() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            self.addGestureRecognizer(panGesture)
        }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: self.superview)
            
            switch gesture.state {
            case .began, .changed:
                // Изменяем центр карты на основе движения пальца
                self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
                gesture.setTranslation(.zero, in: self.superview)
            case .ended:
                // Можно добавить логику "привязки" карты к определенной зоне или ячейке
                break
            default:
                break
            }
        }
}
