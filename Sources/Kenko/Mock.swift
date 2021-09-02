import Combine
import Foundation

public extension Kenko {
  static let mock = Self(
    requestAuth: { _, _ in
      Just(true)
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
    requestAuth: { _, _ in
      Fail(error: .requestAuthorized(nsError))
        .eraseToAnyPublisher()
    }
  )
}
