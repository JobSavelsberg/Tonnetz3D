/*
*  A tetra is an object containing 4 notes, it can be connected to other tetras sharing one face
*  
*    b 
*  /   \    d is behind
* a --- c
* 
* define faces in clockwise direction and call by missing vertex
* 
* cbd = face A 
* dac = face B
* bad = face C
* cab = face D
*
* Always connects at face D
*/

public static boolean midiRandomize = true;

enum EdgeConnectType{
  EDGERIGHT,
  EDGELEFT,
  EDGESTRAIGHT  
}
  
class Tetra{
  // Size of any of the tetrahedrons edges
  private static final float size = 60; 
  
  // Hardcoded number names for convenient and readable array indexing
  static final int a = 0; static final int b = 1; static final int c = 2; static final int d = 3;
  
  // Tetrahedron constants
  private final float invsqrt2 = 1f/sqrt(2f);
  private final float tetraWidth = 2*sqrt(6f)/3f;
  private final float faceHeight = 2*sqrt(0.75f);
  private final float midEdgeToOppositeMidEdge = sqrt(faceHeight*faceHeight - 1f);
  
  // Midi parameters
  private static final int midiDuration = 1000; // milliseconds
  private static final int midiVelocity = 70; // 0-127
  private static final int midiStrumDelay = 70;
  private static final int midiMinOctave = 2;
  private static final int midiMaxOctave = 4;
  // Drawing
  private static final float strokeWeight = 3;
  private static final float textSize = 15;
  private static final float textOffset = 15;
  private static final float colorAlpha = 169;
  private final color strokeColor = color(200,200,200);
  private color tetraColor = color(127);
  private static final boolean useToneColorMapping = true;
  
  // Used as a timer for pulse effects (when playing a tetra chord)
  private int pulseTime = 0;
  private int pulse = 0;
  private color pulseColor = color(255,255,255,0);

  public boolean[] connectedFace = {false,false,false,false}; 
  // ab, bc, ca, ad, bd, cd
  public boolean[] connectedEdge = {false,false,false,false, false, false}; 
  public boolean[] connectedVertex = {false,false,false,false}; 
  
  public boolean[] showNote = {true, true, true, true}; 

  public int nextNoteInSequence;
  public String[] notes = new String[4];
  public PVector[] points = new PVector[4];
  public PVector centroid;

  private PShape tetraShape;

  private boolean visible = true;
  private boolean root = false;  
  private boolean initial = false;

  public Tetra(int nextNoteInSequence) {
    root = true;
    initial = true;
    notes[a] = Tonnetz3D.getNoteInSequence(nextNoteInSequence - 4);
    notes[b] = Tonnetz3D.getNoteInSequence(nextNoteInSequence - 3);
    notes[c] = Tonnetz3D.getNoteInSequence(nextNoteInSequence - 2);
    notes[d] = Tonnetz3D.getNoteInSequence(nextNoteInSequence - 1);
    this.nextNoteInSequence = nextNoteInSequence;
    points[a] = new PVector(1, 0, -invsqrt2).mult(size);
    points[b] = new PVector(-1, 0, -invsqrt2).mult(size);
    points[c] = new PVector(0, -1, invsqrt2).mult(size);
    points[d] = new PVector(0, 1, invsqrt2).mult(size);
    makeShape();
    centroid = getCentroid();
  }
  
