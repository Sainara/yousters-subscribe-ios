//
//  VoiceRecordedDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 10.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

protocol VoiceRecordedDelegate: class {
    func successVoiceRecord(file url:URL)
}
