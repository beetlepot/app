import SwiftUI
import UserNotifications
import Secrets

struct Sidebar: View {
    @State private var filter =  Filter()
    @State private var filtered = [Secret]()
    
    var body: some View {
        NavigationView {
            Items(filtered: filtered)
                .searchable(text: $filter.search)
//                .task {
//                    await cloud.add(purchase: .ten)
//                    try! await cloud.secret()
//                    try! await cloud.secret()
//                    try! await cloud.secret()
//                    try! await cloud.secret()
//                    try! await cloud.secret()
//                    await cloud.update(id: 0, name: "Gran's secret Shortbread Recipe")
//                    await cloud.update(id: 0, payload: """
//**Ingredients**
//— 200g _butter_
//— 100g _caster sugar_
//— 300g _plain flour_
//— 1 level teaspoon _baking powder_
//— 1 level teaspoon _ginger_
//— 1 pinch _salt_
//
//**Process**
//_1._ Cream butter and sugar.
//_2._ Sift in other ingredients and mix well.
//_3._ Spread in lined bake tray.
//_4._ Bake in moderate over circa 40 minutes until golden.
//_5._ Eat warm.
//
//""")
//                    await cloud.add(id: 0, tag: .biscuits)
//                    await cloud.add(id: 0, tag: .cook)
//                    await cloud.add(id: 0, tag: .family)
//                    await cloud.add(id: 0, tag: .food)
//                    await cloud.add(id: 0, tag: .important)
//                    await cloud.add(id: 0, tag: .top)
//                    
//                    await cloud.update(id: 0, favourite: true)
//                    await cloud.update(id: 2, favourite: true)
//                    
//                    await cloud.update(id: 1, name: "Office's door keycode")
//                    await cloud.update(id: 2, name: "The meaning of life")
//                    await cloud.update(id: 3, name: "Cezz's phone number")
//                    await cloud.update(id: 4, name: "The secret cookie stash")
//                }
        }
        .onReceive(cloud) {
            filtered = $0.filtering(with: filter)
        }
        .onChange(of: filter) { filter in
            Task {
                filtered = await cloud.model.filtering(with: filter)
            }
        }
        .task {
            if await UNUserNotificationCenter.authorization == .notDetermined {
                await UNUserNotificationCenter.request()
            }
        }
    }
}
