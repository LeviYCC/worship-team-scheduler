//
//  dataManager.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var members: [BandMember] = []
    @Published var events: [ScheduleEvent] = []
    @Published var configurations: [Configuration] = []
    
    private let membersKey = "bandMembers"
    private let eventsKey = "scheduleEvents"
    private let configurationsKey = "configurations"
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: membersKey),
           let decodedMembers = try? JSONDecoder().decode([BandMember].self, from: data) {
            members = decodedMembers
        }
        
        if let data = UserDefaults.standard.data(forKey: eventsKey),
           let decodedEvents = try? JSONDecoder().decode([ScheduleEvent].self, from: data) {
            events = decodedEvents
        }
        
        if let data = UserDefaults.standard.data(forKey: configurationsKey),
           let decodedConfigurations = try? JSONDecoder().decode([Configuration].self, from: data) {
            configurations = decodedConfigurations
        }
    }
    
    func saveData() {
        if let encodedMembers = try? JSONEncoder().encode(members) {
            UserDefaults.standard.set(encodedMembers, forKey: membersKey)
        }
        
        if let encodedEvents = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encodedEvents, forKey: eventsKey)
        }
        
        if let encodedConfigurations = try? JSONEncoder().encode(configurations) {
            UserDefaults.standard.set(encodedConfigurations, forKey: configurationsKey)
        }
    }
    
    func addMember(
        name: String,
        instruments: [String],
        isPartTime: Bool,
        isIntern: Bool
    ) {
        let newMember = BandMember(
            id: UUID(),
            name: name,
            instruments: instruments,
            isPartTime: isPartTime,
            isIntern: isIntern,
            availability: [:]
        )
        members.append(newMember)
        saveData()
    }
}
