//
//  ExtensionString.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import Foundation

extension String {

    public var date: String {
        
        let formatter = DateFormatter()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]

        guard let date = isoDateFormatter.date(from: self) else { return "" }
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                formatter.dateFormat = "h:mm a"
                return formatter.string(from: date)
            } else {
                formatter.dateFormat = "MMM, EEEE"
                return formatter.string(from: date)
            }
        } else {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }

    }

    private func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}
