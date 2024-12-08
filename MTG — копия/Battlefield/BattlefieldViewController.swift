//
//  BattlefieldViewController.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 06.12.2024.
//

import UIKit

class BattlefieldViewController: UIViewController {
    var viewModel: BattlefieldViewModel = BattlefieldViewModel()
    var isOnlinePull: Bool = true
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    lazy var cardView: [CardView] = []
    
    @objc private func addCardButtonTapped() {
        // Открываем экран выбора карты
        let cardCollectionVC = CardCollectionWindowViewController(isOnlinePull: self.isOnlinePull)
        cardCollectionVC.onCardSelected = { [weak self] selectedCard in
            
            //guard let self = self else { return }
            //let newCardView = CardView()
            //self.viewModel.addCard(selectedCard) // Сохраняем карту в массив
            //self.updateUI() // Обновляем интерфейс
        }
        navigationController?.pushViewController(cardCollectionVC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemPurple
    }
    
    private func setupNavigationBar() {
        title = "Stack"
        
        
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addCardButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = plusButton
    }
    
    
    func setupUI() {
        
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        super.viewDidLoad()
    }
    
    
    
    
}

