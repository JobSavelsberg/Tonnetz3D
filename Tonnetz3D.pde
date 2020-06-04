import peasy.*;

// Camera parameters and variables
public static final float fov = PI/3;  // field of view
public static final float nearClip = 1;
public static final float farClip = 5000;
public static final float distance = 300;
public static float aspect;

PeasyCam cam;
Midi midi;
RayPicker picker;
UI ui;

int w, h;

ArrayList<Tetra> tetraStructure = new ArrayList<Tetra>();
public TetraStructureHistory tetraStructureHistory;
ArrayList<NoteText> noteTexts = new ArrayList<NoteText>();

void setup() {
  size(1080, 720, P3D); 
  textAlign(CENTER, CENTER);
  
  surface.setResizable(true);
  
  w=width;
  h=height ;
  registerMethod ("pre", this ) ;
  
  Options.initDefault();
  ui = new UI(this);

  aspect = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);  
  cam = new PeasyCam(this, distance);
  cam.setResetOnDoubleClick(false);

  picker = new RayPicker(cam);

  midi = new Midi(0, Options.midiDevice); // channel 0

  tetraStructureHistory = new TetraStructureHistory(tetraStructure);

  createInitialTetra(22); // 22 = the "D" before "F#" in the sequence

  lastTime = millis();
}

void pre () {
  if (w != width || h != height) {
    Options.fontSize = round(float(Options.fontSize)*(float(width)/w));
    w=width;
    h=height;
    updateCam();
    ui.resizeWindow();
  } 
} 
void updateCam(){
  aspect = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);    
  cam.setViewport(0,0,width,height);
  cam.feed();
}

/*
* Creates the initial tetra, the input is the note index added to all of the face tetras
 * So the notes of the root tetra will be the 4 preceding notes
 */
void createInitialTetra(int nextNoteInSequence) {  
  Tetra root = new Tetra(nextNoteInSequence);
  tetraStructure.add(root);
  makeNewRoot(root);
  root.setRoot(true);
}

int lastTime = 0;
int deltaTime = 0;
float timer = 0;
float siner = 0; // goes from 0 to 1
void update(int time) {
  deltaTime = time - lastTime;
  timer += deltaTime / 1000f;
  siner = (sin(timer*5)+1)/2;

  midi.update(deltaTime);

  for (Tetra tetra : tetraStructure) {
    tetra.update(deltaTime);
  }

  lastTime = time;
}
void draw() {
  update(millis());
  background(255);
  for (Tetra tetra : tetraStructure) {
    tetra.draw();
    tetra.drawNotesPre(cam);
  }
  cam.beginHUD();
  for (Tetra tetra : tetraStructure) {
    tetra.drawNotesHUD(cam);
  }
  ui.draw();
  cam.endHUD();

  drawDebugSphere();
}

void drawNote(String note, float size, float x, float y) {
  textSize(size);
  text(note, x, y);
}
TetraElement picked = null;
void mousePressed() { 
  picked = picker.pick(mouseX, mouseY, tetraStructure, Options.element);
  if (picked != null && picked.getTetra() != null) {
    if (mouseButton==LEFT) {
      picked.getTetra().play(midi);
    } else if (mouseButton==RIGHT) {
      cam.setActive(false);
      if (!picked.alreadyConnected()) {
        switch(Options.placeMode) {
        case EXPLORE: 
          makeNewRoot(picked.getTetra()); 
          break;
        case BUILD: 
          placeNewTetra(picked); 
          break;
        }
      }
    }
  }
}

void mouseReleased() {
  if (picked != null && picked.getTetra() != null) {
    cam.setActive(true);
    picked = null;
  }
}

void makeNewRoot(Tetra root) {
  PVector centroid = root.centroid;
  cam.lookAt(centroid.x, centroid.y, centroid.z);
  root.setRoot(true);
  ui.setColor(root.getColor());
  if (Options.removeOnNewRoot) {
    removeAllButRoot(root);
    //Remove root status of previous root
    if (Options.keepPreviousRoot) {
      tetraStructure.get(0).setRoot(false); 
      tetraStructure.get(0).removeNotesShownBy(root);
    } else if (Options.allowReverseTravel) {
      root.freeConnections();
    }
  }
  // Swap previous root at index 0 with new root
  if (tetraStructure.size() > 1) {
    Tetra previousRoot = tetraStructure.get(0);
    if (tetraStructure.contains(root)) {
      tetraStructure.remove(root);
    }
    tetraStructure.set(0, root);
    tetraStructure.add(previousRoot);
  }
  if (Options.element == Options.Element.FACE) {
    for (int face : root.getFaces()) {
      placeOnFace(root, face);
    }
  } else if (Options.element == Options.Element.EDGE) {
    for (Set<Integer> edge : root.getEdges()) {
      placeOnEdge(root, edge);
    }
  } else if (Options.element == Options.Element.VERTEX) {
    for (int vertex : root.getVertices()) {
      placeOnVertex(root, vertex, true);
    }
  } 
  tetraStructureHistory.push();
}

void removeAllButRoot(Tetra root) {
  for (int i = tetraStructure.size()-1; i >= 0; i--) {
    if (tetraStructure.get(i) == root) continue;
    if (Options.keepPreviousRoot && tetraStructure.get(i).isRoot()) continue;
    Tetra tetra = tetraStructure.get(i);
    tetra.remove(tetraStructure);
    tetraStructure.remove(i);
  }
}

