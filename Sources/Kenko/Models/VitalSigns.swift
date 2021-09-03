import HealthKit

public enum VitalSigns {
  public enum HeartRate {
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
}
