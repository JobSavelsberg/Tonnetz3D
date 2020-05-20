import peasy.*;

// Camera parameters and variables
public static final float fov = PI/3;  // field of view
public static final float nearClip = 1;
public static final float farClip = 5000;
public static final float distance = 300;
public static float aspect;

public static String midiDevice = "Microsoft GS Wavetable Synth"; // "loopMIDI Port";

public enum Element {
  FACE, EDGE, VERTEX,
}
// removeOnNewRoot: whether the old tetras should be removed or not when a new root is created
public static boolean removeOnNewRoot; 
public static boolean keepPreviousRoot;
public static boolean allowReverseTravel = false;
// placeSingle: whether only a single tetra should be connected to a single face of another tetra when clicked
public static boolean placeSingle; 
// The placemode is a set of combinations of the above booleans, giving a better interface for mode checks
public enum PlaceMode {
  BUILD, EXPLORE,
}
public static Element element = Element.VERTEX;

void setPlaceMode(PlaceMode mode){
  if(mode == PlaceMode.BUILD){
    switch(element){
      case VERTEX: removeOnNewRoot = false; keepPreviousRoot = false; placeSingle = true; break;
      case EDGE: removeOnNewRoot = false; keepPreviousRoot = false; placeSingle = true; break;
      case FACE: removeOnNewRoot = false; keepPreviousRoot = false; placeSingle = true; break;
    }
  }else if(mode == PlaceMode.EXPLORE){
    switch(element){
      case VERTEX: removeOnNewRoot = true; keepPreviousRoot = false; placeSingle = false; break;
      case EDGE: removeOnNewRoot = true; keepPreviousRoot = false; placeSingle = false; break;
      case FACE: removeOnNewRoot = true; keepPreviousRoot = true; placeSingle = false; break;
    }
  }

  placeMode = mode;
}

void changeElement(Element newElement){
  element = newElement;
  setPlaceMode(placeMode);
  println("Element set to: " + element);
}

public static PlaceMode placeMode;

public static boolean edgeConnectStraight = true;

/** 
*  Sequence of notes added when a new root is created
*  Follows the order of: major 3rd, minor 3rd, repeat.
*  But is changable, it loops through the sequence using nextNote()
*  Looping through the sequence with bigger steps can be done with nextNote(stepSize)
*/
static final String[] seq3rds = new String[]{
  "A", "C#", "E", "G#", "B", "D#", "F#", "A#", "C#", "F", "G#",
  "C", "D#", "G", "A#", "D", "F", "A", "C", "E", "G", "B", "D", "F#"
}; 
static final String[] seq5ths = new String[]{
  "A", "E", "B", "F#", "C#", "G#", "D#", "A#", "F", "C", "G", "D"
}; 
static final String[] seq = seq3rds;

/*
* Similar to the sequence of notes a sequence of colors is used to make new generated triangles have different colors
* Use nextColor() and nextColor(step)
*/
final color[] colors = new color[]{
  color(255,0,0), color(0,255,0), color(0,0,255), color(255,255,0), color(0,255,255), color(255,0,255)
};

PeasyCam cam;
Midi midi;
RayPicker picker;

ArrayList<Tetra> tetraStructure = new ArrayList<Tetra>();
TetraStructureHistory tetraStructureHistory;
ArrayList<NoteText> noteTexts = new ArrayList<NoteText>();

void setup() {
  size(1080, 720, P3D); 
  textAlign(CENTER, CENTER);

  aspect = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);  
  cam = new PeasyCam(this, distance);
  cam.setResetOnDoubleClick(false);
  
  picker = new RayPicker(cam);


  midi = new Midi(0, midiDevice); // channel 0
  
  setPlaceMode(PlaceMode.EXPLORE);
  tetraStructureHistory = new TetraStructureHistory(tetraStructure);

  createInitialTetra(22); // 22 = the "D" before "F#" in the sequence

  lastTime = millis();
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
void update(int time){
  deltaTime = time - lastTime;
  timer += deltaTime / 1000f;
  siner = (sin(timer*5)+1)/2;
  
  midi.update(deltaTime);
  
  for(Tetra tetra: tetraStructure){
    tetra.update(deltaTime);
  }
  
  lastTime = time;
}
void draw() {
  update(millis());
  background(255);
  for(Tetra tetra : tetraStructure){
    tetra.draw();
    tetra.drawNotesPre(cam);
  }
  cam.beginHUD();
  for(Tetra tetra : tetraStructure){
    tetra.drawNotesHUD(cam);
  }
  cam.endHUD();

  drawDebugSphere();  
}

