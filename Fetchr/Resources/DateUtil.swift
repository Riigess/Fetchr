//
//  DateUtil.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/29/24.
//

import Foundation

class DateUtil {
    func getUTCDiffString() -> String {
        let diff = TimeZone.current.secondsFromGMT() / (60 * 60)
        let hourDiff = Int(diff)
        var strHourDiff = hourDiff < 10 ? "0\(abs(hourDiff))" : "\(abs(hourDiff))"
        if hourDiff < 0 {
            strHourDiff = "-\(strHourDiff)"
        } else {
            strHourDiff = "+\(strHourDiff)"
        }
        let minDiff = abs(Int((diff * 60) % 60))
        let strMinDiff = minDiff < 10 ? "0\(abs(minDiff))" : "\(abs(minDiff))"
        return "\(strHourDiff):\(strMinDiff)"
    }
    
    func convertFromUTCToTimeZone(date:Date = Date(), timeZone:TimeZone = .current) -> String {
        let format = DateFormatter()
        format.timeZone = timeZone
        format.dateFormat = "yyyy-MM-dd HH:mm:ss \(getUTCDiffString())"
        let timeZoneOffsetDate = format.string(from: date)
        return timeZoneOffsetDate.description
    }
}
