//
//  CustomTextView.swift
//  CustomNotes
//
//  Created by Alessandro Musto on 3/20/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import Foundation
import UIKit

public class ClickableTextView: UITextView {


  var tap:UITapGestureRecognizer!

  override public init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    print("init")
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }


  func setup(){

    tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))

    self.addGestureRecognizer(tap)
  }

  func onTap(_ sender: UITapGestureRecognizer) {

    let myTextView = sender.view as! UITextView
    let layoutManager = myTextView.layoutManager

    var location = sender.location(in: myTextView)
    location.x -= myTextView.textContainerInset.left;
    location.y -= myTextView.textContainerInset.top;

    let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

    if characterIndex < myTextView.textStorage.length {

      let orgString = myTextView.attributedText.string


      //Find the WWW
      var didFind = false
      var count:Int = characterIndex
      while(count > 2 && didFind == false){

        let myRange = NSRange(location: count-1, length: 2)
        let substring = (orgString as NSString).substring(with: myRange)


        if substring == " h" || (substring  == "tp" && count == 3){
          didFind = true
          //                    print("Did find",count)

          var count2 = count
          while(count2 < orgString.characters.count){

            let myRange = NSRange(location: count2 - 1, length: 2)
            let substring = (orgString as NSString).substring(with: myRange)

            //                        print("Did 2",count2,substring)
            count2 += 1


            //If it was at the end of textView
            if count2  == orgString.characters.count {

              let length = orgString.characters.count - count
              let myRange = NSRange(location: count, length: length)

              let substring = (orgString as NSString).substring(with: myRange)

              openLink(link: substring)
              print("It's a Link",substring)
              return
            }

            //If it's in the middle

            if substring.hasSuffix(" "){

              let length =  count2 - count
              let myRange = NSRange(location: count, length: length)

              let substring = (orgString as NSString).substring(with: myRange)

              openLink(link: substring)
              print("It's a Link",substring)
              return
            }
          }
          return
        }
        if substring.hasPrefix(" "){
          print("Not a link")
          return
        }
        count -= 1
      }
    }
  }


  func openLink(link:String){

//    guard let checkUrlString = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//
//    if let checkURL = URL(string: checkUrlString) {
//      if UIApplication.shared.canOpenURL(checkURL) {
//        UIApplication.shared.open(checkURL, options: [:], completionHandler: nil)
//
//        print("url successfully opened")
//      }
//    } else {
//      print("invalid url")
//    }
//  }
//
//
//  public override func didMoveToWindow() {
//    if self.window == nil{
//      self.removeGestureRecognizer(tap)
//      print("ClickableTextView View removed from")
//    }
  }
}
