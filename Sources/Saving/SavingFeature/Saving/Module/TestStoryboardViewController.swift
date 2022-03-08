//
//  TestStoryboardViewController.swift
//  Saving
//
//  Created by Jonas Bengtås Clarstedt on 2021-06-30.
//

import FolksamCommon
import Foundation
import UIKit

public class TestStoryboardViewController: UIViewController {
    @IBOutlet var slider: FolksamSliderV2!
    @IBOutlet var lable: UILabel!

    override public func viewDidLoad() {
        super.viewDidLoad()
        slider.delegate = self
    }

    @objc func change(sliderArg: FolksamSliderV2) {
        print(sliderArg)
        // lable.text = String(sliderArg.getValue())
    }

    public static func make() -> TestStoryboardViewController {
        let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle.module)
        let viewController = UIStoryboard.instantiateViewController(from: storyboard, ofType: TestStoryboardViewController.self)
        return viewController
    }
}

extension TestStoryboardViewController: FolksamSliderDelegate {
    public func onChangeValue(sender _: FolksamSliderV2, value: Float) {
        lable.text = String(value)
    }

    public func dragEnded() {}
}