void drawNote(String note, float size, float x, float y){
  textSize(size);
  text(note, x, y);
}
TetraElement picked = null;
void mousePressed(){ 
  picked = picker.pick(mouseX,mouseY, tetraStructure, element);
  if(picked != null && picked.getTetra() != null){
    if(mouseButton==LEFT){
      picked.getTetra().play(midi);
    }else if(mouseButton==RIGHT){
      cam.setActive(false);
      if(!picked.alreadyConnected()){
        switch(placeMode){
          case EXPLORE: makeNewRoot(picked.getTetra()); break;
          case BUILD: placeNewTetra(picked); break;
        }
      }
    }
  }
}

void mouseReleased(){
  if(picked != null && picked.getTetra() != null){
    cam.setActive(true);
    picked = null;
  }
}

void makeNewRoot(Tetra root){
  PVector centroid = root.centroid;
  cam.lookAt(centroid.x, centroid.y, centroid.z);
  root.setRoot(true);
  if(removeOnNewRoot){
    removeAllButRoot(root);
    //Remove root status of previous root
    if(keepPreviousRoot){
      tetraStructure.get(0).setRoot(false); 
      tetraStructure.get(0).removeNotesShownBy(root);
    }else if(allowReverseTravel){
      root.freeConnections();  
    }
  }
  // Swap previous root at index 0 with new root
  if(tetraStructure.size() > 1){
    Tetra previousRoot = tetraStructure.get(0);
    if(tetraStructure.contains(root)){
      tetraStructure.remove(root);  
    }
    tetraStructure.set(0, root);
    tetraStructure.add(previousRoot);
  }
  
  if(element == Element.FACE){
    for(int face : root.getFaces()){
      placeOnFace(root, face);
    }
  }else if(element == Element.EDGE){
    for(Set<Integer> edge : root.getEdges()){
      placeOnEdge(root, edge);
    }
  }else if(element == Element.VERTEX){
    for(int vertex : root.getVertices()){
      placeOnVertex(root, vertex, true);
    }
  } 
  tetraStructureHistory.push();
}

void removeAllButRoot(Tetra root){
 for(int i = tetraStructure.size()-1; i >= 0 ; i--){
    if(tetraStructure.get(i) == root) continue;
    if(keepPreviousRoot && tetraStructure.get(i).isRoot()) continue;
    Tetra tetra = tetraStructure.get(i);
    tetra.remove(tetraStructure);
    tetraStructure.remove(i);
  }  
}

void placeNewTetra(TetraElement picked){
  PVector centroid = picked.getTetra().centroid;
  cam.lookAt(centroid.x, centroid.y, centroid.z);
  switch(element){
    case FACE: placeOnFace((TetraFace) picked); break;
    case EDGE: placeOnEdge((TetraEdge) picked); break;
    case VERTEX: placeOnVertex((TetraVertex) picked, false); break;
  }
  tetraStructureHistory.push();
}

void placeOnFace(TetraFace tetraFace){ placeOnFace(tetraFace.getTetra(), tetraFace.getFace()); }
void placeOnFace(Tetra root, int face){
  color c = nextColor();
  if(!root.getFaceConnected(face)){
    Tetra t = new Tetra(root, root.getFace(face));
    t.setColor(c);
    tetraStructure.add(t);
  }
}

void placeOnEdge(TetraEdge tetraEdge){ placeOnEdge(tetraEdge.getTetra(), tetraEdge.getEdge()); }
void placeOnEdge(Tetra root, Set<Integer> edge){
  color c = nextColor();
  if(!root.getEdgeConnected(edge)){
    if(edgeConnectStraight){
      Tetra straightTetra = new Tetra(root, edge, EdgeConnectType.EDGESTRAIGHT, false);
      straightTetra.setColor(c);
      tetraStructure.add(straightTetra);
    }else{
      Tetra leftTetra = new Tetra(root, edge, EdgeConnectType.EDGELEFT, false);
      leftTetra.setColor(c);
      Tetra rightTetra = new Tetra(root, edge, EdgeConnectType.EDGERIGHT, false);
      rightTetra.setColor(c);
      tetraStructure.add(leftTetra);
      tetraStructure.add(rightTetra);
    }
  }
}

