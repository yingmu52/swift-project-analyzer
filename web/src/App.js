import React from "react";
import { Graph } from "react-d3-graph";
import config from "./config";
import data from "./graph.json";

// const data = {
//   nodes: [{ id: "Harry" }, { id: "Sally" }, { id: "Alice" }],
//   links: [
//     { source: "Harry", target: "Sally" },
//     { source: "Harry", target: "Alice" },
//   ],
// };

export default function App() {
  const onClickNode = function (nodeId) {};
  const onClickLink = function (source, target) {};

  return (
    <Graph
      id="graph-id" // id is mandatory
      data={data}
      config={config}
      onClickNode={onClickNode}
      onClickLink={onClickLink}
    />
  );
}
