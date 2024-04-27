////
////  CalendarView.swift
////  MeditationJourney
////
////  Created by apple on 2023/09/17.
////
//
//import SwiftUI
//
//// SwiftUIのUIViewRepresentableプロトコルを実装したCalendarViewModel構造体を定義
//struct CalendarViewModel: UIViewRepresentable {
//    // 日付の間隔を管理するプロパティ
//    let interval: DateInterval
//    @ObservedObject var eventStore: EventStore
//    /// UICalendarViewを生成するメソッド
//    func makeUIView(context: Context) -> UICalendarView {
//        /// UICalendarViewのインスタンス
//        let view = UICalendarView()
////        view.delegate = context.coordinator
//        view.calendar = Calendar(identifier: .gregorian)
//        view.availableDateRange = interval
//        // 作成したUICalendarViewを返す
//        return view
//    } // func makeUIViewここまで
//    func makeCoordinator() -> () {
////        Coordinator(parent: self, eventStore: _eventStore)
//    }
//    /// UICalendarViewの更新時の処理
//    func updateUIView(_ uiView: UICalendarView, context: Context) {
//    } // func updateUIViewここまで
//} // struct CalendarViewModelここまで
///// delegateのクラス
//class Coordinate: NSObject, UICalendarViewDelegate {
//    var parent: CalendarView
//    @ObservedObject var eventStore: EventStore
//    init(parent: CalendarView, eventStore: ObservedObject<EventStore>) {
//        self.parent = parent
//        self._eventStore = eventStore
//    }
////    @MainActor
////    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
////        let foundEvents = eventStore.events
////            .filter { $0.date.startOfDay == dateComponents.date?.startOfDay}
////        if foundEvents.isEmpty {
////            return nil
////        } else if foundEvents.count > 1 {
////            return .image(UIImage(systemName: "doc.on.doc.fill"),
////                          color: .red,
////                          size: .large)
////        }
//////        let singleEvent = foundEvents.first! {
//////            return .customView {
//////                let icon = UILabel()
//////                icon.text = singleEvent.EventType.icon
//////                return icon
//////            }
//////        }
////    }
//} // class CalendarViewDelegateここまで
