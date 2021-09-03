import HealthKit

public enum VitalSigns {
  public enum HeartRate {
    public enum Quantity {
      case heartRate
      case restingHeartRate
      case walkingHeartRateAverage

      public var dataType: HKQuantityType {
        switch self {
        case .heartRate:
          return .quantityType(forIdentifier: .heartRate)!
        case .restingHeartRate:
          return .quantityType(forIdentifier: .restingHeartRate)!
        case .walkingHeartRateAverage:
          return .quantityType(forIdentifier: .walkingHeartRateAverage)!
        }
      }
    }
    public enum CategoryType {
      case lowHeartRateEvent
      case highHeartRateEvent
      case irregularHeartRhythmEvent

      public var dataType: HKCategoryType {
        switch self {
        case .lowHeartRateEvent:
          return .categoryType(forIdentifier: .lowHeartRateEvent)!
        case .highHeartRateEvent:
          return .categoryType(forIdentifier: .highHeartRateEvent)!
        case .irregularHeartRhythmEvent:
          return .categoryType(forIdentifier: .irregularHeartRhythmEvent)!
        }
      }
    }
  }
}
