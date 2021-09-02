import Foundation

public enum KenkoError: Equatable, LocalizedError {
  case requestAuthorized(NSError)

  public var message: String {
    switch self {
    case let .requestAuthorized(error):
      return error.localizedDescription
    }
  }
}
