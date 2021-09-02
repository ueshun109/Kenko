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
}

public extension Kenko {
  static let live = Self(
    requestAuth: { save, read in
      Future { completion in
        healthStore.requestAuthorization(
          toShare: save,
          read: read
        ) { result, error in
          if let error = error {
            completion(.failure(.requestAuthorized(error as NSError)))
            logger.error("Request Authorization failed.")
          } else {
            completion(.success(result))
          }
        }
      }
      .eraseToAnyPublisher()
    }
  )
}
