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
    }
  )
}
