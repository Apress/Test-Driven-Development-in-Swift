import UIKit

public class HippoPaymentsProcessor {

    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func processPayment(
        payload: [String: Any],
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (HippoPaymentsError) -> Void
    ) {
        let vc = HippoPaymentsConfirmationViewController()
        vc.onDismiss = onSuccess
        UIApplication.shared.windows.first?.rootViewController?
            .viewControllerPresentationSource.present(vc, animated: true, completion: .none)
    }
}
