import HealthKit

public enum MindfulnessAndSleep: Equatable {
  case mindfulness
  case sleepAnalysis

  public var dataType: HKCategoryType {
    switch self {
    case .mindfulness:
      return .categoryType(forIdentifier: .mindfulSession)!
    case .sleepAnalysis:
      return .categoryType(forIdentifier: .sleepAnalysis)!
    }
  }
}
