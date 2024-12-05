import Foundation

class ViewModel {

    var onNavigateToVirtualTabletop: (() -> Void)?
    var onNavigateToTotals: (() -> Void)?
    
    func navigateToVirtualTabletop() {
        onNavigateToVirtualTabletop?()
    }
    
    func navigateToTotals() {
        onNavigateToTotals?()
    }
}
