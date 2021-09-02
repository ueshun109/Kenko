import Combine
import Foundation

public extension Kenko {
  static let mock = Self(
    requestAuth: { _, _ in
      Just(true)
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
    requestAuth: { _, _ in
      Fail(error: .requestAuthorized(nsError))
        .eraseToAnyPublisher()
    },
    profile: {
      Just(KenkoProfile())
        .eraseToAnyPublisher()
    }
  )
}
