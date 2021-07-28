
struct SPAGraphNode {
    let name: String
    var children: [SPAGraphNode] = []
    
    var outputNode: OutputJson.OutputNode {
        .init(name: self.name, label: self.name, id: self.name)
    }
    var outputLinks: [OutputJson.OutputLink] {
        self.children.map { childNode in
            .init(source: self.outputNode.id, target: childNode.outputNode.id)
        }
    }
}

class SPAGraph {
    private(set) var nodes: [SPAGraphNode] = []
    
    func insert(_ newNode: SPAGraphNode) {
        var stack = self.nodes
        
        while !stack.isEmpty {
            let aNode = stack.removeFirst()
            if aNode.name == newNode.name {
                return
            }
            stack += aNode.children
        }
        
        self.nodes.append(newNode)
    }
    
    var outputJson: OutputJson {
        var nodes = [OutputJson.OutputNode]()
        var links = [OutputJson.OutputLink]()
        
        var stack = self.nodes
        while !stack.isEmpty {
            let first = stack.removeFirst()
            nodes.append(first.outputNode)
            links += first.outputLinks
        }
        
        // check source existance
        let sourceSet = Set(nodes.map { $0.id })
        var linksWithExistingSourceAndTargetNodes = [OutputJson.OutputLink]()
        for link in links where sourceSet.contains(link.source) && sourceSet.contains(link.target) {
            linksWithExistingSourceAndTargetNodes.append(link)
        }
        
        return OutputJson(nodes: nodes, links: linksWithExistingSourceAndTargetNodes)
    }
}

struct OutputJson: Encodable {
    struct OutputNode: Encodable {
        let name: String
        let label: String
        let id: String
    }
    
    struct OutputLink: Encodable {
        let source: String
        let target: String
        let type = "KNOWS"
    }
    let nodes: [OutputNode]
    let links: [OutputLink]
}

