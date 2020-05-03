/*
*  A tetra is an object containing 4 notes, it can be connected to other tetras sharing one side
*  
*    b 
*  /   \    d is behind
* a --- c
* 
* define sides in clockwise direction and call by missing vertex
* 
* cbd = side A 
* dac = side B
* bad = side C
* cab = side D
*
* Always connects at side D
*/
class Tetra{
  private static final float size = 60; // Size of any of the tetrahedrons edges
  public PVector centroid;
  
  // Drawing
  private static final float strokeWeight = 3;
  private static final float textSize = 15;
  private static final float textOffset = 15;
  private final color strokeColor = color(200,200,200);
  private color tetraColor = color(127);
  private static final float colorAlpha = 127;
  
  // Used as a timer for pulse effects (when playing a tetra chord)
  private int pulseTime = 0;
  private int pulse = 0;
  private color pulseColor = color(255,255,255,0);
  
  // Midi parameters
  private int midiDuration = 1000; // milliseconds
  private int midiVelocity = 90; // 0-127
  private int midiStrumDelay = 70;
  private int midiMinOctave = 4;
  private int midiMaxOctave = 6;

  // Tetrahedron constants
  private final float invsqrt2 = 1/sqrt(2);
  private final float tetraWidth = 2*sqrt(6)/3f;
  
  // Hardcoded number names for convenient and readable array indexing
  static final int a = 0; static final int b = 1; static final int c = 2; static final int d = 3;
  public boolean[] connected = {false,false,false,false}; 
  
  public String[] notes = new String[4];
  public PVector[] points = new PVector[4];
  
  private PShape tetraShape;

  private boolean visible = true;
  private boolean root = false;  
  private boolean initial = false;

  public Tetra(String aNote, String bNote, String cNote, String dNote) {
    root = true;
    initial = true;
    notes[a] = aNote;
    notes[b] = bNote;
    notes[c] = cNote;
    notes[d] = dNote;
    points[a] = new PVector(1, 0, -invsqrt2).mult(size);
    points[b] = new PVector(-1, 0, -invsqrt2).mult(size);
    points[c] = new PVector(0, -1, invsqrt2).mult(size);
    points[d] = new PVector(0, 1, invsqrt2).mult(size);
    makeShape();
    centroid = getCentroid();
  }
  
  public Tetra(Tetra root, int[] side, String addNote) {
    if(root.connected[sideArrayToVertex(side)]){
      new Exception("Side is already connected").printStackTrace();
    }
    notes[a] = root.notes[side[c]];
    notes[b] = root.notes[side[b]];
    notes[c] = root.notes[side[a]];
    notes[d] = addNote;
    connectToSide(root, side);

    centroid = getCentroid();
  }
  
