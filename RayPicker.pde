import java.util.*;

class RayPicker{
  public static final float step = 5f;
  PeasyCam cam;
  
  public RayPicker(PeasyCam cam){
    this.cam = cam;
  }
  
  public TetraElement pick(float x, float y,  ArrayList<Tetra> tetras, Options.Element element){
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
    
    TetraIntersect tetraIntersect = tetraIntersect(ray, camPosition, tetras);  
    if(tetraIntersect != null){
      switch(element){
        case FACE: return pickFace(tetraIntersect);
        case EDGE: return pickEdge(tetraIntersect);
        case VERTEX: return pickVertex(tetraIntersect);
      }
    }
    return null; 
    
  }
  
  // P=O+tR
  // Ax+By+Cz+D=0
  public TetraIntersect tetraIntersect(PVector ray, PVector camPos, ArrayList<Tetra> tetras){
    PVector closestP = PVector.add(camPos, PVector.mult(ray, farClip));
    TetraFace closestTetraFace = null;

    for(Tetra tetra: tetras){
      for(int i = 0; i < 4; i++){       
        int[] face = tetra.getFace(i);
        PVector N = tetra.getNormal(face);       
        
        if(PVector.dot(N, ray) == 0){
          continue;
        }
        float t = PVector.dot(N, PVector.sub(tetra.points[face[0]],camPos)) / PVector.dot(N, ray);
        if(t<0){
           continue; 
        }
        PVector P = PVector.add(camPos,PVector.mult(ray,t));
        boolean intersects = triangleIntersects(tetra.getFacePoints(i), N, P);
        
        if(intersects && PVector.dist(camPos, P) < PVector.dist(camPos, closestP)){
          closestP = P;
          closestTetraFace = new TetraFace(tetra, i);
        }
      }
    }
    if(closestTetraFace != null){
      return new TetraIntersect(closestTetraFace, closestP);
    }
    return null;
  }
  
  public boolean triangleIntersects(PVector[] points, PVector N, PVector P){
    // Is P inface or outface
    PVector edge0 = PVector.sub(points[1], points[0]);
    PVector edge1 = PVector.sub(points[2], points[1]);
    PVector edge2 = PVector.sub(points[0], points[2]);
    PVector C0 = PVector.sub(P, points[0]);
    PVector C1 = PVector.sub(P, points[1]);
    PVector C2 = PVector.sub(P, points[2]);
    
    if (PVector.dot(N, edge0.cross(C0)) < 0 && PVector.dot(N, edge1.cross(C1)) < 0 && PVector.dot(N, edge2.cross(C2)) < 0) {
          return true; // P is inface the triangle 
    }
    return false;
  }
  
  private TetraVertex pickVertex(TetraIntersect tetraIntersect){
    Tetra tetra = tetraIntersect.getTetra();
    int[] face = tetra.getFace(tetraIntersect.getFace());
    PVector[] points = tetra.getFacePoints(tetraIntersect.getFace());
    int smallestVertex = 0;
    float smallestDistance = MAX_FLOAT;
    for(int i = 0; i < 3; i++){
      float dist = PVector.dist(tetraIntersect.getIntersectionPoint(),points[i]);
      if(dist < smallestDistance){
        smallestVertex = face[i];
        smallestDistance = dist;
      }
    }
    return new TetraVertex(tetraIntersect.getTetra(), smallestVertex);
  }
 
  // Since we are only working with equilateral triangles, we can find the smallest distance to two of the vertices
  private TetraEdge pickEdge(TetraIntersect tetraIntersect){
    Set<Integer> edge = new HashSet<Integer>();
    
    Tetra tetra = tetraIntersect.getTetra();
    int[] face = tetra.getFace(tetraIntersect.getFace());
    PVector[] points = tetra.getFacePoints(tetraIntersect.getFace());
    
    int biggestFaceIndex = 0;
    float biggestDistance = 0;
    for(int i = 0; i < 3; i++){
      float dist = PVector.dist(tetraIntersect.getIntersectionPoint(),points[i]);
      if(dist > biggestDistance){
        biggestFaceIndex = i;
        biggestDistance = dist;
      }
    }
    for(int i = 0; i < 3; i++){
      if(i!=biggestFaceIndex){
        edge.add(face[i]);  
      }
    }
    return new TetraEdge(tetraIntersect.getTetra(), edge);
  }
  
  private TetraFace pickFace(TetraIntersect tetraIntersect){    
    return tetraIntersect;
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
  
  class TetraIntersect extends TetraFace{
    private final PVector intersectionPoint;
    
    public TetraIntersect(Tetra tetra, int face, PVector intersectionPoint){
      super(tetra,face);
      this.intersectionPoint = intersectionPoint;
    }
    
    public TetraIntersect(TetraFace tetraFace, PVector intersectionPoint){
      super(tetraFace.getTetra(),tetraFace.getFace());
      this.intersectionPoint = intersectionPoint;
    }
    
    public PVector getIntersectionPoint(){
      return intersectionPoint;  
    }
  }
  
  

}