  // Construct tetra on root's face
  public Tetra(Tetra root, int[] face) {
    if(root.connectedFace[faceArrayToVertex(face)]){
      new Exception("Face is already connected").printStackTrace();
    }
    notes[a] = root.notes[face[c]];
    notes[b] = root.notes[face[b]];
    notes[c] = root.notes[face[a]];
    notes[d] = Tonnetz3D.getNoteInSequence(root.nextNoteInSequence);
    this.nextNoteInSequence = root.nextNoteInSequence+1;
    points[a] = root.points[face[c]];
    points[b] = root.points[face[b]];
    points[c] = root.points[face[a]];
    PVector faceMiddle = getFaceMiddle(d);
    PVector invNormal = PVector.mult(getNormal(getFaceD()), -1);
    points[d] = PVector.add(faceMiddle, invNormal.normalize().mult(tetraWidth*size));
    centroid = getCentroid();
    
    makeShape();

    connectedFace[d] = true;
    root.connectedFace[faceArrayToVertex(face)] = true;
    
    pulse(color(255,255,255,0),500);
  }
  
  
  /*   
  *  Construct tetra on root's edge
  * 
  *   D C is a single point aka E
  *           E                           C--F--D
  * LEFT     D C       RIGHT               \   /
  *      C    |    D                        \ / 
  *           A                              A
  *         / B \    B is behind A         / B \
  *        D-----C                        D-----C
  */      
  public Tetra(Tetra root, Set<Integer> edge, EdgeConnectType edgeConnectType){
    String noteA = Tonnetz3D.getNoteInSequence(root.nextNoteInSequence + 1);
    String noteB = Tonnetz3D.getNoteInSequence(root.nextNoteInSequence + 2);
    this.nextNoteInSequence = root.nextNoteInSequence + 3;
    points[a] = root.points[(int) edge.toArray()[0]];
    points[b] = root.points[(int) edge.toArray()[1]];
    notes[a] = root.notes[(int) edge.toArray()[0]];
    notes[b] = root.notes[(int) edge.toArray()[1]];
  
    PVector ABmiddle = getEdgeMiddle(verticesToEdge(a,b));
    PVector rootCentroid = root.getCentroid();
    PVector Edir = PVector.sub(ABmiddle, rootCentroid).normalize();
    PVector E = PVector.add(ABmiddle, PVector.mult(Edir, size * faceHeight));
    PVector F = PVector.add(ABmiddle, PVector.mult(Edir, size * midEdgeToOppositeMidEdge));
    //normal will point left
    PVector N = getNormal(points[a], points[b], E);
    PVector lastVertex;
    if(edgeConnectType == EdgeConnectType.EDGERIGHT){
      lastVertex = PVector.add(getFaceMiddle(points[a], points[b], E), N.mult(-tetraWidth*size));
      points[c] = E;
      notes[c] = noteA;
      points[d] = lastVertex;
      notes[d] = noteB;
    }else if(edgeConnectType == EdgeConnectType.EDGELEFT){
      lastVertex = PVector.add(getFaceMiddle(points[a], points[b], E), N.mult(tetraWidth*size));
      points[c] = lastVertex;
      notes[c] = noteB; //<>//
      points[d] = E;
      notes[d] = noteA;
    }else if(edgeConnectType == EdgeConnectType.EDGESTRAIGHT){
      points[c] = PVector.add(F,PVector.mult(N, size)); 
      notes[c] = noteA;
      points[d] = PVector.add(F,PVector.mult(N, -size)); 
      notes[d] = noteB;
    }
    
    centroid = getCentroid();
        
    makeShape();
    
    connectedEdge[a] = true;
    root.setEdgeConnected(edge, true);
    
    pulse(color(255,255,255,0),500);
  }
  
  /*
  *  Construct tetra on root's vertex (A)
  *
  *           B                     D-----C 
  *         / A \    A is behind B   \ A /
  *        C-----D                     B
  */
  public Tetra(Tetra root, int vertex){
    points[a] = root.points[vertex];
    notes[a] = root.notes[vertex]; 
    int[] oppositeFace = root.getFace(vertex);
    for(int i = 0; i < 3; i++){
      PVector point = root.points[oppositeFace[i]];
      PVector mirrored = PVector.add(points[a], PVector.sub(points[a], point));
      points[1+i] = mirrored;
      notes[1+i] = Tonnetz3D.getNoteInSequence(root.nextNoteInSequence + i);
    }
    nextNoteInSequence = root.nextNoteInSequence +4;
    centroid = getCentroid();
        
    makeShape();
    
    connectedVertex[a] = true;
    root.setVertexConnected(vertex, true);
    
    pulse(color(255,255,255,0),500);
  }

  
  // Called for every created tetra
  public void makeShape(){
    tetraShape = createShape();
    tetraShape.beginShape(TRIANGLES);
    tetraShape.stroke(strokeColor);
    tetraShape.strokeWeight(strokeWeight);
    tetraShape.fill(color(red(currentColor),green(currentColor), blue(currentColor), colorAlpha));
    tri(c,b,d);
    tri(d,a,c);
    tri(b,a,d);
    tri(c,a,b);
    tetraShape.endShape();
  }
  private void tri(int a, int b, int c){
    vert(a);
    vert(b);
    vert(c);
  }
  private void vert(int i){
    tetraShape.vertex(points[i].x,points[i].y,points[i].z);
  }
  


  public void update(int deltaTime){
    if(pulse > 0){
      float lerpValue = 1 - pulse / (float) pulseTime; // from 0 to 1
      color currentColor = lerpColor(pulseColor,color(red(tetraColor),green(tetraColor), blue(tetraColor), colorAlpha), lerpValue);
      tetraShape.setFill(currentColor); 
      tetraShape.setStroke(lerpColor(color(red(strokeColor),green(strokeColor), blue(strokeColor), alpha(pulseColor)), strokeColor, lerpValue));
      pulse -= deltaTime;
      if(pulse <= 0){
        currentColor = tetraColor; 
        tetraShape.setFill(currentColor); 
        tetraShape.setStroke(strokeColor);
      }
    }
  }
  
