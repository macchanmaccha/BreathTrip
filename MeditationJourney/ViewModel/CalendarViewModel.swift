//
//  CalendarViewModel.swift
//  MeditationJourney
//
//  Created by apple on 2025/07/21.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    // 瞑想の記録
    @Published var meditationRecords: [CalendarInfo] = []
}