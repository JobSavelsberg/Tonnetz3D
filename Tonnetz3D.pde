import peasy.*;

// Camera parameters and variables
public static final float fov = PI/3;  // field of view
public static final float nearClip = 1;
public static final float farClip = 1000;
public static final float distance = 300;
public static float aspect;

public enum Element {
  FACE, EDGE, VERTEX,
}
// removeOnNewRoot: whether the old tetras should be removed or not when a new root is created
public static boolean removeOnNewRoot; 
// placeSingle: whether only a single tetra should be connected to a single face of another tetra when clicked
public static boolean placeSingle; 
// The placemode is a set of combinations of the above booleans, giving a better interface for mode checks
public enum PlaceMode {
  BUILD, EXPLORE,
}
void setPlaceMode(PlaceMode mode){
  switch(mode){
    case BUILD: removeOnNewRoot = false; placeSingle = true; break;
    case EXPLORE: removeOnNewRoot = true; placeSingle = false; break;
  }
  placeMode = mode;
}

public static Element element = Element.FACE;
public static PlaceMode placeMode;

public static boolean edgeConnectStraight = true;

/** 
*  Sequence of notes added when a new root is created
*  Follows the order of: major 3rd, minor 3rd, repeat.
*  But is changable, it loops through the sequence using nextNote()
*  Looping through the sequence with bigger steps can be done with nextNote(stepSize)
*/
static final String[] seq = new String[]{
  "A", "C#", "E", "G#", "B", "D#", "F#", "A#", "C#", "F", "G#",
  "C", "D#", "G", "A#", "D", "F", "A", "C", "E", "G", "B", "D", "F#"
}; 

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

void setup() {
  size(1080, 720, P3D); 

  aspect = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);  
  cam = new PeasyCam(this, distance);
  cam.setResetOnDoubleClick(false);
  
  picker = new RayPicker(cam);

  midi = new Midi(1); // channel 0
  
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
  }
  for(Tetra tetra : tetraStructure){
    tetra.drawNotes(cam);
  }
  drawDebugSphere();
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
  root.makeRoot();
  
  if(removeOnNewRoot){
    removeAllButRoot(root);
  }else{
    // Swap previous root at index 0 with new root
    if(tetraStructure.size() > 1){
      Tetra previousRoot = tetraStructure.get(0);
      tetraStructure.set(0, root);
      tetraStructure.add(previousRoot);
    }
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
      placeOnVertex(root, vertex);
    }
  } 
  tetraStructureHistory.push();
}

void placeNewTetra(TetraElement picked){
  switch(element){
    case FACE: placeOnFace((TetraFace) picked); break;
    case EDGE: placeOnEdge((TetraEdge) picked); break;
    case VERTEX: placeOnVertex((TetraVertex) picked); break;
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
      Tetra straightTetra = new Tetra(root, edge, EdgeConnectType.EDGESTRAIGHT);
      straightTetra.setColor(c);
      tetraStructure.add(straightTetra);
    }else{
      Tetra leftTetra = new Tetra(root, edge, EdgeConnectType.EDGELEFT);
      leftTetra.setColor(c);
      Tetra rightTetra = new Tetra(root, edge, EdgeConnectType.EDGERIGHT);
      rightTetra.setColor(c);
      tetraStructure.add(leftTetra);
      tetraStructure.add(rightTetra);
    }
  }
}

void placeOnVertex(TetraVertex tetraVertex){ placeOnVertex(tetraVertex.getTetra(), tetraVertex.getVertex()); }
void placeOnVertex(Tetra root, int vertex){
  color c = nextColor();
  if(!root.getVertexConnected(vertex)){
    //TODO
  }
}


void removeAllButRoot(Tetra root){
 for(int i = tetraStructure.size()-1; i >= 0 ; i--){
    if(tetraStructure.get(i) != root){
      tetraStructure.remove(i);
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

void changeElement(Element newElement){
  element = newElement;
  println("Element set to: " + element);
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