  public void draw(){
    if(visible && tetraShape != null){
      shape(tetraShape);
    }
  }
  
  public void drawNotes(PeasyCam cam){
    if(!visible || tetraShape == null) {return;} 
    textAlign(CENTER, CENTER);
    color textColor = tetraShape.getFill(0);
    fill(color(red(textColor)/1.5f,green(textColor)/1.5f,blue(textColor)/1.5f,alpha(textColor)*1.5f));
    float[] x = new float[4];
    float[] y = new float[4];
    for(int i = 0; i < notes.length; i++){
      if(root || i == d || (element == Element.EDGE)){
        PVector oD = PVector.sub(points[i], centroid).normalize(); // Offset Direction
        x[i] = screenX(points[i].x+oD.x*textOffset, points[i].y+oD.y*textOffset, points[i].z+oD.z*textOffset);
        y[i] = screenY(points[i].x+oD.x*textOffset, points[i].y+oD.y*textOffset, points[i].z+oD.z*textOffset);
      }
    }
    float[] camPosition = cam.getPosition();
    PVector camPosVec = new PVector(camPosition[0],camPosition[1],camPosition[2]);
    cam.beginHUD();
    for(int i = 0; i < notes.length; i++){
      if(element == Element.FACE){
        if(Tonnetz3D.removeOnNewRoot){
          if(!root && i!=d) continue;
        }else{
          if(!initial && i!= d) continue;
        }
      }
      
      float zoomedTextSize = textSize * 1000 / PVector.dist(points[i], camPosVec);
      textSize(zoomedTextSize);
      text(notes[i], x[i], y[i]);
    }
    cam.endHUD();
  }

  public void play(Midi midi) {
    if(midiRandomize){
      midi.strumChord(notes, midiVelocity, midiDuration, midiStrumDelay, midiMinOctave, midiMaxOctave);
    }else{
      int octave = (midiMinOctave + midiMaxOctave) / 2;
      midi.playChord(notes, octave, midiVelocity, midiDuration);
    }
    pulse(color(255,255,255,255), midiDuration);
  }
  
  public void pulse(color pulseColor, int duration){
    this.pulse = duration;
    this.pulseTime = duration;
    this.pulseColor = pulseColor;
  }
  
  public void setNotes(String[] notes){
    this.notes = notes; 
  }
  
  public void setColor(int r, int g, int b){
    if(useToneColorMapping){
      
    }else{
      this.setColor(color(r,g,b)); 
    }
  }
  
  public void setVisible(boolean visible){
    this.visible = visible; 
  }
 
  public void setRoot(boolean newRoot){
    if(newRoot){
      root = true;
      setColor(color(127));
    }else{
      root = false;
    }
  }
  
  public boolean isRoot(){
    return root;  
  }
  
  public void setColor(color colorValue){
    this.tetraColor = color(red(colorValue),green(colorValue), blue(colorValue), colorAlpha);
    if(tetraShape != null){
       tetraShape.setFill(color(red(tetraColor),green(tetraColor), blue(tetraColor),colorAlpha)); 
    }
  }

  /*
  *    b 
  *  /   \       d is behind
  * a --- c
  * 
  * define faces in clockwise direction
  * 
  * cbd = face A 
  * dac = face B
  * bad = face C
  * cab = face D
  */
  public PVector[] getFaceAPoints(){ return new PVector[]{points[c], points[b], points[d]}; }
  public PVector[] getFaceBPoints(){ return new PVector[]{points[d], points[a], points[c]}; }
  public PVector[] getFaceCPoints(){ return new PVector[]{points[b], points[a], points[d]}; }
  public PVector[] getFaceDPoints(){ return new PVector[]{points[c], points[a], points[b]}; }
  public int[] getFaceA(){ return new int[]{c,b,d}; }
  public int[] getFaceB(){ return new int[]{d,a,c}; }
  public int[] getFaceC(){ return new int[]{b,a,d}; }
  public int[] getFaceD(){ return new int[]{c,a,b}; }
  public PVector getPointA() { return points[a]; }
  public PVector getPointB() { return points[b]; }
  public PVector getPointC() { return points[c]; }
  public PVector getPointD() { return points[d]; }
  
