import SwiftUI
import WidgetKit

@main struct Secret: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Secret", provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Secret")
            .description("Add a Secret")
            .supportedFamilies([.systemSmall])
    }
}

private struct Content: View {
    let entry: Entry
    
    var body: some View {
        ZStack {
            Image(systemName: "ladybug.fill")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                
            Image(systemName: "plus")
                .resizable()
                .font(.largeTitle.weight(.light))
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .bottomTrailing)
                .padding()
        }
        .symbolRenderingMode(.hierarchical)
        .foregroundColor(.white)
        .widgetURL(URL(string: "beetle://create")!)
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color("Spot"))
    }
}

private struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .shared
    }

    func getSnapshot(in: Context, completion: @escaping (Entry) -> ()) {
        completion(.shared)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(.init(entries: [.shared], policy: .never))
    }
}

private struct Entry: TimelineEntry {
    static let shared = Self()

    let date = Date()
}
