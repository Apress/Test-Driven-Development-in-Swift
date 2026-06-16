import Foundation

struct AlertViewModel: Identifiable {

  let titleText: String
  let messageText: String
  let dismissButtonText: String
  let dismissButtonAction: () -> Void

  // For Identifiable conformance
  let id = UUID()
}
