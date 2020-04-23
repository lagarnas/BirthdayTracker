//
//  Birthday.swift
//  BirthdayTracker
//
//  Created by Анастасия Лагарникова on 23.04.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

class Birthday {
    let firstName: String
    let lastName: String
    let birthdate: Date
    init(firstName: String, lastName: String, birthdate: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
    }
}
