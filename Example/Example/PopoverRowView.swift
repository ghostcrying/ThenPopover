//
//  PopoverRowView.swift
//  Example
//
//  Created by ghost on 2023/7/14.
//

import SwiftUI
import ThenPopover

enum PopoverType: CaseIterable, Identifiable {
    static var allCases: [PopoverType] = [
        .default,
        .image,
        .custom,
        .translationup,
        .translationdown,
        .translationleft,
        .translationright,
        .scale,
        .roatex,
        .roatey,
        .roatez(3),
        .corner(0),
        .corner(1),
        .corner(2),
        .corner(3),
    ]
    
    case `default`
    case image
    case custom
    
    case translationup
    case translationdown
    case translationleft
    case translationright
    
    case scale
    
    case roatex
    case roatey
    case roatez(Int)
    
    case corner(Int)
    
    /// case corner(_ value: Corner)
    
    var id: String {
        switch self {
        case .default:
            return "default"
        case .image:
            return "image"
        case .custom:
            return "custom"
        case .translationup:
            return "up"
        case .translationdown:
            return "down"
        case .translationleft:
            return "left"
        case .translationright:
            return "right"
        case .scale:
            return "scale"
        case .roatex:
            return "roatex"
        case .roatey:
            return "roatey"
        case .roatez:
            return "roatez"
        case .corner(let value):
            switch value {
            case 0:
                return "corner topLeft"
            case 1:
                return "corner topRight"
            case 2:
                return "corner bottomLeft"
            default:
                return "corner bottomRight"
            }
        }
    }
    
    func handleDefault(_ style: ThenPopoverTransition.TransitionType) {
        // Prepare the popup
        let title = "Image Popover"
        let message = "This is a default popover."

        let popup = ThenPopover(title: title, message: message, axis: .horizontal, presented: style, width: .custom(300))
        popup.addActions([
            ThenPopoverAction.Cancel(title: "Cancel") {
                print("Click the Cancel the popover.")
            },
            ThenPopoverAction.Default(title: "OK") {
                print("Click the OK the popover.")
            },
        ])
        UIApplication.shared.window?.rootViewController?.present(popup, animated: true, completion: nil)
    }
    
    func handle() {
        //
        switch self {
        case .default:
            self.handleDefault(.scale)
        case .image:
            let title = "Default Title"
            let message = "Message Default view"
            let image = UIImage(named: "ic_pexels_1")
            
            // Create the popup
            let popup = ThenPopover(title: title, message: message, image: image, width: .custom(320))
            popup.containerView.cornerRadius = 12
            popup.containerView.shadowEnabled = false
            // Create first button
            let buttonOne = ThenPopoverAction.Cancel(title: "CANCEL") {
                print("Click the Cancel the image popover.")
            }
            let buttonTwo = ThenPopoverAction.Default(title: "SHAKE", dismissOnTap: false) { [weak popup] in
                popup?.shakeAnimate()
            }
            let buttonThree = ThenPopoverAction.Default(title: "OK") {
                print("Click the OK the image popover.")
            }
            popup.addActions([buttonOne, buttonTwo, buttonThree])

            UIApplication.shared.window?.rootViewController?.present(popup, animated: true, completion: nil)
        case .custom:
            // PopoverController: must have height proxy so it can calculate the real height
            let popup = ThenPopover(PopoverController(), axis: .horizontal, presented: .default)
            
            let buttonOne = ThenPopoverAction.Cancel(title: "CANCEL", height: 60) { print("Click the Cancel the custom popover.")
            }
            let buttonTwo = ThenPopoverAction.Default(title: "OK", height: 60) { print("Click the OK the custom popover.")
            }
            popup.addActions([buttonOne, buttonTwo])
            
            UIApplication.shared.window?.rootViewController?.present(popup, animated: true, completion: nil)
        case .scale:
            self.handleDefault(.scale)
        case .translationdown:
            self.handleDefault(.translation(.bottom))
        case .translationup:
            self.handleDefault(.translation(.top))
        case .translationleft:
            self.handleDefault(.translation(.left))
        case .translationright:
            self.handleDefault(.translation(.right))
        case .roatex:
            self.handleDefault(.rotate(.x))
        case .roatey:
            self.handleDefault(.rotate(.y))
        case .roatez(let value):
            self.handleDefault(.rotate(.z(value)))
        case .corner(let value):
            switch value {
            case 0:
                self.handleDefault(.corner(.topLeft))
            case 1:
                self.handleDefault(.corner(.topRight))
            case 2:
                self.handleDefault(.corner(.bottomLeft))
            default:
                self.handleDefault(.corner(.bottomRight))
            }
        }
    }
    
}

struct PopoverRowView: View {
    let title: String
    let type: PopoverType
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: String.randomSystemIcon ?? "")
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 8)
            Spacer()
            Image(systemName: "control")
                .foregroundColor(.gray)
                .rotationEffect(.degrees(90))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            type.handle()
        }
    }
}

struct PopoverRowView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverRowView(title: "👌🏻", type: .default)
    }
}
