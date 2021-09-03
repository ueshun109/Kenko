import Kenko
import SwiftUI

struct ContentView: View {
  private let viewModel: ViewModel

  init(kenko: Kenko = .live) {
    self.viewModel = ViewModel(kenko: kenko)
  }

  var body: some View {
    List {
      Button("Request Authorization") {
        viewModel.requestAuth()
      }
      Button("Profile") {
        viewModel.profile()
      }
      Button("heartRate") {
        viewModel.heartRate()
      }
      Button("sleepAnalysis") {
        viewModel.sleepAnalysis()
      }
      Button("workouts") {
        viewModel.workouts()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
