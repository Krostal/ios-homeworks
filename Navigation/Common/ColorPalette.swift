

import UIKit

public struct ColorPalette {
    
    static var textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
    
    static var labelColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .black)

    static var resultTextColor = UIColor.createColor(lightMode: .green, darkMode: .systemGreen)

    static var feedViewBackgroundColor = UIColor.createColor(lightMode: .lightGray, darkMode: .darkGray)
    
    static var profileBackgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
    
    static var borderColor = UIColor.createColor(lightMode: .black, darkMode: .white)
    
    static var shadowColor = UIColor.createColor(lightMode: .black, darkMode: .lightGray)
    
}


extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode :
            darkMode
        }
    }
}
