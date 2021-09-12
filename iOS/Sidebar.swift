import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var search = ""
    @State private var favourites = false
    @State private var selected: Int?
    @State private var onboard = false
    
    var body: some View {
        Content(search: $search, favourites: $favourites, selected: $selected, archive: archive)
            .searchable(text: $search)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        UIApplication.shared.hide()
                        favourites.toggle()
                    } label: {
                        Image(systemName: favourites ? "heart.fill" : "heart")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.callout)
                    
                    Button {
                        UIApplication.shared.hide()
                        if archive.available {
                            Task {
                                selected = await cloud.secret()
                            }
                        } else {
                            selected = Sidebar.Index.full.rawValue
                        }
                    } label: {
                        Label("New secret", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .font(.callout)
                }
                
                ToolbarItem(placement: .keyboard) {
                    Button("Cancel", role: .cancel) {
                        UIApplication.shared.hide()
                    }
                    .font(.callout)
                    .tint(.pink)
                }
            }
            .sheet(isPresented: $onboard, onDismiss: {
                Defaults.onboarded = true
            }) {
                Onboard(selected: $selected)
            }
            .onAppear {
                if !Defaults.onboarded {
                    onboard = true
                }
            }
    }
}