  public boolean isInface(PVector point){
    for(int s = 0; s < 4; s++){
      if(!isSameFace(vertexToFaceArray(s), point)){ return false;}
    } 
    return true;
  }
  
  public boolean isSameFace(int[] face, PVector point){
     PVector invNormal = PVector.mult(getNormal(face),-1);
     float dotOpp = PVector.dot(invNormal, PVector.sub(points[faceArrayToVertex(face)], points[face[a]]));
     float dotPoint = PVector.dot(invNormal, PVector.sub(point, points[face[a]]));
     return sign(dotOpp) == sign(dotPoint);
  }
  
  public PVector getNormal(int[] face){
    return getNormal(points[face[a]],points[face[b]],points[face[c]]);
  }
  public PVector getNormal(PVector a, PVector b, PVector c){
    return PVector.sub(b,c).cross(PVector.sub(a,c)).normalize();
  }
  
  public PVector getCentroid(){
      return PVector.add(PVector.add(points[a],points[b]), PVector.add(points[c],points[d])).div(4);
  }
  public PVector getFaceMiddle(int face){
     return getFaceMiddle(points[getFace(face)[a]], points[getFace(face)[b]], points[getFace(face)[c]]);
  }
  public PVector getFaceMiddle(PVector a, PVector b, PVector c){
     return PVector.add(PVector.add(a,b), c).div(3); 
  }
  public PVector getEdgeMiddle(Set<Integer> edge){
    return PVector.add(points[(int) edge.toArray()[0]], points[(int) edge.toArray()[1]]).div(2);
  }
  
  public ArrayList<Set<Integer>> getEdges(){
    ArrayList<Set<Integer>> edgeList = new ArrayList<Set<Integer>>();
    Set<Integer> edge0 = new HashSet<Integer>();
    edge0.add(a);edge0.add(b);
    edgeList.add(edge0);
    Set<Integer> edge1 = new HashSet<Integer>();
    edge1.add(b);edge1.add(c);
    edgeList.add(edge1);
    Set<Integer> edge2 = new HashSet<Integer>();
    edge2.add(c);edge2.add(a);
    edgeList.add(edge2);
    Set<Integer> edge3 = new HashSet<Integer>();
    edge3.add(a);edge3.add(d);
    edgeList.add(edge3);
    Set<Integer> edge4 = new HashSet<Integer>();
    edge4.add(b);edge4.add(d);
    edgeList.add(edge4);
    Set<Integer> edge5 = new HashSet<Integer>();
    edge5.add(c);edge5.add(d);
    edgeList.add(edge5);
    return edgeList;    
  }
  
  public int[] getFaces(){
    return new int[]{a,b,c,d};  
  }
  
  public int[] getFace(int face){ return vertexToFaceArray(face); }
  public int[] vertexToFaceArray(int face){
    switch(face){
      case a: return getFaceA();
      case b: return getFaceB();
      case c: return getFaceC();
      case d: return getFaceD();
    }
    return null;
  }
  
  public PVector[] getFacePoints(int face){
    switch(face){
      case a: return getFaceAPoints();
      case b: return getFaceBPoints();
      case c: return getFaceCPoints();
      case d: return getFaceDPoints();
    }
    return null;
  }
  
  public int faceArrayToVertex(int[] face){
    int sum = 0;
    for(int i : face){
      sum += i; 
    }
    return 6 - sum;
  }
    
  public boolean getFaceConnected(int face){
    return connectedFace[face];
  }
  
  public boolean getEdgeConnected(Set<Integer> edge){
    return connectedEdge[edgeToEdgeIndex(edge)];  
  }
  
  public void setEdgeConnected(Set<Integer> edge, boolean connected){
    connectedEdge[edgeToEdgeIndex(edge)] = connected; 
  }
  
  public boolean getVertexConnected(int vertex){
    return connectedVertex[vertex]; 
  }
  
  public void setVertexConnected(int vertex, boolean connected){
    connectedVertex[vertex] = connected;
  }
  
  public int[] getVertices(){
    return new int[]{a,b,c,d};  
  }
  public Set<Integer> verticesToEdge(int a, int b){
    Set<Integer> edge = new HashSet<Integer>();
    edge.add(a);
    edge.add(b);
    return edge;
  }
  // ab, bc, ca, ad, bd, cd
  public int edgeToEdgeIndex(Set<Integer> edge){
    if(edge.contains(a) && edge.contains(b)){
      return 0;
    }else if(edge.contains(b) && edge.contains(c)){
      return 1;
    }else if(edge.contains(c) && edge.contains(a)){
      return 2;
    }else if(edge.contains(a) && edge.contains(d)){
      return 3;
    }else if(edge.contains(b) && edge.contains(d)){
      return 4;
    }else if(edge.contains(c) && edge.contains(d)){
      return 5;
    }
    return -1;
  }
  
