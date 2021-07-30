
struct SPAGraphNode {
    let id: String
    var children: [SPAGraphNode] = []
    
    var outputNode: SPAOutputJson.Node {
        .init(id: self.id)
    }
}

class SPAGraph {
    private(set) var nodes: [SPAGraphNode] = []
    
    func insert(_ newNode: SPAGraphNode) {
        var stack = self.nodes
        var inserted = false
        
        while !stack.isEmpty {
            var aNode = stack.removeFirst()
            if aNode.id == newNode.id, aNode.children.isEmpty {
                aNode = newNode
                inserted = true
            }
            stack += aNode.children
        }
        
        if !inserted {
            self.nodes.append(newNode)
        }
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
