import peasy.*;

// Camera parameters and variables
public static final float fov = PI/3;  // field of view
public static final float nearClip = 1;
public static final float farClip = 1000;
public static final float distance = 300;
public static float aspect;

public enum Mode {
  FACE,
  EDGE,
  VERTEX,
}
public static Mode mode = Mode.FACE;
// removeOnNewRoot: whether the old tetras should be removed or not when a new root is created
public static boolean removeOnNewRoot = true; 
// placeOnSide: whether only a single tetra should be connected to a single side of another tetra when clicked
public static boolean placeOnSide = false; 


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
  createInitialTetra(22); // 22 = "D" before "F#"
  
  lastTime = millis();
  tetraStructureHistory = new TetraStructureHistory(tetraStructure);
}

/*
* Creates the initial tetra, the input is the note index added to all of the side tetras
* So the notes of the root tetra will be the 4 preceding notes
*/
void createInitialTetra(int next) {  
  currentNote = next;
  Tetra root = new Tetra(getSequence(next-4),getSequence(next-3),getSequence(next-2),getSequence(next-1));
  tetraStructure.add(root);
  makeNewRoot(root, getSequence(next));
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


RayPicker.TetraSide picked = null;
void mousePressed(){ 
  picked = picker.pick(mouseX,mouseY, tetraStructure);
  if(picked != null && picked.getTetra() != null){
    if(mouseButton==LEFT){
      picked.getTetra().play(midi);
    }else if(mouseButton==RIGHT){
      cam.setActive(false);
      if(!removeOnNewRoot && placeOnSide && picked.getSide()!=-1){
        placeOnSide(picked.getTetra(), picked.getSide(), nextNote());
      }else{
        if(picked.getTetra().connected[picked.getSide()] == false){
          makeNewRoot(picked.getTetra(), nextNote()); 
        }
      }
      tetraStructureHistory.push();
    }
  }
}

void mouseReleased(){
  if(picked != null && picked.getTetra() != null){
    cam.setActive(true);
    picked = null;
  }
}

/*
*  Sets a tetra to be the new root and connects 4 tetras with a given nextNote to each side of the root
*  When removeOnNewRoot is set we delete all other tetras first
*/
void makeNewRoot(Tetra root, String nextNote){
  PVector centroid = root.centroid;
  cam.lookAt(centroid.x, centroid.y, centroid.z);
  root.makeRoot();
  
  if(removeOnNewRoot){
    for(int i = tetraStructure.size()-1; i >= 0 ; i--){
      if(tetraStructure.get(i) != root){
        tetraStructure.remove(i);
      }
    }
  }else{
    // Swap previous root at index 0 with new root
    Tetra previousRoot = tetraStructure.get(0);
    tetraStructure.set(0, root);
    tetraStructure.add(previousRoot);
  }
  
  // Connect all four tetras to the side of the root
  for(int i = 0; i < 4; i++){
    if(!root.connected[i]){
      Tetra t  = new Tetra(root, root.getSide(i), nextNote);
      t.setColor(nextColor());
      tetraStructure.add(t);
    }
  }
}

/*
*  When placeOnSide = true, we can place a single tetra on one side of the root, instead of creating all adjacent tetras.
* only used when removeOnNewRoot is false
*/
void placeOnSide(Tetra root, int side, String nextNote){
  if(!root.connected[side]){
    PVector centroid = root.centroid;
    cam.lookAt(centroid.x, centroid.y, centroid.z);
    
    Tetra t = new Tetra(root, root.getSide(side), nextNote);
    t.setColor(nextColor());
    tetraStructure.add(t);
  }else{
    println("Can't connect to this side");  
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
    case 'y': setPlaceOnSide(!placeOnSide); break;
    case 'u': changeMode(Mode.FACE); break;
    case 'i': changeMode(Mode.EDGE);break;
    case 'o': changeMode(Mode.VERTEX); break;
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
  PVector newCentroid = tetraStructure.get(0).getCentroid();
  cam.lookAt(newCentroid.x, newCentroid.y,newCentroid.z);  
}

void changeMode(Mode newMode){
  mode = newMode;
  println("Mode set to: " + mode);
}

void setRemoveOnNewRoot(boolean newRemoveOnNewRoot){
  // TODO: fix bugs
  removeOnNewRoot = newRemoveOnNewRoot; 
  println("removeOnNewRoot: "+removeOnNewRoot);
}

void setPlaceOnSide(boolean newPlaceOnSide){
  placeOnSide = newPlaceOnSide; 
  println("placeOnSide: "+placeOnSide);
}

/*
* The following functions and variables are used to loop through the sequences
*/
int currentNote = -1;
public String nextNote(){ return nextNote(1); }
public String nextNote(int i){
  currentNote += i;
  return getSequence(currentNote);
}

int currentColor = -1;
public color nextColor(){ return nextColor(1); }
public color nextColor(int i){
  currentColor += i;
  return colors[currentColor%colors.length];
}

public String getSequence(int i){
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
