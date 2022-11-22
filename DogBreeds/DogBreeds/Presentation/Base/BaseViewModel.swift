
import Foundation

protocol BaseViewModelToViewDelegate: AnyObject {
    func updateUI()
    func showError(error: Error)
    func showLoading(_ loading: Bool)
}

class BaseViewModel {}
