import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    // Mindful Session 類型
    private let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
    
    // 授權狀態
    @Published var isAuthorized: Bool = false
    
    private init() {}
    
    // 檢查 HealthKit 是否可用
    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    // 請求授權
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToShare: Set = [mindfulType]
        let typesToRead: Set = [mindfulType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                completion(success)
            }
        }
    }
    
    // 查詢授權狀態
    func checkAuthorizationStatus() {
        let status = healthStore.authorizationStatus(for: mindfulType)
        DispatchQueue.main.async {
            self.isAuthorized = (status == .sharingAuthorized)
        }
    }
} 