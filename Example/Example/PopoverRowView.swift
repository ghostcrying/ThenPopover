//
//  PopoverRowView.swift
//  Example
//
//  Created by 陈卓 on 2023/7/14.
//

import SwiftUI
import ThenPopover

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
        }
    }
    
    func handleDefault(_ style: ThenPopoverTransition.TransitionType) {
        // Prepare the popup
        let title = "THIS IS A DIALOG WITHOUT IMAGE"
        let message = "If you don't pass an image to the default popup, it will display just as a regular popup. Moreover, this features the zoom transition"

        let popup = ThenPopover(title: title, message: message, axis: .horizontal, presented: style, width: .custom(300))
        popup.addActions([
            ThenPopoverAction.Cancel(title: "Cancel") {
                print("You canceled the default popup")
            },
            ThenPopoverAction.Default(title: "OK") {
                print("You ok'd the default popup")
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
            // Prepare the popup assets
            let title = "THIS IS THE DIALOG TITLE"
            let message = "This is the message section of the PopupDialog default view"
            let image = UIImage(named: "ic_pexels_1")
            
            // Create the popup
            let popup = ThenPopover(title: title, message: message, image: image, width: .custom(320))
            popup.containerView.cornerRadius = 12
            popup.containerView.shadowEnabled = false
            // Create first button
            let buttonOne = ThenPopoverAction.Cancel(title: "CANCEL") {
                print("You canceled the image popup")
            }
            let buttonTwo = ThenPopoverAction.Default(title: "SHAKE", dismissOnTap: false) { [weak popup] in
                popup?.shakeAnimate()
            }
            let buttonThree = ThenPopoverAction.Default(title: "OK") {
                print("You ok'd the image popup")
            }
            popup.addActions([buttonOne, buttonTwo, buttonThree])

            UIApplication.shared.window?.rootViewController?.present(popup, animated: true, completion: nil)
        case .custom:
            // PopoverController: must have height proxy so it can calculate the real height
            let popup = ThenPopover(PopoverController(), axis: .horizontal, presented: .default)
            
            // let buttonOne = ThenPopoverAction.Cancel(title: "CANCEL", height: 60) { print("You canceled the rating popup") }
            // let buttonTwo = ThenPopoverAction.Default(title: "RATE", height: 60) { print("You rated stars") }
            // popup.addActions([buttonOne, buttonTwo])
            
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
        }
    }
    
}

struct PopoverRowView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverRowView(title: "👌🏻", type: .default)
    }
}
