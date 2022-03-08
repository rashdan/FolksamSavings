
//
//  TestStoryboardViewController.swift
//  Saving
//
//  Created by Jonas Bengtås Clarstedt on 2021-06-30.
//

import FolksamCommon
import Foundation
import UIKit

public class MySavingViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var image: UIImageView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: image.frame.height)
    }

    public static func make() -> MySavingViewController {
        let storyboard = UIStoryboard(name: "MySaving", bundle: Bundle.module)
        let viewController = UIStoryboard.instantiateViewController(from: storyboard, ofType: MySavingViewController.self)

        return viewController
    }
}
