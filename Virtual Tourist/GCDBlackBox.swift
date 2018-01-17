//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/19/17.
//  Copyright © 2017 luko. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
	DispatchQueue.main.async {
		updates()
	}
}

