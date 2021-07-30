
struct SPAOutputJson: Encodable {
    struct Node: Encodable, Hashable {
        let id: String
    }
    
    struct Link: Encodable, Hashable {
        let source: String
        let target: String
    }
    let nodes: Set<Node>
    let links: Set<Link>
}

