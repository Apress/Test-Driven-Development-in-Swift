import SwiftUI

struct TextButton: View {

  let action: () -> Void
  let text: String

  var body: some View {
    Button(action: action) {
      Text(text)
        .font(.callout.bold())
        .padding(12)
        .background(.red)
        .tint(.white)
        .cornerRadius(10.0)
    }
  }
}
