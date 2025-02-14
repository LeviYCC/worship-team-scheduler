//
//  models.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import Foundation

struct BandMember: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var instruments: [String]
    var availability: [Date: Bool]
}

struct ScheduleEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var serviceType: ServiceType
    var assignments: [RoleAssignment]
}

struct RoleAssignment: Identifiable, Codable, Hashable {
    let id: UUID
    var role: Role
    var memberIds: [UUID]
}

struct Configuration: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var roles: [Role]
    var singerCount: Int
}

enum ServiceType: String, Codable, Hashable {
    case sundayService = "Sunday Service"
    case saturdayService = "Saturday Service"
    case special = "Special Service"
}

enum Role: String, Codable, Hashable, CaseIterable {
    case wl = "WL"
    case drum = "Drum/Percussion"
    case bass = "Bass"
    case piano = "Piano"
    case ag = "AG"
    case egViolin = "EG/Violin"
    case singer = "SINGER"
    case rap = "Rap"
    case sound = "Sound"
    case ppt = "PPT"
}

extension Date {
    var isWeekend: Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday == 1  // 1 表示週日
    }
}
