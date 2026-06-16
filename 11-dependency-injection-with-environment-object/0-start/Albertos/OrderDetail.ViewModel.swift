// This is just a placeholder to make working on the screen as
// we progress with the chapters easier.
extension OrderDetail {

  struct ViewModel {
    let headerText = "Your Order"
    let menuItems: [MenuItem] = menu.filter { item in
      item.name.starts(with: "C")
    }
    let totalPriceText = "Total price will go here"
  }
}