void placeOnVertex(TetraVertex tetraVertex, boolean addLevel){ placeOnVertex(tetraVertex.getTetra(), tetraVertex.getVertex(), addLevel); }
void placeOnVertex(Tetra root, int vertex, boolean addLevel){
  color c = nextColor();
  if(!root.getVertexConnected(vertex)){
    Tetra vertexTetra = new Tetra(root, vertex);
    vertexTetra.setColor(c);
    tetraStructure.add(vertexTetra);
    if(addLevel){
      for(int side : vertexTetra.getFace(0)){
        //c = nextColor();
        Tetra sideTetra = new Tetra(vertexTetra, vertexTetra.getFace(side));
        sideTetra.setColor(c);
        tetraStructure.add(sideTetra);
      }
      for(int topVertex: vertexTetra.getFace(0)){
        Set<Integer> edge = new HashSet<Integer>();
        edge.add(topVertex); edge.add(0);
        //c = nextColor();
        Tetra sideTetra = new Tetra(vertexTetra, edge, EdgeConnectType.EDGESTRAIGHT, true);
        sideTetra.setColor(c);
        tetraStructure.add(sideTetra);
      }
    }
  }
}


void keyPressed() {
  switch(key){
    case ' ': tetraStructure.get(0).play(midi); break;
    case 'a': tetraStructure.get(1).play(midi); break;
    case 's': tetraStructure.get(2).play(midi); break;
    case 'd': tetraStructure.get(3).play(midi); break;
    case 'f': tetraStructure.get(4).play(midi); break;
    case 'r': reset(); break;
    case 't': setRemoveOnNewRoot(!removeOnNewRoot); break;
    case 'y': setPlaceSingle(!placeSingle); break;
    case 'u': changeElement(Element.FACE); break;
    case 'i': changeElement(Element.EDGE);break;
    case 'o': changeElement(Element.VERTEX); break;
    case 'm': midiRandomize = !midiRandomize; break;
    case ',': tetraStructureHistory.previous(); resetCamera(); break;
    case '.': tetraStructureHistory.next(); resetCamera(); break;
  }
}

void reset(){
  tetraStructureHistory.reset();
  tetraStructure.clear();
  currentNote = -1;
  currentColor = -1;
  createInitialTetra(22); // 22 = "D" before "F#"
  tetraStructureHistory.push();
}

void resetCamera(){
  if(tetraStructure.size() > 0){
    lookAt(tetraStructure.get(0));
  }
}

void lookAt(Tetra tetra){
  PVector centroid = tetra.getCentroid();
  cam.lookAt(centroid.x, centroid.y, centroid.z);  
}

void setRemoveOnNewRoot(boolean newRemoveOnNewRoot){
  // TODO: fix bugs
  removeOnNewRoot = newRemoveOnNewRoot; 
  println("removeOnNewRoot: "+removeOnNewRoot);
}

void setPlaceSingle(boolean newPlaceSingle){
  placeSingle = newPlaceSingle; 
  println("placeOnFace: "+placeSingle);
}

/*
* The following functions and variables are used to loop through the sequences
*/
int currentNote = -1;
public String nextNote(){ return nextNote(1); }
public String nextNote(int i){
  currentNote += i;
  return getNoteInSequence(currentNote);
}

int currentColor = -1;
public color nextColor(){ return nextColor(1); }
public color nextColor(int i){
  currentColor += i;
  return colors[currentColor%colors.length];
}

public static String getNoteInSequence(int i){
  return seq[i%seq.length];
}

public static PVector debugSphere = null;
public void drawDebugSphere(){
  fill(0);
  if(debugSphere != null){
    translate(debugSphere.x,debugSphere.y,debugSphere.z);
    sphere(5);
    translate(-debugSphere.x,-debugSphere.y,-debugSphere.z);

  }
}

public void drawDebugVector(PVector from, PVector to){

    strokeWeight(10);
    line(from.x,from.y,from.z,to.x,to.y,to.z);
    translate(to.x,to.y,to.z);
    sphere(2);
    translate(-to.x,-to.y,-to.z); 

}
