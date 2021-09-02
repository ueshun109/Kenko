import Foundation

public enum KenkoError: Equatable, LocalizedError {
  case notFound
  case profile(NSError)
  case requestAuthorized(NSError)

  public var message: String {
    switch self {
    case .notFound:
      return "Not found"
    case let .profile(error):
      return error.localizedDescription
    case let .requestAuthorized(error):
      return error.localizedDescription
    }
  }
}
