import Foundation

extension Date {
    static var tomorrow: Date {
        let date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        return Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
}
