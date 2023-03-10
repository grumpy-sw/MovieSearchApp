//
//  TimeWindow.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

enum TimeWindow: String {
    case day
    case week
    
    var path: String {
        switch self {
        case .day:
            return "/day"
        case .week:
            return "/week"
        }
    }
}
