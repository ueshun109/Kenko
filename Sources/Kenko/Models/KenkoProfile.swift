import HealthKit

public struct KenkoProfile: Equatable {
  public let biologicalSex: HKBiologicalSex?
  public let birthDate: DateComponents?
  public let bodyMass: Double?
  public let height: Double?

  public init(
    biologicalSex: HKBiologicalSex? = nil,
    birthDate: DateComponents? = nil,
    bodyMass: Double? = nil,
    height: Double? = nil
  ) {
    self.biologicalSex = biologicalSex
    self.birthDate = birthDate
    self.bodyMass = bodyMass
    self.height = height
  }
}
