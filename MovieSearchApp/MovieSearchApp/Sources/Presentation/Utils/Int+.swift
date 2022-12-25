//
//  Int+.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/26.
//

import UIKit

extension Int {
    var scoreColor: UIColor {
        switch self {
        case 10..<40:
            return #colorLiteral(red: 0.8580227494, green: 0.1387358606, blue: 0.376103878, alpha: 1)
        case 40..<70:
            return #colorLiteral(red: 0.8258035183, green: 0.8347414136, blue: 0.1893455088, alpha: 1)
        case 70...100:
            return #colorLiteral(red: 0.129681617, green: 0.8139942288, blue: 0.4788435698, alpha: 1)
        default:
            return #colorLiteral(red: 0.3585988581, green: 0.3486848176, blue: 0.3488636017, alpha: 1)
        }
    }
}
