
class SPAGraphNode {
    let id: String
    var children: [SPAGraphNode]
    
    init(id: String, children: [SPAGraphNode] = []) {
        self.id = id
        self.children = children
    }

    var outputNode: SPAOutputJson.Node {
        .init(id: self.id)
    }
}

class SPAGraph {
    private(set) var nodes: [SPAGraphNode] = []
    
    func insert(_ newNode: SPAGraphNode) {
        self.nodes.append(newNode)
    }
    
    var outputJson: SPAOutputJson {
        var nodes = Set<SPAOutputJson.Node>()
        var links = Set<SPAOutputJson.Link>()
        
        var stack = self.nodes
        while !stack.isEmpty {
            let parentNode = stack.removeFirst()
            nodes.insert(parentNode.outputNode)
            
            for childNode in parentNode.children {
                nodes.insert(childNode.outputNode)
                links.insert(.init(source: parentNode.outputNode.id, target: childNode.outputNode.id))
                stack.append(childNode)
            }
        }
        
        return SPAOutputJson(nodes: nodes, links: links)
    }
}
