
struct SPAGraphNode {
    let name: String
    let label: String
    let id: String
    
    var children: [SPAGraphNode] = []
    
    var outputNode: SPAOutputJson.Node {
        .init(name: self.name, label: self.name, id: self.name)
    }
    var outputLinks: [SPAOutputJson.Link] {
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
    
    var outputJson: SPAOutputJson {
        var nodes = [SPAOutputJson.Node]()
        var links = [SPAOutputJson.Link]()
        
        var stack = self.nodes
        while !stack.isEmpty {
            let first = stack.removeFirst()
            nodes.append(first.outputNode)
            links += first.outputLinks
        }
        
        // check source existance
        let sourceSet = Set(nodes.map { $0.id })
        var linksWithExistingSourceAndTargetNodes = [SPAOutputJson.Link]()
        for link in links where sourceSet.contains(link.source) && sourceSet.contains(link.target) {
            linksWithExistingSourceAndTargetNodes.append(link)
        }
        
        return SPAOutputJson(nodes: nodes, links: linksWithExistingSourceAndTargetNodes)
    }
}
