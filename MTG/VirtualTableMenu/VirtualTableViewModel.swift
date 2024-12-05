import Foundation

class VirtualTableViewModel {

    var stackSwitchOption: Bool = false
    var offlineSwitchOption: Bool = false
    
    // Замыкания для передачи обновлений в ViewController
    var stackOptionChange: ((Bool) -> Void)?
    var offlineOptionChange: ((Bool) -> Void)?
    var onStartAction: (() -> Void)?
    
    func toggleStackOption(to value: Bool) {
        stackSwitchOption = value
        stackOptionChange?(value)
    }
    
    func toggleOfflineOption(to value: Bool) {
        offlineSwitchOption = value
        offlineOptionChange?(value)
    }
    
    func start() {
        // Логика запуска 
        onStartAction?()
    }
}
