import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    PopoverRowView(title: "default", type: .default)
                    PopoverRowView(title: "image",   type: .image)
                    PopoverRowView(title: "custom",  type: .custom)
                } header: {
                    Text("Category")
                }
                
                Section {
                    PopoverRowView(title: "default", type: .default)
                    PopoverRowView(title: "scale",   type: .scale)
                } header: {
                    Text("Animation Scale")
                }
                
                Section {
                    PopoverRowView(title: "translation up",    type: .translationup)
                    PopoverRowView(title: "translation down",  type: .translationdown)
                    PopoverRowView(title: "translation left",  type: .translationleft)
                    PopoverRowView(title: "translation right", type: .translationright)
                } header: {
                    Text("Animation Translation")
                }
                
                Section {
                    PopoverRowView(title: "roate x", type: .roatex)
                    PopoverRowView(title: "roate y", type: .roatey)
                    PopoverRowView(title: "roate z", type: .roatez(3))
                } header: {
                    Text("Animation Corner")
                }
                
                Section {
                    PopoverRowView(title: "corner top left",     type: .corner(0))
                    PopoverRowView(title: "corner top right",    type: .corner(1))
                    PopoverRowView(title: "corner bottom left",  type: .corner(2))
                    PopoverRowView(title: "corner bottom right", type: .corner(3))
                } header: {
                    Text("Animation Roate")
                } footer: {
                    Text("🦶🏻")
                }
            }
            .navigationBarTitle("Then Popover")
        }
    }
}

struct ThenPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