void placeNewTetra(TetraElement picked) {
  PVector centroid = picked.getTetra().centroid;
  cam.lookAt(centroid.x, centroid.y, centroid.z);
  switch(Options.element) {
  case FACE: 
    placeOnFace((TetraFace) picked); 
    break;
  case EDGE: 
    placeOnEdge((TetraEdge) picked); 
    break;
  case VERTEX: 
    placeOnVertex((TetraVertex) picked, false); 
    break;
  }
  ui.setColor(tetraStructure.get(tetraStructure.size()-1).getColor());
  tetraStructureHistory.push();
}

void placeOnFace(TetraFace tetraFace) { 
  placeOnFace(tetraFace.getTetra(), tetraFace.getFace());
}
void placeOnFace(Tetra root, int face) {
  color c = nextColor();
  if (!root.getFaceConnected(face)) {
    Tetra t = new Tetra(root, root.getFace(face));
    t.setColor(c);
    tetraStructure.add(t);
  }
}

void placeOnEdge(TetraEdge tetraEdge) { 
  placeOnEdge(tetraEdge.getTetra(), tetraEdge.getEdge());
}
void placeOnEdge(Tetra root, Set<Integer> edge) {
  color c = nextColor();
  if (!root.getEdgeConnected(edge)) {
    if (Options.edgeConnectStraight) {
      Tetra straightTetra = new Tetra(root, edge, EdgeConnectType.EDGESTRAIGHT, false);
      straightTetra.setColor(c);
      tetraStructure.add(straightTetra);
    } else {
      Tetra leftTetra = new Tetra(root, edge, EdgeConnectType.EDGELEFT, false);
      leftTetra.setColor(c);
      Tetra rightTetra = new Tetra(root, edge, EdgeConnectType.EDGERIGHT, false);
      rightTetra.setColor(c);
      tetraStructure.add(leftTetra);
      tetraStructure.add(rightTetra);
    }
  }
}

void placeOnVertex(TetraVertex tetraVertex, boolean addLevel) { 
  placeOnVertex(tetraVertex.getTetra(), tetraVertex.getVertex(), addLevel);
}
void placeOnVertex(Tetra root, int vertex, boolean addLevel) {
  color c = nextColor();
  if (!root.getVertexConnected(vertex)) {
    Tetra vertexTetra = new Tetra(root, vertex);
    vertexTetra.setColor(c);
    tetraStructure.add(vertexTetra);
    if (addLevel) {
      for (int side : vertexTetra.getFace(0)) {
        //c = nextColor();
        Tetra sideTetra = new Tetra(vertexTetra, vertexTetra.getFace(side));
        sideTetra.setColor(c);
        tetraStructure.add(sideTetra);
      }
      for (int topVertex : vertexTetra.getFace(0)) {
        Set<Integer> edge = new HashSet<Integer>();
        edge.add(topVertex); 
        edge.add(0);
        //c = nextColor();
        Tetra sideTetra = new Tetra(vertexTetra, edge, EdgeConnectType.EDGESTRAIGHT, false);
        sideTetra.setColor(c);
        tetraStructure.add(sideTetra);
      }
    }
  }
}

void changedExploreElement(){
  Tetra root = tetraStructure.get(0);
  root.freeConnections();
  makeNewRoot(root);
}
void keyPressed() {
  switch(key) {
  case ' ': 
    tetraStructure.get(0).play(midi); 
    break;
  case 'a': 
    tetraStructure.get(1).play(midi); 
    break;
  case 's': 
    tetraStructure.get(2).play(midi); 
    break;
  case 'd': 
    tetraStructure.get(3).play(midi); 
    break;
  case 'f': 
    tetraStructure.get(4).play(midi); 
    break;
  case 'r': 
    reset(); 
    break;
  case 'u': 
    Options.setElement(Options.Element.FACE); 
    break;
  case 'i': 
    Options.setElement(Options.Element.EDGE);
    break;
  case 'o': 
    Options.setElement(Options.Element.VERTEX); 
    break;
  case 'm': 
    midiRandomize = !midiRandomize; 
    break;
  case ',': 
    undo();
    break;
  case '.': 
    redo();
    break;
  }
}

void reset() {
  tetraStructureHistory.reset();
  tetraStructure.clear();
  currentNote = -1;
  currentColor = -1;
  createInitialTetra(22); // 22 = "D" before "F#"
  tetraStructureHistory.push();
}

void undo(){
  tetraStructureHistory.previous(); 
  resetCamera(); 
}

void redo(){
  tetraStructureHistory.next(); 
  resetCamera(); 
}
void resetCamera() {
  if (tetraStructure.size() > 0) {
    lookAt(tetraStructure.get(0));
  }
}

void lookAt(Tetra tetra) {
  PVector centroid = tetra.getCentroid();
  cam.lookAt(centroid.x, centroid.y, centroid.z);
}

/*
* The following functions and variables are used to loop through the sequences
 */
int currentNote = -1;
public String nextNote() { 
  return nextNote(1);
}
public String nextNote(int i) {
  currentNote += i;
  return getNoteInSequence(currentNote);
}

int currentColor = -1;
public color nextColor() { 
  return nextColor(1);
}
public color nextColor(int i) {
  currentColor += i;
  int[] newColor = Options.getColor(currentColor);
  return color(newColor[0], newColor[1], newColor[2]);
}

public static String getNoteInSequence(int i) {
  return Options.getSeq(i);
}

public static PVector debugSphere = null;
public void drawDebugSphere() {
  fill(0);
  if (debugSphere != null) {
    translate(debugSphere.x, debugSphere.y, debugSphere.z);
    sphere(5);
    translate(-debugSphere.x, -debugSphere.y, -debugSphere.z);
  }
}

public void drawDebugVector(PVector from, PVector to) {

  strokeWeight(10);
  line(from.x, from.y, from.z, to.x, to.y, to.z);
  translate(to.x, to.y, to.z);
  sphere(2);
  translate(-to.x, -to.y, -to.z);
}
