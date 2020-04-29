class RayPicker{
  public static final float step = 5f;
  public static final boolean march = false;
  PeasyCam cam;
  
  public RayPicker(PeasyCam cam){
    this.cam = cam;
  }
  
  public TetraSide pick(float x, float y, ArrayList<Tetra> tetras){ 
    // --- get camera target position
    float a[] = cam.getLookAt().clone();
    PVector camTarget = new PVector(a[0], a[1], a[2]);
    
    // --- get camera position
    float b[] = cam.getPosition().clone();
    PVector camPosition = new PVector(b[0], b[1], b[2]);
   
    // --- get view
    PVector view = PVector.sub(camTarget, camPosition).normalize();
    
    // -- get cameraUp and cameraRight vector
    PVector camUp = picker.upVector();
    PVector camRight = camUp.cross(view).normalize();
    
    float vLength = tan(fov)*nearClip;
    float hLength = vLength*aspect;
    camUp.mult(vLength);
    camRight.mult(hLength);
    
    x -= width/2;
    y -= height/2;  
    x /= (width/2);
    y /= (height/2);
   
    PVector xVector = camRight.mult((float)cam.getDistance()/distance * 100* x);
    PVector yVector = camUp.mult((float)cam.getDistance()/distance * 100 *-y);
    PVector mouseVector = PVector.add(PVector.add(xVector,yVector), camTarget); 
    
    PVector ray = PVector.sub(mouseVector,camPosition).normalize();
    
    if(march){
      return new TetraSide(march(ray, camPosition, tetras), -1);
    }else{
      TetraSide tetraSide = tetraIntersect(ray, camPosition, tetras);
      if(tetraSide != null){
        return tetraSide;
      }
      
    }
    return null; 
  }
  
  // P=O+tR
  // Ax+By+Cz+D=0
  public TetraSide tetraIntersect(PVector ray, PVector camPos, ArrayList<Tetra> tetras){
    PVector closestP = PVector.add(camPos, PVector.mult(ray, farClip));
    TetraSide closestTetraSide = null;

    for(Tetra tetra: tetras){
      for(int i = 0; i < 4; i++){       
        int[] side = tetra.getSide(i);
        PVector N = tetra.getNormal(side);       
        
        if(PVector.dot(N, ray) == 0){
          continue;
        }
        float t = PVector.dot(N, PVector.sub(tetra.points[side[0]],camPos)) / PVector.dot(N, ray);
        if(t<0){
           continue; 
        }
        PVector P = PVector.add(camPos,PVector.mult(ray,t));
        boolean intersects = triangleIntersects(tetra.getSidePoints(i), N, P);
        
        if(intersects && PVector.dist(camPos, P) < PVector.dist(camPos, closestP)){
          closestP = P;
          closestTetraSide = new TetraSide(tetra, i);
        }
      }
    }
    return closestTetraSide;
  }
  
  public boolean triangleIntersects(PVector[] points, PVector N, PVector P){
    // Is P inside or outside
    PVector edge0 = PVector.sub(points[1], points[0]);
    PVector edge1 = PVector.sub(points[2], points[1]);
    PVector edge2 = PVector.sub(points[0], points[2]);
    PVector C0 = PVector.sub(P, points[0]);
    PVector C1 = PVector.sub(P, points[1]);
    PVector C2 = PVector.sub(P, points[2]);
    
    if (PVector.dot(N, edge0.cross(C0)) < 0 && PVector.dot(N, edge1.cross(C1)) < 0 && PVector.dot(N, edge2.cross(C2)) < 0) {
          return true; // P is inside the triangle 
    }
    return false;
  }
  
  
  
  public Tetra march(PVector ray, PVector camPosition, ArrayList<Tetra> tetras){
    for(float i = 0; i < farClip; i+= step){
      PVector worldPoint = PVector.add(PVector.mult(ray, i),camPosition);
      for(Tetra t: tetras){
        if(t.isInside(worldPoint)){
          return t;
        }
      }
    }
    return null;
  }
  
  
  public PVector upVector(){
      PVector up = new PVector(0,-1,0);
      float[] rot = cam.getRotations();

      PVector upZ = (new PVector(up.x,up.y)).rotate(rot[2]);
      up = new PVector(upZ.x,upZ.y,up.z);

      PVector upY = (new PVector(up.x,up.z)).rotate(-rot[1]);
      up = new PVector(upY.x,up.y,upY.y);

      PVector upX = (new PVector(up.y,up.z)).rotate(rot[0]);
      up = new PVector(up.x,upX.x,upX.y);
      
      return up.normalize();
  }
  
  final class TetraSide {
    private final Tetra tetra;
    private final int side;

    public TetraSide(Tetra tetra, int side) {
        this.tetra = tetra;
        this.side = side;
    }

    public Tetra getTetra() {
        return tetra;
    }

    public int getSide() {
        return side;
    }
}
}
