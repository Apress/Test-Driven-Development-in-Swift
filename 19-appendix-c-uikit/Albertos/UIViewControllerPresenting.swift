import UIKit

/// Describes the ability of presenting and dismissing a `UIViewController` modally on top of the
/// current screen.
///
/// Tests can implement a double for this and bypass stateful window management.
protocol UIViewControllerModalPresenting {

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)

    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension UIViewController: UIViewControllerModalPresenting {}
