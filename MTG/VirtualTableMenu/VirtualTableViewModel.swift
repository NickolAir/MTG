import Foundation

class VirtualTableViewModel {

    var stackBatllefieldSwitchOption: Bool = false
    var offlineSwitchOption: Bool = false
    
    // Замыкания для передачи обновлений в ViewController
    var stackBattlefieldOptionChange: ((Bool) -> Void)?
    var offlineOptionChange: ((Bool) -> Void)?
    var onStartAction: (() -> Void)?
    
    func toggleStackBattlefieldOption(to value: Bool) {
        stackBatllefieldSwitchOption = value
        stackBattlefieldOptionChange?(value)
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
