# WidgetDemo
iOS小组件

### 小组件特点
* 必须要ios14以上
* 必须要用swiftui来写
* **小组件不是实时更新的**,预估的适用周期为 24 小时。WidgetKit 会根据用户的日常使用模式调整 24 小时窗口，这意味着每日预算不一定会在午夜重置。对于用户经常查看的小组件，每日预算通常包括 40 到 70 次刷新。这一速率可以大致换算为每 15 到 60 分钟重新载入一次小组件，但是由于涉及到多个因素，这些时间间隔通常会有所不同。

### 小组件大小
* .systemSmall 小
* .systemMedium 中
* .systemLarge 大

```swift
//配置
.supportedFamilies([.systemSmall,.systemMedium,.systemLarge])
```

### 创建小组件
* Todo


### 代码入口
* 文件名以Bundle结尾
* 继承WidgetBundle
* @main标识
```swift
@main
struct WidgetKitContentBundle: WidgetBundle {
    var body: some Widget {
        ///各种小组件在这儿配置后才可以选择
        WidgetKitContent()
        HelloWidgetKit()
        FamousWidgetKit()
        EditWidget()
        TimeWidgetDemo()
        WidgetKitContentLiveActivity()//灵动岛
    }
}


```


### 小组件代码结构
* 打开 WidgetKitContent.swift 文件，这个文件中总共分为 5 个部分：

* struct Provider 负责为小组件提供数据
* struct SimpleEntry 小组件的数据模型
* struct WidgetKitContentEntryView 小组件的视图,继承View,在这儿布局绘制ui
* struct WidgetKitContent 小组件的配置部分,继承Widget,
```swift
struct WidgetKitContent: Widget {
    ///小组件唯一标识
    let kind: String = "WidgetKitContent"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetKitContentEntryView(entry: entry)
        }
        //配置大小
        .supportedFamilies([.systemSmall,.systemMedium,.systemLarge])
        //小组件的名称,在添加小组件时可以看到
        .configurationDisplayName("My Widget")
        //小组件描述,在添加小组件时可以看到
        .description("This is an example widget.")
    }
}
```
* struct WidgetKitContent_Previews 提供小组件在 Xcode 中的预览

### Provider
* 继承 IntentTimelineProvider 
* 在这儿配置要展示的数据
* 有三个方法
* func placeholder(in context: Context) -> SimpleEntry 
> 用于占位展示默认的数据
* func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ())
> 快照,选择添加小组件时会有根据这里的数据展示预览

* func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ())
> 时间线,根据配置的时间来展示内容,也是最为重要的部分,如果是通过网络请求获取数据,也是在这儿实现,要展示的内容必须提前准备好,所以相当于静态的数据了
```swift
//用法
let timeline = Timeline(entries: entries, policy: .atEnd)
completion(timeline)

```

### SimpleEntry
* 继承TimelineEntry
* 数据结构体,必须要展示的图片或者标题文字,就需要在这儿添加属性
* 有一个必须声明的属性date
```swift
let date: Date
```

### 案例
* Todo
