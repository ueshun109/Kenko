import Kenko
import SwiftUI

struct ContentView: View {
  private let viewModel: ViewModel

  init(kenko: Kenko = .live) {
    self.viewModel = ViewModel(kenko: kenko)
  }

  let items = ["Request Authorization"]
  var body: some View {
    List {
      ForEach(items, id: \.self) { item in
        Button(item) {
          viewModel.requestAuth()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
