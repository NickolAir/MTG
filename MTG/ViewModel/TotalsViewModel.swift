import Foundation

class TotalsViewModel {
    private var counters: [Counter]
    
    init() {
        self.counters = Array(repeating: Counter(value: 10), count: 4)
    }
    
    func getCounters() -> [Counter] {
        return counters
    }
    
    func increaseCounter(at index: Int) {
        if index < counters.count {
            counters[index].value += 1
        }
    }
    
    func decreaseCounter(at index: Int) {
        if index < counters.count && counters[index].value > 0 {
            counters[index].value -= 1
        }
    }
}
