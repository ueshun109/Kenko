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
    let read = Set(
      [
        HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
        HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        HKObjectType.quantityType(forIdentifier: .height)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        .workoutType()
      ]
    )
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

  func profile() {
    kenko.profile()
      .sink { result in
        print(result)
      } receiveValue: {
        print("result: \($0)")
      }
      .store(in: &self.cancellables)
  }

  func heartRate() {
    let now = Date()
    let aYearAgo = Date(timeInterval: -60 * 60 * 24 * 7, since: now)
    kenko.heartRate(.heartRate, aYearAgo, now, .discreteAverage)
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

  func sleepAnalysis() {
    kenko.sleepAnalysis(.sleepAnalysis, nil, nil)
      .sink { result in
        switch result {
        case .finished:
          print("finished")
        case let .failure(error):
          print("failed: \(error.message)")
        }
      } receiveValue: { samples in
        samples.forEach {
          switch HKCategoryValueSleepAnalysis(rawValue: $0.value) {
          case .asleep: print("result: asleep, start: \($0.startDate)")
          case .awake: print("result: awake, start: \($0.startDate)")
          case .inBed: print("result: inBed, start: \($0.startDate)")
          case .none, .some(_): fatalError()
          }
        }
      }
      .store(in: &self.cancellables)
  }

  func workouts() {
    kenko.workouts(.running, nil, nil, false)
      .sink { result in
        switch result {
        case .finished:
          print("finished")
        case let .failure(error):
          print("failed: \(error.message)")
        }
      } receiveValue: { workouts in
        workouts.forEach {
          print("startDate: \($0.startDate), endDate: \($0.startDate), distance: \($0.totalDistance?.doubleValue(for: .meterUnit(with: .kilo)) ?? 0)")
        }
      }
      .store(in: &self.cancellables)
  }
}
