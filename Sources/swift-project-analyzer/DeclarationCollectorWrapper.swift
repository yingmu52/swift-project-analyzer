import Foundation
import SwiftSemantics

struct DeclarationCollectorWrapper {
    let url: String
    let collector: DeclarationCollector
}

extension DeclarationCollectorWrapper: Hashable {
    static func == (lhs: DeclarationCollectorWrapper, rhs: DeclarationCollectorWrapper) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.url)
    }
}
