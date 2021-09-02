import Combine
import Foundation
import HealthKit
import os

internal let logger = Logger(subsystem: "com.ueshun.Kenko", category: "log")
internal let healthStore = HKHealthStore()

public struct Kenko {
  public var requestAuth: (
    _ save: Set<HKSampleType>?,
    _ read: Set<HKObjectType>?
  ) -> AnyPublisher<Bool, KenkoError>

  public var profile: () -> AnyPublisher<KenkoProfile, Never>
}
