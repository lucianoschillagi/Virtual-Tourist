//
//  ProtocolExtensions.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/9/18.
//  Copyright © 2018 luko. All rights reserved.
//

import Foundation

/* Abstract:
Agrega nueva funcionalidad a través de la implementación de dos protocolos.
*/

//*****************************************************************
// MARK: - Mutable Collection - Shuffle
//*****************************************************************

extension MutableCollection {
	/// baraja el contenido de una colección
	mutating func shuffle() {
		let c = count
		guard c > 1 else { return }
		
		for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
			let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
			let i = index(firstUnshuffled, offsetBy: d)
			swapAt(firstUnshuffled, i)
		}
	}
}

//*****************************************************************
// MARK: - Sequence - Shuffled
//*****************************************************************

extension Sequence {
	/// devuelve un array con el contenido de la secuencia, ya barajada
	func shuffled() -> [Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}
