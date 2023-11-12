//
//  FamousWidgetKit.swift
//  FamousWidget
//
//  Created by yun on 2023/11/12.
//

import Foundation
import Intents
import SwiftUI
import WidgetKit

private let data = [
    ["text": "等闲识得东风面，万紫千红总是春。", "author": "朱熹《春日》", "bgIcon": "blue_bg"],
    ["text": "西风酒旗市,细雨菊花天", "author": "欧阳修·秋怀", "bgIcon": "green_bg"],
    ["text": "萋萋春草秋绿,落落长松夏寒", "author": "王维·田园乐七首·其四", "bgIcon": "pink_bg"],
    ["text": "稍待秋风凉冷后，高寻白帝问真源。", "author": "杜甫·望岳三首·其二", "bgIcon": "shui_bg"],
    ["text": "爽合风襟静，高当泪脸悬。", "author": "杜甫·万里瞿塘月", "bgIcon": "yellow_bg"],
]

/// 每日小诗词
struct FamousWidgetKitEntryView: View {
    var entry: FamousProvider.Entry

    let currentTime = Calendar.current.dateComponents([.day, .month, .year], from: Date())

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(entry.text)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .lineSpacing(5)

                Text("-\(entry.author)")
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
            }
            VStack(spacing: 6) {
                Text("\(currentTime.day ?? 0)")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)

                Text("\(currentTime.year ?? 0)年\(currentTime.month ?? 0)月")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 60)

            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(.white, lineWidth: 2)
            )
            .padding(.leading, 10)
        }

        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding(.horizontal, 20)

        .background {
            Image(entry.bgIcon).resizable().aspectRatio(contentMode: .fill)
        }.widgetURL(URL(string: "---widgetURL--"))
    }
}

struct FamousWidgetKit: Widget {
    let kind: String = "FamousWidgetKit"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: FamousProvider()) { entry in
            FamousWidgetKitEntryView(entry: entry)
        }
        // 只提供小空间的组件,默认是提供三种
        .supportedFamilies([WidgetFamily.systemMedium])
        .configurationDisplayName("Famous WidgetKit")
        .description("每日诗词小组件")
    }
}

struct FamousEntry: TimelineEntry {
    var date: Date

    let text: String
    let author: String
    let bgIcon: String
    let configuration: ConfigurationIntent
}

/// 提供占位,预览,和时间线
struct FamousProvider: IntentTimelineProvider {
    /// 占位
    func placeholder(in context: Context) -> FamousEntry {
        FamousEntry(date: Date(), text: "Famous WidgetKitDemo", author: "yun", bgIcon: "blue_bg", configuration: ConfigurationIntent())
    }

    /// 预览
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (FamousEntry) -> ()) {
        let entry = FamousEntry(date: Date(), text: "Famous Widget预览", author: "yun", bgIcon: "blue_bg", configuration: ConfigurationIntent())

        completion(entry)
    }

    /// 时间线,随着时间改变,是静态数据
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<FamousEntry>) -> ()) {
        var entries: [FamousEntry] = []

        let currentDate = Date()

        let list = data

        // 每5分钟变化一次
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!

            let index = minuteOffset % list.count
            let content = list[index]

            let entry = FamousEntry(date: entryDate, text: content["text"]!, author: content["author"]!,
                                    bgIcon: content["bgIcon"]!,
                                    configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FamousWidgetKitContent_Previews: PreviewProvider {
    static let content = data[1]

    static var previews: some View {
        FamousWidgetKitEntryView(entry: FamousEntry(date: Date(), text: content["text"]!, author: content["author"]!, bgIcon: content["bgIcon"]!, configuration: ConfigurationIntent())
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
