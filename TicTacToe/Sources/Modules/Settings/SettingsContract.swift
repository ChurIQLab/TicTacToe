//
//  SettingsContract.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

protocol SettingsViewProtocol: AnyObject {
    func setTitle(_ title: String)
}

protocol SettingsPresenterProtocol: AnyObject {
    func viewDidLoad()
}
