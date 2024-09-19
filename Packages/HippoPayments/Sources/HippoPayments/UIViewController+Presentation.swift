#if canImport(UIKit)
import UIKit
#endif

extension UIViewController {

    /// Travels the `presentedViewController` hierarchy backwards till it finds the topmost one.
    var viewControllerPresentationSource: UIViewController {
        guard let presentedViewController = self.presentedViewController else { return self }

        return presentedViewController.viewControllerPresentationSource
    }
}
