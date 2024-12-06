//
//  BattlefieldViewController.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 06.12.2024.
//

import UIKit

class BattlefieldViewController: UIViewController {
    var viewModel: BattlefieldViewModel = BattlefieldViewModel()
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addCardButtonTapped() {
        // Открываем экран выбора карты
        let cardCollectionVC = CardCollectionWindowViewController()
        cardCollectionVC.onCardSelected = { [weak self] selectedCard in
            guard let self = self else { return }
            //self.viewModel.addCard(selectedCard) // Сохраняем карту в массив
            //self.updateUI() // Обновляем интерфейс
        }
        navigationController?.pushViewController(cardCollectionVC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemPurple
    }
    
    private func setupNavigationBar() {
        title = "Stack"
        
        // Кнопка возврата - стрелка
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"), // Стрелка назад
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        let plusButton = UIBarButtonItem(
            title: "+",
            style: .plain,
            target: self,
            action: #selector(addCardButtonTapped)
        )
    }
    
    
    func setupUI() {
        
    }
    
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
    }
    
    
    
    
}

