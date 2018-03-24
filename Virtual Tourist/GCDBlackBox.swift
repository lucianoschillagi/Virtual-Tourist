//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/19/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Dispatch */

import Foundation

/* Abstract:
Realiza las actualizaciones de la interfaz del usuario en la cola principal.
*/

//*****************************************************************
// MARK: - Dispatch - UI Updates on Main Queue
//*****************************************************************

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
	DispatchQueue.main.async {
		updates()
	}

}

