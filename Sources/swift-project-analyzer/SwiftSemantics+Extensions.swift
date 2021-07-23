import SwiftSemantics

extension Class {
    var isPublic: Bool {
        self.modifiers.first { $0.name == "public" } != nil
    }
}

extension Variable {
    var isPrivate: Bool { self.modifiers.first { $0.name == "private" } != nil }
    
    var uxfVisibility: String { self.isPrivate ? "-" : "+" }
}

extension Function {
    var isPrivate: Bool { self.modifiers.first { $0.name == "private" } != nil }
    
    var uxfVisibility: String { self.isPrivate ? "-" : "+" }
}
