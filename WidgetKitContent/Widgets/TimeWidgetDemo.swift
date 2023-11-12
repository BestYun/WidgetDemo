//
//  WidgetDemo.swift
//  WidgetDemo
//
//  Created by yun on 2023/11/11.
//

import WidgetKit
import SwiftUI
import Intents

struct TimeProvider: IntentTimelineProvider {
    //小组件
    func placeholder(in context: Context) -> TimeSimpleEntry {
        TimeSimpleEntry(date: Date(), configuration: ConfigurationIntent(),time: TimeSimpleEntry.currentTime)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TimeSimpleEntry) -> ()) {
        let entry = TimeSimpleEntry(date: Date(), configuration: configuration,time: TimeSimpleEntry.currentTime)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TimeSimpleEntry] = []
        
        

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        let hour = Calendar.current.component(.hour, from: Date())
            
            switch hour {
            case 0..<12:
                entries.append(
                    TimeSimpleEntry(date: Date(), configuration: configuration,time: .morning)
                )
                entries.append(
                    TimeSimpleEntry(date: getDate(in: 12), configuration: configuration,time: .afternoon)
                )
                entries.append(
                    TimeSimpleEntry(date: getDate(in: 18), configuration: configuration,time: .afternoon)
                )
                
            case 12..<18:
                
                    entries.append(
                        TimeSimpleEntry(date: getDate(in: 12), configuration: configuration,time: .afternoon)
                    )
                    entries.append(
                        TimeSimpleEntry(date: getDate(in: 18), configuration: configuration,time: .afternoon)
                    )
                
            default:
                entries.append(
                    TimeSimpleEntry(date: Date(), configuration: configuration,time: .night)
                )
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)

        }
    }
}
///model,一定要继承TimelineEntry
struct TimeSimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    enum Time {
        case morning
        case afternoon
        case night
    }
    
    let time: Time
    
    static var currentTime: Time {
        let time = Date()
        let hour = Calendar.current.component(.hour, from: time)
        switch hour {
        case 0..<12:
            return .morning
        case 12..<18:
            return .afternoon
        
        case 18...24:
                return .night
        default: return .morning
        }
    }

}

extension TimeSimpleEntry.Time {
    var text: String {
        switch self {
        case .morning: return "早上"
        case .afternoon: return "下午"
        case .night: return "晚上"
        }
    }
    var icon: String {
         switch self {
         case .morning:
             return "sunrise"
         case .afternoon:
             return "sun.max.fill"
         case .night:
             return "sunset"
         }
     }
    
}

func getDate(in hour: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: Date())
    components.hour = hour
    components.minute = 0
    components.second = 0

    return calendar.date(from: components)!
}



struct WidgetDemoEntryView : View {
    var entry: TimeProvider.Entry

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: entry.time.icon)
                        .imageScale(.large)
//                        .fontWeight(.medium)
                        .foregroundColor(.red)
                    HStack {
                        Text("现在是:")
                        Text(entry.time.text)
                    }
                    .font(.subheadline)
                }

        
//     名言
//       ZStack {
//
//            Image("text").fixedSize().frame(width: 169,height: 169)
//
//            HStack {
//                Text("").foregroundColor(.white)
//
//                Text(entry.date, style: .time).foregroundColor(.orange)
//            }.offset(x:0,y:0)
//
//        }
    }
}

struct TimeWidgetDemo: Widget {
    let kind: String = "TimeWidgett"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: TimeProvider()) { entry in
            WidgetDemoEntryView(entry: entry)
        }
        .configurationDisplayName("小组件名称")
        .description("小组件描述")
    }
}

struct TimeWidgetDemo_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDemoEntryView(entry: TimeSimpleEntry(date: Date(), configuration: ConfigurationIntent(),time: .morning))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
