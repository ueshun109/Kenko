import Combine
import Foundation
import HealthKit

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
    },

    profile: {
      let biologicalSex = Future<HKBiologicalSex?, KenkoError> { completion in
        do {
          let sex = try healthStore.biologicalSex().biologicalSex
          completion(.success(sex))
        } catch {
          completion(.failure(.profile(error as NSError)))
        }
      }
      .catch { error -> AnyPublisher<HKBiologicalSex?, Never> in
        print(error.localizedDescription)
        return Just(nil).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
      
      let birthDate = Future<DateComponents?, KenkoError> { completion in
        do {
          let date = try healthStore.dateOfBirthComponents()
          completion(.success(date))
        } catch {
          completion(.failure(.profile(error as NSError)))
        }
      }
      .catch { error -> AnyPublisher<DateComponents?, Never> in
        print(error.localizedDescription)
        return Just(nil).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

      let bodyMass = Future<Double?, KenkoError> { completion in
        let dataType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
          sampleType: dataType,
          predicate: nil,
          limit: HKObjectQueryNoLimit,
          sortDescriptors: [sortDescriptor]
        ) { query, result, error in
          guard let sample = result?.first,
                let quantitySample = sample as? HKQuantitySample
          else { completion(.failure(.notFound)); return }
          let latestHeight = quantitySample.quantity.doubleValue(for: .gramUnit(with: .kilo))
          completion(.success(latestHeight))
        }
        healthStore.execute(query)
      }
      .catch { error -> AnyPublisher<Double?, Never> in
        print(error.localizedDescription)
        return Just(nil).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

      let height = Future<Double?, KenkoError> { completion in
        let dataType = HKObjectType.quantityType(forIdentifier: .height)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
          sampleType: dataType,
          predicate: nil,
          limit: HKObjectQueryNoLimit,
          sortDescriptors: [sortDescriptor]
        ) { query, result, error in
          guard let sample = result?.first,
                let quantitySample = sample as? HKQuantitySample
          else { completion(.failure(.notFound)); return }
          let latestHeight = quantitySample.quantity.doubleValue(for: .meterUnit(with: .centi))
          completion(.success(latestHeight))
        }
        healthStore.execute(query)
      }
      .catch { error -> AnyPublisher<Double?, Never> in
        print(error.localizedDescription)
        return Just(nil).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

      let zipped = biologicalSex.zip(birthDate, bodyMass, height)
      return zipped.map { sex, birthDate, bodyMass, height -> KenkoProfile in
        KenkoProfile(biologicalSex: sex, birthDate: birthDate, bodyMass: bodyMass, height: height)
      }
      .eraseToAnyPublisher()
    },

    heartRate: { type, startDate, endDate, option in
      Future { completion in
        let predicate = HKQuery.predicateForSamples(
          withStart: startDate,
          end: endDate,
          options: .strictStartDate
        )
        let query = HKStatisticsQuery(
          quantityType: type.dataType,
          quantitySamplePredicate: predicate,
          options: option
        ) { _, statistics, error in
          if let error = error {
            logger.error("\(error.localizedDescription)")
            completion(.failure(.heartRate(error as NSError)))
          } else {
            var value: Double?
            switch option {
            case .discreteAverage:
              value = statistics!.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
            case .discreteMax:
              value = statistics!.maximumQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
            case .discreteMin:
              value = statistics!.minimumQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
            default: break
            }
            completion(.success(value ?? 0))
          }
        }
        healthStore.execute(query)
      }
      .eraseToAnyPublisher()
    }
  )
}
