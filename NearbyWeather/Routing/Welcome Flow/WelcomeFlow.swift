//
//  WelcomeFlow.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 19.04.20.
//  Copyright © 2020 Erik Maximilian Martens. All rights reserved.
//

import RxFlow

final class WelcomeFlow: Flow {
  
  // MARK: - Assets
  
  var root: Presentable {
    rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.backgroundColor = Constants.Theme.Color.ViewElement.background
    navigationController.navigationBar.barTintColor = Constants.Theme.Color.ContentElement.title
    navigationController.navigationBar.tintColor = Constants.Theme.Color.BrandColors.standardDay
    
    return navigationController
  }()
  
  // MARK: - Initialization
  
  init() {}
  
  deinit {
    printDebugMessage(domain: String(describing: self), message: "was deinitialized")
  }
  
  // MARK: - Functions
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? WelcomeStep else {
      return .none
    }
    switch step {
    case .initial:
      return summonWelcomeWindow()
    case .setPermissions:
      return summonSetPermissions()
    case .launchApp:
      return dismissWelcomeWindow()
    }
  }
}

private extension WelcomeFlow {
  
  private func summonWelcomeWindow() -> FlowContributors {
   
    let welcomeViewController = R.storyboard.welcome.welcomeScreenViewController()!
    rootViewController.setViewControllers([welcomeViewController], animated: false)
    return .one(flowContributor: .contribute(withNext: welcomeViewController))
  }
  
  private func summonSetPermissions() -> FlowContributors {
    let setPermissionsController = R.storyboard.setPermissions.setPermissionsVC()!
    rootViewController.pushViewController(setPermissionsController, animated: true)
    return .one(flowContributor: .contribute(withNext: setPermissionsController))
  }
  
  private func dismissWelcomeWindow() -> FlowContributors {
    .end(forwardToParentFlowWithStep: WelcomeStep.launchApp)
  }
}

