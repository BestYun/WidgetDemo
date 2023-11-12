//
//  HelloWidgetKit.swift
//  HelloWidget
//
//  Created by yun on 2023/11/12.
//

import Foundation
import SwiftUI
import WidgetKit
import Intents


struct HelloWidgetKitEntryView : View {
    var entry: HelloProvider.Entry

    var body: some View {
        Text(entry.text).foregroundColor(.orange)
    }
}

struct HelloWidgetKit: Widget {
    let kind: String = "HelloWidgetKit"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: HelloProvider()) { entry in
            HelloWidgetKitEntryView(entry: entry)
        }
        //只提供小空间的组件,默认是提供三种
        .supportedFamilies([WidgetFamily.systemSmall])
        .configurationDisplayName("Hello WidgetKit")
        .description("WidgetKit hello demo")
    }
}

struct HelloEntry: TimelineEntry {
    var date: Date
    
    let text: String
    let configuration: ConfigurationIntent
}


///提供占位,预览,和时间线
struct HelloProvider: IntentTimelineProvider {
    ///占位
    func placeholder(in context: Context) -> HelloEntry {
        HelloEntry(date: Date(),text: "Hello WidgetKitDemo", configuration: ConfigurationIntent())
    }
    ///预览
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (HelloEntry) -> ()) {
        let entry = HelloEntry(date: Date(),text: "Hello Widget预览", configuration: configuration)
        completion(entry)
    }
    ///时间线,随着时间改变,是静态数据
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<HelloEntry>) -> ()) {
        var entries: [HelloEntry] = []


        let currentDate = Date()
        //每5分钟变化一次
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = HelloEntry(date: entryDate,text: "Hello WidgetKit\(minuteOffset)", configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct HelloWidgetKitContent_Previews: PreviewProvider {
    static var previews: some View {
        HelloWidgetKitEntryView(entry: HelloEntry(date: Date(), text: "hello previews", configuration: ConfigurationIntent()))

            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
