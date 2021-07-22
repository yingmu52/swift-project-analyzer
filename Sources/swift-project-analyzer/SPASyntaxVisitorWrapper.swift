import Foundation

struct SPASyntaxVisitorWrapper {
    let url: String
    let visitor: SPASyntaxVisitor
}

extension SPASyntaxVisitorWrapper: Hashable {
    static func == (lhs: SPASyntaxVisitorWrapper, rhs: SPASyntaxVisitorWrapper) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.url)
    }
}
