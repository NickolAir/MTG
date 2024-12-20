import UIKit

class ManaViewModel {
    // Observable массив счетчиков маны
    private(set) var manaCounters: [Int] = [0, 0, 0, 0, 0]
    
    // Массив изображений типов маны
    let manaImages: [UIImage?] = [
        UIImage(named: "mana1"),
        UIImage(named: "mana2"),
        UIImage(named: "mana3"),
        UIImage(named: "mana4"),
        UIImage(named: "mana5")
    ]
    
    // Closure для обновления UI
    var onManaUpdated: ((Int, Int) -> Void)?
    
    func incrementMana(for index: Int) {
        guard index >= 0 && index < manaCounters.count else { return }
        manaCounters[index] += 1
        onManaUpdated?(index, manaCounters[index])
    }
    
    func decrementMana(for index: Int) {
        guard index >= 0 && index < manaCounters.count, manaCounters[index] > 0 else { return }
        manaCounters[index] -= 1
        onManaUpdated?(index, manaCounters[index])
    }
}
