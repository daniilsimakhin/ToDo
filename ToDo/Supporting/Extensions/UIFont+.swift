import UIKit

extension UIFont {
    static let regularCaption: UIFont = {
        var font = UIFont()
        font = .systemFont(ofSize: 15, weight: .regular)
        return font
    }()
    
    static let boldCaption: UIFont = {
        var font = UIFont()
        font = .systemFont(ofSize: 15, weight: .bold)
        return font
    }()
    
    static let regularBody: UIFont = {
        var font = UIFont()
        font = .systemFont(ofSize: 17.5, weight: .regular)
        return font
    }()
}