  /*
  *    Defined such that ab will return cd in a triangle defined by clockwise abc
  *                      ba -> dc
  *                      cb -> da
  *                      bc -> ad
  *                      db -> ac
  *                      bd -> ac
  */ 
  //NOT NECESSARY
  //public int[] getOppositesInOrder(Set<Integer> face){}
  
  private float sign(float x){
    if(x > 0) return 1;
    if(x < 0) return -1;
    return 0;
  }
  
  /*
  *  For cloning
  */ 
  public Tetra(PVector[] points, String[] notes, boolean[] showNote, boolean[] connectedFace, boolean[] connectedEdge, boolean[] connectedVertex, color tetraColor, int pulseTime, int pulse, color pulseColor, boolean visible, boolean root, boolean initial, int nextNoteInSequence){
    this.points = points;
    this.notes = notes;
    this.showNote = showNote;
    this.connectedFace = connectedFace;
    this.connectedEdge = connectedEdge;
    this.connectedVertex = connectedVertex;
    this.tetraColor = tetraColor;
    this.pulseTime = pulseTime;
    this.pulse = pulse;
    this.pulseColor = pulseColor;
    this.visible = visible;
    this.root = root;
    this.initial = initial;
    this.nextNoteInSequence = nextNoteInSequence;
    centroid = getCentroid();
    makeShape();
    setColor(tetraColor);
  }
  public Tetra getCopy(){
    PVector[] pointsCopy = new PVector[4]; 
    String[] notesCopy = new String[4];

    for(int i = 0; i < 4; i++){
      pointsCopy[i] = this.points[i].copy();
      notesCopy[i] = this.notes[i];
    }
    
    color tetraColorCopy = color(red(this.tetraColor), green(this.tetraColor), blue(this.tetraColor), alpha(this.tetraColor));
    color pulseColorCopy = color(red(this.pulseColor), green(this.pulseColor), blue(this.pulseColor), alpha(this.pulseColor));

    Tetra copy = new Tetra(pointsCopy, notesCopy, showNote.clone(), connectedFace.clone(), connectedEdge.clone(), connectedVertex.clone(), tetraColorCopy, this.pulseTime, this.pulse, pulseColorCopy, this.visible, this.root, this.initial, this.nextNoteInSequence);
    return copy;
  }
}
public class NoteText{
  String note;
  float size;
  float x;
  float y;
  
  public NoteText(String note, float size, float x, float y){
    this.note = note;
    this.size = size;
    this.x = x;
    this.y = y;
  }
}


public class TetraElement{
  private final Tetra tetra;
  public TetraElement(Tetra tetra){
    this.tetra = tetra;  
  }
  public Tetra getTetra() {
      return tetra;
  }
  
  public boolean alreadyConnected(){
    switch(element){
      case FACE: return tetra.getFaceConnected(((TetraFace)this).getFace());
      case EDGE: return tetra.getEdgeConnected(((TetraEdge)this).getEdge());
      case VERTEX: return tetra.getVertexConnected(((TetraVertex)this).getVertex());
    }
    return false;
  }
}
  
public class TetraVertex extends TetraElement{
  private final int vertex;
  
  public TetraVertex(Tetra tetra, int vertex){
    super(tetra);
    this.vertex = vertex;
  }
  
  public int getVertex() {
      return vertex;
  }
  
  public boolean alreadyConnected(){
    return getTetra().getVertexConnected(vertex);
  }
}
  
public class TetraEdge extends TetraElement{
  private final Set<Integer> edge;
  
  public TetraEdge(Tetra tetra, int vertexA, int vertexB){
    super(tetra);
    this.edge = new HashSet<Integer>();
    this.edge.add((Integer) vertexA);
    this.edge.add((Integer) vertexB);
  }
  
  public TetraEdge(Tetra tetra, Set<Integer> edge){
    super(tetra);
    this.edge = edge;
  }

  public Set<Integer> getEdge() {
      return edge;
  }
  public boolean alreadyConnected(){
    return getTetra().getEdgeConnected(edge);
  }
}
  
public class TetraFace extends TetraElement{
  private final int face;

  public TetraFace(Tetra tetra, int face) {
      super(tetra);
      this.face = face;
  }

  public int getFace() {
      return face;
  }
  public boolean alreadyConnected(){
    return getTetra().getFaceConnected(face);
  }
}
