import go from 'gojs';

var diagram = new go.Diagram("myDiagramDiv");

// For conciseness. See the "Building Parts" intro page for more
var $ = go.GraphObject.make;

// the node template describes how each Node should be constructed
diagram.nodeTemplate = $(go.Node, "Auto",  // the Shape automatically fits around the TextBlock
    $(go.Shape, "RoundedRectangle",  // use this kind of figure for the Shape
      // bind Shape.fill to Node.data.color
      new go.Binding("fill", "color")),
    $(go.TextBlock,
      { margin: 3 },  // some room around the text
      // bind TextBlock.text to Node.data.key
      new go.Binding("text", "key"))
  );

// the Model holds only the essential information describing the diagram
diagram.model = new go.GraphLinksModel(
[ // a JavaScript Array of JavaScript objects, one per node;
  // the "color" property is added specifically for this app
  { key: "Alpha", color: "lightblue" },
  { key: "Beta", color: "orange" },
  { key: "Gamma", color: "lightgreen" },
  { key: "Delta", color: "pink" }
],
[ // a JavaScript Array of JavaScript objects, one per link
  { from: "Alpha", to: "Beta" },
  { from: "Alpha", to: "Gamma" },
  { from: "Beta", to: "Beta" },
  { from: "Gamma", to: "Delta" },
  { from: "Delta", to: "Alpha" }
]);

// enable Ctrl-Z to undo and Ctrl-Y to redo
diagram.undoManager.isEnabled = true;