
struct SPAOutputJson: Encodable {
    struct Node: Encodable {
        let name: String
        let label: String
        let id: String
    }
    
    struct Link: Encodable {
        let source: String
        let target: String
        let type = "KNOWS"
    }
    let nodes: [Node]
    let links: [Link]
}

