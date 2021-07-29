import React from 'react';
import Tree from 'react-d3-tree';
import treeData from './treeData.json'

export default function App() {
  return (
    <div id="treeWrapper" style={{ width: '100vw', height: '100vh' }}>
      <Tree data={treeData} />
    </div>
  );
}
