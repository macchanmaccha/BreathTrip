////
////  CalendarView.swift
////  MeditationJourney
////
////  Created by apple on 2023/09/17.
////
import SwiftUI
//
struct CalendarView: View {
    @EnvironmentObject var eventStore: EventStore
    var body: some View {
        Text("")
        //        // 遠い過去、未来を表示
        //        CalendarViewModel(interval: DateInterval(start: .distantPast, end: .distantFuture), eventStore: eventStore)
    }
}
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
