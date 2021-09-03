import Combine
import Foundation
import HealthKit
import os

internal let logger = Logger(subsystem: "com.ueshun.Kenko", category: "log")
internal let healthStore = HKHealthStore()

public struct Kenko {
  public var heartRate: (
    _ type: VitalSigns.HeartRate.Quantity,
    _ startDate: Date,
    _ endDate: Date,
    HKStatisticsOptions
  ) -> AnyPublisher<Double, KenkoError>

  public var profile: () -> AnyPublisher<KenkoProfile, Never>

  public var requestAuth: (
    _ save: Set<HKSampleType>?,
    _ read: Set<HKObjectType>?
  ) -> AnyPublisher<Bool, KenkoError>

  public var sleepAnalysis: (
    _ type: MindfulnessAndSleep,
    _ startDate: Date?,
    _ endDate: Date?
  ) -> AnyPublisher<[HKCategorySample], KenkoError>

  public var workouts: (
    _ type: HKWorkoutActivityType,
    _ startDate: Date?,
    _ endDate: Date?,
    _ ownAppOnly: Bool
  ) -> AnyPublisher<[HKWorkout], KenkoError>
}
