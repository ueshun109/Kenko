import Combine
import HealthKit
import Foundation

public extension Kenko {
  static let mock = Self(
    heartRate: { _, _, _, _ in
      Just(100)
        .setFailureType(to: KenkoError.self)
        .eraseToAnyPublisher()
    },
    profile: {
      Just(KenkoProfile(
        biologicalSex: .male,
        birthDate: nil,
        bodyMass: 70,
        height: 180
      ))
      .eraseToAnyPublisher()
    },
    requestAuth: { _, _ in
      Just(true)
        .setFailureType(to: KenkoError.self)
        .eraseToAnyPublisher()
    },
    sleepAnalysis:  { _, _, _ in
      let sample = HKCategorySample(
        type: .categoryType(forIdentifier: .sleepAnalysis)!,
        value: 1,
        start: Date(),
        end: Date()
      )
      return Just([sample])
        .setFailureType(to: KenkoError.self)
        .eraseToAnyPublisher()
    },
    workouts: { _, _, _, _ in
      let workout = HKWorkout(activityType: .running, start: Date(), end: Date())
      return Just([workout])
        .setFailureType(to: KenkoError.self)
        .eraseToAnyPublisher()
    }
  )
}

public extension Kenko {
  static let nsError = NSError(
    domain: "com.ueshun.Kenko",
    code: 500,
    userInfo: [NSLocalizedDescriptionKey: "Occurred error"]
  )
  static let failure = Self(
    heartRate: { _, _,_,_  in
      Fail(error: .heartRate(nsError))
        .eraseToAnyPublisher()
    },
    profile: {
      Just(KenkoProfile())
        .eraseToAnyPublisher()
    },
    requestAuth: { _, _ in
      Fail(error: .requestAuthorized(nsError))
        .eraseToAnyPublisher()
    },
    sleepAnalysis:  { _, _, _ in
      Fail(error: .error(nsError))
        .eraseToAnyPublisher()
    },
    workouts:  { _, _, _, _ in
      Fail(error: .error(nsError))
        .eraseToAnyPublisher()
    }
  )
}
