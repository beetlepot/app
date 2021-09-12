import SwiftUI
import Secrets

struct Onboard: View {
    @Binding var selected: Int?
    @State private var index = 0
    @State private var requested = false
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $index) {
                card0
                card1
                card2
                card3
            }
            .tabViewStyle(.page)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Setting up")
                        .font(.callout)
                        .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.borderless) 
                }
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: index) { [index] in
            guard $0 == 1, index == 0, !authenticate else { return }
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.5) {
                    authenticate = true
                }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .init(named: "AccentColor")
            UIPageControl.appearance().pageIndicatorTintColor = .quaternaryLabel
        }
    }
    
    private var card0: some View {
        VStack {
            Spacer()
            Image("Logo")
            Text("Just a few steps to\nstart protecting your secrets")
                .font(.callout)
                .foregroundStyle(.primary)
                .padding()
            Spacer()
            Button {
                withAnimation(.spring(blendDuration: 0.3)) {
                    index = 1
                }
            } label: {
                Image(systemName: "arrow.right")
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .font(.callout)
            .padding(.bottom, 60)
        }
        .tag(0)
    }
    
    private var card1: some View {
        VStack {
            Spacer()
            Image(systemName: "faceid")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.multicolor)
                .padding(.bottom)
            Toggle("Secure with Face ID", isOn: $authenticate)
                .toggleStyle(SwitchToggleStyle(tint: .orange))
                .font(.callout)
                .frame(maxWidth: 200)
                .padding(.top)
            
            Spacer()
            
            HStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 0
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.callout)
                .padding(.trailing)
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 2
                    }
                } label: {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.callout)
                .padding(.leading)
            }
            .padding(.bottom, 60)
        }
        .tag(1)
    }
    
    private var card2: some View {
        VStack {
            Spacer()
            Image(systemName: "app.badge")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.multicolor)
            Text(Copy.notifications)
                .font(.callout)
                .frame(maxWidth: 310)
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            if requested {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.multicolor)
                    .padding(.top)
            } else {
                Button("Allow notifications") {
                    Task {
                        _ = await UNUserNotificationCenter.request()
                        requested = true
                    }
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.top)
            }
            
            Spacer()
            
            HStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 1
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.callout)
                .padding(.trailing)
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 3
                    }
                } label: {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.callout)
                .padding(.leading)
            }
            .padding(.bottom, 60)
        }
        .tag(2)
    }
    
    private var card3: some View {
        VStack {
            Spacer()
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.multicolor)
            Text("All ready!")
                .font(.callout)
                .foregroundStyle(.primary)
                .padding(.vertical)
            Text("By using this app you accept\nour terms and conditions.\nYou can read them on Settings")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
            
            Button {
                dismiss()
            } label: {
                Text("Done")
            }
            .buttonStyle(.borderedProminent)
            .font(.callout)
            .padding(.top)
            
            Spacer()
            
            HStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 2
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.callout)
                .padding(.trailing)
                
                Button {
                    selected = Sidebar.Index.settings.rawValue
                    dismiss()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.leading)
            }
            .padding(.bottom, 60)
        }
        .tag(3)
    }
}
