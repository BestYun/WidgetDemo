//
//  EditWidget.swift
//  WidgetKitContentExtension
//
//  Created by yun on 2023/11/12.
//

import Foundation
import WidgetKit
import SwiftUI
import Intents



struct EditProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> EditEntry {
        
        let c = ConfigurationIntent()
//        c.title = "纪念小组件"
//        c.dateStr = "纪念日期"
        return EditEntry(date: Date(), configuration: c)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (EditEntry) -> Void) {
        let c = ConfigurationIntent()
//        c.title = "纪念小组件Snapshot"
//        c.dateStr = "纪念日期"
        
        let entry = EditEntry(date: Date(), configuration: c)
        completion(entry)
    }
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = EditEntry(date: Date(), configuration: configuration)

        let expireDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(expireDate))
        completion(timeline)
    }
}

struct EditEntry: TimelineEntry {
    public let date: Date
    let configuration: ConfigurationIntent
}

struct EditEntryView : View {
    //这里是Widget的类型判断
    var entry: EditProvider.Entry
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .center) {
            
            if entry.configuration.title == nil || entry.configuration.title!.isEmpty {
                
                VStack (alignment: .leading){
                    Text("纪念日小组件")
                        .font(.headline)
                    Text("1.长按进入编辑模式").font(.system(size: 12)).padding(.top,5)
                    Text("2.点击编辑模式").font(.system(size: 12))
                    Text("3.输入纪念标题和日期").font(.system(size: 12))
                }
                
                
            }else {
                Text(entry.configuration.title!)
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .bold()
                    .padding(.bottom, 10)
                
                if entry.configuration.dateStr == nil {
                    Text("请输入日期" )
                        .font(.headline)
                        .foregroundColor(Color.gray)
                }else{
                    
                    Text(entry.configuration.dateStr!)
                        .font(.headline)
                        .foregroundColor(Color.gray)
                }
            }
        }
        .padding(.all)
    }
    
}



struct EditWidget: Widget {
    private let kind: String = "Edit"
    var title: String = "纪念日小组件"
    var desc: String = "纪念日"
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: EditProvider()) { entry in
            EditEntryView(entry: entry)
        }
        .configurationDisplayName(title)
        .description(desc)
        .supportedFamilies([.systemSmall])
        
    }
}