  private void connectToSide(Tetra root, int[] side){
    points[a] = root.points[side[c]];
    points[b] = root.points[side[b]];
    points[c] = root.points[side[a]];
  
    PVector faceMiddle = getFaceMiddle(d);
    PVector invNormal = PVector.mult(getNormal(getSideD()), -1);
    points[d] = PVector.add(faceMiddle, invNormal.normalize().mult(tetraWidth*size));
    makeShape();
    
    connected[d] = true;
    root.connected[sideArrayToVertex(side)] = true;
    
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
      if(!root && i!=d) continue;
      PVector oD = PVector.sub(points[i], centroid).normalize(); // Offset Direction
      x[i] = screenX(points[i].x+oD.x*textOffset, points[i].y+oD.y*textOffset, points[i].z+oD.z*textOffset);
      y[i] = screenY(points[i].x+oD.x*textOffset, points[i].y+oD.y*textOffset, points[i].z+oD.z*textOffset);
    }
    float[] camPosition = cam.getPosition();
    PVector camPosVec = new PVector(camPosition[0],camPosition[1],camPosition[2]);
    cam.beginHUD();
    for(int i = 0; i < notes.length; i++){
      if(Tonnetz3D.removeOnNewRoot){
        if(!root && i!=d) {continue;}
      }else{
        if(!initial && i!= d) {continue;}
      }
      float zoomedTextSize = textSize * farClip / PVector.dist(points[i], camPosVec);
      textSize(zoomedTextSize);
      text(notes[i], x[i], y[i]);
    }
    cam.endHUD();
  }

  public void play(Midi midi) {
    midi.strumChord(notes, midiVelocity, midiDuration, midiStrumDelay, midiMinOctave, midiMaxOctave);
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
    this.setColor(color(r,g,b)); 
  }
  
  public void setVisible(boolean visible){
    this.visible = visible; 
  }
  
  public void makeRoot(){
    root = true;
    if(Tonnetz3D.removeOnNewRoot){
      for(int i = 0; i < connected.length; i++){
        //connected[i] = false;
      }
    }

    setColor(color(127));
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
  * define sides in clockwise direction
  * 
  * cbd = side A 
  * dac = side B
  * bad = side C
  * cab = side D
  */
  public PVector[] getSideAPoints(){ return new PVector[]{points[c], points[b], points[d]}; }
  public PVector[] getSideBPoints(){ return new PVector[]{points[d], points[a], points[c]}; }
  public PVector[] getSideCPoints(){ return new PVector[]{points[b], points[a], points[d]}; }
  public PVector[] getSideDPoints(){ return new PVector[]{points[c], points[a], points[b]}; }
  public int[] getSideA(){ return new int[]{c,b,d}; }
  public int[] getSideB(){ return new int[]{d,a,c}; }
  public int[] getSideC(){ return new int[]{b,a,d}; }
  public int[] getSideD(){ return new int[]{c,a,b}; }
  public PVector getPointA() { return points[a]; }
  public PVector getPointB() { return points[b]; }
  public PVector getPointC() { return points[c]; }
  public PVector getPointD() { return points[d]; }
  
  public boolean isInside(PVector point){
    for(int s = 0; s < 4; s++){
      if(!isSameSide(vertexToSideArray(s), point)){ return false;}
    } 
    return true;
  }
  
  public boolean isSameSide(int[] side, PVector point){
     PVector invNormal = PVector.mult(getNormal(side),-1);
     float dotOpp = PVector.dot(invNormal, PVector.sub(points[sideArrayToVertex(side)], points[side[a]]));
     float dotPoint = PVector.dot(invNormal, PVector.sub(point, points[side[a]]));
     return sign(dotOpp) == sign(dotPoint);
  }
  
  public PVector getNormal(int[] side){
    return PVector.sub(points[side[b]],points[side[c]]).cross(PVector.sub(points[side[a]],points[side[c]])).normalize();
  }
  
  public PVector getCentroid(){
      return PVector.add(PVector.add(points[a],points[b]), PVector.add(points[c],points[d])).div(4);
  }
  public PVector getFaceMiddle(int side){
     return PVector.add(PVector.add(points[getSide(side)[a]],points[getSide(side)[b]]), points[getSide(side)[c]]).div(3); 
  }
  public int[] getSide(int side){ return vertexToSideArray(side); }
  public int[] vertexToSideArray(int side){
    switch(side){
      case a: return getSideA();
      case b: return getSideB();
      case c: return getSideC();
      case d: return getSideD();
    }
    return null;
  }
  
  public PVector[] getSidePoints(int side){
    switch(side){
      case a: return getSideAPoints();
      case b: return getSideBPoints();
      case c: return getSideCPoints();
      case d: return getSideDPoints();
    }
    return null;
  }
  
  public int sideArrayToVertex(int[] side){
    int sum = 0;
    for(int i : side){
      sum += i; 
    }
    return 6 - sum;
  }
  
  private float sign(float x){
    if(x > 0) return 1;
    if(x < 0) return -1;
    return 0;
  }
 
}
