import Foundation

class ViewModel {

    var onNavigateToVirtualTabletop: (() -> Void)?
    var onNavigateToTotals: (() -> Void)?
    var onNavigateToManaPool: (() -> Void)?
    
    func navigateToVirtualTabletop() {
        onNavigateToVirtualTabletop?()
    }
    
    func navigateToTotals() {
        onNavigateToTotals?()
    }
    
    func navigateToManaPool() {
        onNavigateToManaPool?()
    }
}
