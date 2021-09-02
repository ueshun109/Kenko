import Combine
import HealthKit
import Kenko

final class ViewModel {
  private let kenko: Kenko
  private var cancellables: [AnyCancellable] = []

  init(kenko: Kenko) {
    self.kenko = kenko
  }

  func requestAuth() {
    let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
    kenko.requestAuth([.workoutType()], read)
      .sink { result in
        switch result {
        case .finished:
          print("finished")
        case let .failure(error):
          print("failed: \(error.message)")
        }
      } receiveValue: {
        print("result: \($0)")
      }
      .store(in: &self.cancellables)
  }
}
