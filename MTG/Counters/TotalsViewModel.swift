import UIKit

class TotalsViewModel {
    private var counterGroups: [[Counter]]
    private var currentGroupIndex = 0

    init() {
        // Группы счетчиков для Health, Toxic, Commander
        self.counterGroups = [
            Array(repeating: Counter(value: 40, type: .health), count: 4),
            Array(repeating: Counter(value: 5, type: .toxic), count: 4),
            Array(repeating: Counter(value: 20, type: .commander), count: 4)
        ]
    }
    
    func getCurrentCounters() -> [Counter] {
        return counterGroups[currentGroupIndex]
    }
    
    func increaseCounter(at index: Int) {
        if index < counterGroups[currentGroupIndex].count {
            counterGroups[currentGroupIndex][index].value += 1
        }
    }
    
    func decreaseCounter(at index: Int) {
        if index < counterGroups[currentGroupIndex].count && counterGroups[currentGroupIndex][index].value > 0 {
            counterGroups[currentGroupIndex][index].value -= 1
        }
    }
    
    func switchToNextGroup() {
        currentGroupIndex = (currentGroupIndex + 1) % counterGroups.count
    }
    
    func getCurrentGroupTitle() -> String {
        return counterGroups[currentGroupIndex].first?.type.rawValue ?? ""
    }
    
    func refreshCounters() {
        for groupIndex in 0..<counterGroups.count {
            for counterIndex in 0..<counterGroups[groupIndex].count {
                var counter = counterGroups[groupIndex][counterIndex]
                switch counter.type {
                case .health:
                    counter.value = 40
                case .commander:
                    counter.value = 20
                case .toxic:
                    counter.value = 5
                }
                counterGroups[groupIndex][counterIndex] = counter 
            }
        }
    }
}
