import Foundation

public enum KenkoError: Equatable, LocalizedError {
  case error(NSError)
  case heartRate(NSError)
  case notFound
  case profile(NSError)
  case requestAuthorized(NSError)

  public var message: String {
    switch self {
    case let .error(error):
      return error.localizedDescription
    case let .heartRate(error):
      return error.localizedDescription
    case .notFound:
      return "Not found"
    case let .profile(error):
      return error.localizedDescription
    case let .requestAuthorized(error):
      return error.localizedDescription
    }
  }
}
