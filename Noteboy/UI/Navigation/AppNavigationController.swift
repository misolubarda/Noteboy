//
//  AppNavigationController.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 14/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit

enum ScreenType {
    case Main, Add
}

struct NavigationToken {
    var screen: ScreenType
}

protocol Navigatable {
    var navigationToken: NavigationToken {get set}
}

class AppNavigationController {

    private static let sharedInstance = AppNavigationController()

    static func navigate<T: UIViewController>(viewController: T) where T: Navigatable {
        sharedInstance.navigate(viewController: viewController)
    }

    private func navigate<T: UIViewController>(viewController: T) where T: Navigatable {

    }
}
