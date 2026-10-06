//
//  SettingsContract.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 25.09.2026.
//

protocol SettingsViewProtocol: AnyObject {
    func setTitle(_ title: String)
    func showSettings(_ settings: SettingsViewModel)
}

protocol SettingsPresenterProtocol: AnyObject {
    func viewDidLoad()
    /// `index` in `Theme.allCases`, as the segments show them
    func didSelectTheme(at index: Int)
    func didChangeHaptics(isOn: Bool)
}
