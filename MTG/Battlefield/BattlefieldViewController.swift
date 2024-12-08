//
//  BattlefieldViewController.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 06.12.2024.
//

import UIKit

class BattlefieldViewController: UIViewController {
    var viewModel: BattlefieldViewModel = BattlefieldViewModel()
    var cardViewContainers: [UIView] = [] // Контейнеры карточек и кнопок
    var cardModels: [CardViewModel] = [] // Хранение моделей карточек с их положением

    // MARK: - Добавление карточки
    @objc private func addCardButtonTapped() {
        let cardCollectionVC = CardCollectionWindowViewController()
        cardCollectionVC.onCardSelected = { [weak self] selectedCard in
            guard let self = self else { return }

            let centerX = self.view.bounds.midX - 75
            let centerY = self.view.bounds.midY - 110

            let cardViewModel = CardViewModel(
                imagePath: selectedCard.picture.url ?? "",
                cardName: selectedCard.name ?? "Default Name",
                cardColors: [.blue],
                linkedCards: [],
                cardColor: .blue,
                position: CGPoint(x: centerX, y: centerY)
            )
            
            self.cardModels.append(cardViewModel)

            let container = self.createCardContainer(with: cardViewModel, at: self.cardModels.count - 1)
            container.frame.origin = cardViewModel.position
            self.view.addSubview(container)
            self.cardViewContainers.append(container)
        }
        navigationController?.pushViewController(cardCollectionVC, animated: true)
    }

    // MARK: - Создание контейнера для карточки
    private func createCardContainer(with viewModel: CardViewModel, at index: Int) -> UIView {

        let container = UIView(frame: CGRect(x: viewModel.position.x, y: viewModel.position.y, width: 150, height: 220))
        container.tag = index // Привязываем индекс модели к контейнеру


        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        container.addGestureRecognizer(panGesture)


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        container.addGestureRecognizer(tapGesture)


        let cardView = CardView(frame: CGRect(x: 15, y: 0, width: 120, height: 150), color: .clear)
        cardView.viewModel = viewModel
        cardView.isUserInteractionEnabled = false
        container.addSubview(cardView)

        let buttonStackView = self.createButtonStackView(for: index)
        buttonStackView.frame = CGRect(x: 15, y: 160, width: 120, height: 40)
        buttonStackView.isUserInteractionEnabled = true
        container.addSubview(buttonStackView)

        return container
    }
    
    // MARK: - Обработка касания
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let container = gesture.view else { return }
        self.view.bringSubviewToFront(container)
        print("Card tapped, brought to front.")
    }

    
    // MARK: - Создание кнопок
    private func createButtonStackView(for index: Int) -> UIStackView {
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        minusButton.backgroundColor = .lightGray
        minusButton.layer.cornerRadius = 5
        minusButton.clipsToBounds = true
        minusButton.tag = index
        minusButton.addTarget(self, action: #selector(minusButtonTapped(_:)), for: .touchUpInside)

        let tButton = UIButton(type: .system)
        tButton.setTitle("T", for: .normal)
        tButton.setTitleColor(.black, for: .normal)
        tButton.backgroundColor = .lightGray
        tButton.layer.cornerRadius = 5
        tButton.clipsToBounds = true
        tButton.tag = index
        tButton.addTarget(self, action: #selector(tButtonTapped(_:)), for: .touchUpInside)

        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        plusButton.backgroundColor = .lightGray
        plusButton.layer.cornerRadius = 5
        plusButton.clipsToBounds = true
        plusButton.tag = index
        plusButton.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [minusButton, tButton, plusButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        return stackView
    }
    
    // MARK: - Обработка нажатия кнопки T
    @objc private func tButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < cardViewContainers.count else { return }

        let container = cardViewContainers[index]
        guard let cardView = container.subviews.first(where: { $0 is CardView }) as? CardView else { return }

        UIView.animate(withDuration: 0.3) {
            if cardView.transform == .identity {
                cardView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            } else {
                cardView.transform = .identity
            }
        }
    }


    // MARK: - Удаление карточки
    @objc private func minusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < cardModels.count else { return }

        cardModels.remove(at: index)
        let container = cardViewContainers.remove(at: index)
        container.removeFromSuperview()

        for (i, container) in cardViewContainers.enumerated() {
            container.tag = i
            if let stackView = container.subviews.first(where: { $0 is UIStackView }) as? UIStackView {
                stackView.arrangedSubviews.enumerated().forEach { subviewIndex, subview in
                    subview.tag = i
                }
            }
        }
    }

    // MARK: - Создание копии карточки
    @objc private func plusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < cardModels.count else { return }

        var copiedModel = cardModels[index]
        copiedModel.position.x += 170
        cardModels.append(copiedModel)

        let container = createCardContainer(with: copiedModel, at: cardModels.count - 1)
        container.frame.origin = copiedModel.position
        view.addSubview(container)
        cardViewContainers.append(container)
    }

    // MARK: - Обработка перемещения
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let container = gesture.view else { return }
        let translation = gesture.translation(in: self.view)

        switch gesture.state {
        case .began:
            self.view.bringSubviewToFront(container)
        case .changed:
            container.center = CGPoint(x: container.center.x + translation.x, y: container.center.y + translation.y)
            gesture.setTranslation(.zero, in: self.view)
        case .ended:
            if let index = cardViewContainers.firstIndex(of: container) {
                cardModels[index].position = CGPoint(x: container.frame.origin.x, y: container.frame.origin.y)
            }
        default:
            break
        }
    }

    private func setupNavigationBar() {
        title = "battlefield"
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addCardButtonTapped)
        )
        navigationItem.rightBarButtonItem = plusButton
    }

    func setupUI() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }
}
