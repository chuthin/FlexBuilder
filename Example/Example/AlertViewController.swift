//
//  AlertViewController.swift
//  Example
//
//  Created by Chu Thin on 21/07/2023.
//

import Foundation
import FlexBuilder
import MarkdownKit
struct AlertViewController : ControllerBuilder {
    @Variable var message:String? = nil
    @Variable var confirmMessage:String? = nil
    @Variable var customeMesssage: String? = nil
    func view() -> any ViewControllerBuilder {
        FViewController {
            FVStack(space: 8) {
                FButton("Message").onTap { _ in
                    message = "Hello world"
                }
                .backgroundColor(.gray)
                
                FButton("Confirm Message").onTap { _ in
                    confirmMessage = "Do you want to exit the app?"
                }
                .backgroundColor(.gray)
                
                FButton("Message with context").onTap { context in
                    context.present(FAlert.message("Context messsage"))
                }
                .backgroundColor(.gray)
                
                FButton("Custom alert").onTap { context in
                    customeMesssage = "I support a *lot* of custom Markdown **Elements**, even `code`!"
                }
                .backgroundColor(.gray)
                
            }.padding(12)
        }
        .alert($message.asObservable()) { message in
            FAlert.message(message)
        }
        .alert($confirmMessage.asObservable()) { message in
            FAlert.consfirmMessage(message)
        }
        .alert($customeMesssage.asObservable()) { value in
            let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 16))
            markdownParser.enabledElements = .disabledAutomaticLink
            markdownParser.bold.color = UIColor.red
            markdownParser.bold.font = .boldSystemFont(ofSize: 18)
            markdownParser.header.fontIncrease = 4
            return FAlert(value) { data in
                FVStack {
                    FText("Flex Builder")
                        .alignment(.center).font(.title1)
                    FSpacer()
                    FText()
                        .attributedText(markdownParser.parse(data))
                        .numberOfLines(0)
                        .alignment(.center)
                    FSpacer()
                    FHStack {
                        FButton {
                            FText("Ok")
                                .alignment(.center)
                                .color(.white)
                        }
                        .backgroundColor(.blue)
                        .height(48).grow(1)
                        .onTap { context in
                            print("ok button")
                            context.dismiss(animated: true)
                        }
                        FSpacer(width: 8)
                        FButton {
                            FText("Cancel")
                                .alignment(.center)
                                .color(.white)
                        }
                        .backgroundColor(.blue)
                        .height(48)
                        .grow(1)
                        .onTap { context in
                            context.dismiss(animated: true)
                           //context.view.dismis()
                        }
                    }
                }
                .padding(8)
                .backgroundColor(.white)
                .cornerRadius(12)
            }
        }
        
    }
}

public extension FAlert {
    static func message( _ value: String) -> FAlert {
        FAlert(title: "Flext Builder",message: value ,actions: [.cancel("Close")])
    }
    
    static func consfirmMessage( _ value: String) -> FAlert {
         FAlert(title: "Flext Builder",message: value){
            FAlertAction.default("Ok",action: {
                print("Ok")
            })
            FAlertAction.cancel("Cancel")
        }
    }
}
