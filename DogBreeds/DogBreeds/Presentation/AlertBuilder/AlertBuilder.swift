
import UIKit

typealias ConfirmHandler = () -> Void
typealias CancelHandler = () -> Void

final class AlertBuilder: NSObject {

    public static func successAlertWithMessage(message: String?) {
        self.alertWithTitle(title: Strings.Alert.success, message: message, cancelButtonShow: false, confirmHandler: nil)
    }

    public static func failureAlertWithMessage(message: String?) {
        self.alertWithTitle(title: Strings.Alert.error, message: message, cancelButtonShow: false, confirmHandler: nil)
    }

    public static func alertWithTitle(title: String?, message: String?, cancelButtonShow: Bool, confirmHandler: ConfirmHandler?) {
        let alert = prepareAlert(title: title, message: message)
        addAction(alert: alert, title: Strings.Alert.okay, style: .default, handler: confirmHandler)

        if(cancelButtonShow) {
            addAction(alert: alert, title: Strings.Alert.cancel, style: .cancel)
        }
        showAlert(alert: alert)
    }

    static func prepareAlert(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }

    private static func showAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.topMostController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// To get the topMost visible viewController
    ///
    /// - returns:  An optional top most viewController of the application
    static func topMostController() -> UIViewController? {
        var topController: UIViewController? = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
        while (topController?.presentedViewController != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }

    static func addAction(alert: UIAlertController, title: String?, style: UIAlertAction.Style, handler: ConfirmHandler? = nil) {
        alert.addAction(UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        }))
    }
}
