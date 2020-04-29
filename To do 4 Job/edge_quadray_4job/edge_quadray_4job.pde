import peasy.*;
PeasyCam cam;
PShape thd;
float s = 60;
float t = 2*sqrt(6)/3;
int alpha = 150;
int dikte = 5;

PVector a = new PVector(s, s, s);
PVector b = new PVector(-s, -s, s);
PVector c = new PVector(-s, s, -s);
PVector d = new PVector(s, -s, -s);

PVector e = new PVector(-t*s,  t*s, t*s);
PVector f = new PVector(t*s,  -t*s, t*s);
PVector g = new PVector(-t*s,  -t*s, -t*s);
PVector h = new PVector(t*s,  t*s, -t*s);

PVector i = new PVector(-2*t*s,  0, 0); 
PVector j = new PVector(0, 0, 2*t*s); 
PVector k = new PVector(0, 2*t*s, 0); 
PVector l = new PVector(2*t*s,  0, 0); 
PVector m = new PVector(0, -2*t*s, 0); 
PVector n = new PVector(0, 0, -2*t*s); 

PVector[] t14 = {a,b,c,d,e,f,g,h,i,j,k,l,m,n};

void setup(){
  size(1080, 720, P3D);   
  make_thd(t14);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(2000);
  ortho();
} 

void make_thd(PVector[] t) {
  thd = createShape();
  thd.beginShape(TRIANGLES);
  
  thd.stroke(200,200,200);
  thd.strokeWeight(3);
  
thd.fill(255,255,255,alpha);        // base 0,1,2,3
thd.vertex(t[0].x,t[0].y,t[0].z);
thd.vertex(t[1].x,t[1].y,t[1].z);
thd.vertex(t[2].x,t[2].y,t[2].z);
  
thd.vertex(t[0].x,t[0].y,t[0].z);
thd.vertex(t[1].x,t[1].y,t[1].z);
thd.vertex(t[3].x,t[3].y,t[3].z);

thd.vertex(t[2].x,t[2].y,t[2].z);
thd.vertex(t[1].x,t[1].y,t[1].z);
thd.vertex(t[3].x,t[3].y,t[3].z);

thd.vertex(t[0].x,t[0].y,t[0].z);
thd.vertex(t[3].x,t[3].y,t[3].z);
thd.vertex(t[2].x,t[2].y,t[2].z);
  
  /*
  thd.fill(0,0,0,alpha);            // base 0,1,2,4
  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[2].x,t[2].y,t[2].z);
  
  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[4].x,t[4].y,t[4].z);

  thd.vertex(t[2].x,t[2].y,t[2].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[4].x,t[4].y,t[4].z);

  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[4].x,t[4].y,t[4].z);
  thd.vertex(t[2].x,t[2].y,t[2].z);
        
        thd.fill(125,125,0,alpha);            // base 0,1,4,9
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
  
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[9].x,t[9].y,t[9].z);

        thd.vertex(t[4].x,t[4].y,t[4].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[9].x,t[9].y,t[9].z);

        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[9].x,t[9].y,t[9].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
        
        thd.fill(0,125,125,alpha);            // base 2,1,4,8
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
  
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[8].x,t[8].y,t[8].z);

        thd.vertex(t[4].x,t[4].y,t[4].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[8].x,t[8].y,t[8].z);

        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[8].x,t[8].y,t[8].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
  */      
        thd.fill(60,180,0,alpha);            // base 0,4,2,10
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
        thd.vertex(t[2].x,t[2].y,t[2].z);
  
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
        thd.vertex(t[10].x,t[10].y,t[10].z);

        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[4].x,t[4].y,t[4].z);
        thd.vertex(t[10].x,t[10].y,t[10].z);

        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[10].x,t[10].y,t[10].z);
        thd.vertex(t[2].x,t[2].y,t[2].z);
  /*
  thd.fill(255,0,0,alpha);            // base 0,1,3,5
  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  
  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[5].x,t[5].y,t[5].z);

  thd.vertex(t[3].x,t[3].y,t[3].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[5].x,t[5].y,t[5].z);

  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[5].x,t[5].y,t[5].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  
        thd.fill(180,60,0,alpha);            // 0,5,3,11
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
  
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
        thd.vertex(t[11].x,t[11].y,t[11].z);

        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
        thd.vertex(t[11].x,t[11].y,t[11].z);

        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[11].x,t[11].y,t[11].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
  
        thd.fill(125,0,125,alpha);            // 3,1,5,12
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
  
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[12].x,t[12].y,t[12].z);

        thd.vertex(t[5].x,t[5].y,t[5].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[12].x,t[12].y,t[12].z);

        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[12].x,t[12].y,t[12].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
  
        thd.fill(125,125,0,alpha);            // 0,1,5,9
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
  
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[9].x,t[9].y,t[9].z);

        thd.vertex(t[5].x,t[5].y,t[5].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[9].x,t[9].y,t[9].z);

        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[9].x,t[9].y,t[9].z);
        thd.vertex(t[5].x,t[5].y,t[5].z);
  
  thd.fill(0,0,255,alpha);            // base 2,1,3,6
  thd.vertex(t[2].x,t[2].y,t[2].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  
  thd.vertex(t[2].x,t[2].y,t[2].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[6].x,t[6].y,t[6].z);

  thd.vertex(t[3].x,t[3].y,t[3].z);
  thd.vertex(t[1].x,t[1].y,t[1].z);
  thd.vertex(t[6].x,t[6].y,t[6].z);

  thd.vertex(t[2].x,t[2].y,t[2].z);
  thd.vertex(t[6].x,t[6].y,t[6].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  
        thd.fill(0,125,125,alpha);            // 2,1,6,8
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);
  
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[8].x,t[8].y,t[8].z);

        thd.vertex(t[6].x,t[6].y,t[6].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[8].x,t[8].y,t[8].z);

        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[8].x,t[8].y,t[8].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);
        
        thd.fill(60,60,120,alpha);            // 2,6,3,13
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
  
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);
        thd.vertex(t[13].x,t[13].y,t[13].z);

        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);
        thd.vertex(t[13].x,t[13].y,t[13].z);

        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[13].x,t[13].y,t[13].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);

        thd.fill(125,0,125,alpha);            // 3,1,6,12
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);
 
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[12].x,t[12].y,t[12].z);

        thd.vertex(t[6].x,t[6].y,t[6].z);
        thd.vertex(t[1].x,t[1].y,t[1].z);
        thd.vertex(t[12].x,t[12].y,t[12].z);

        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[12].x,t[12].y,t[12].z);
        thd.vertex(t[6].x,t[6].y,t[6].z);

  thd.fill(125,125,0,alpha);          // base 0,3,2,7
  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  thd.vertex(t[2].x,t[2].y,t[2].z);
  
  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  thd.vertex(t[7].x,t[7].y,t[7].z);

  thd.vertex(t[2].x,t[2].y,t[2].z);
  thd.vertex(t[3].x,t[3].y,t[3].z);
  thd.vertex(t[7].x,t[7].y,t[7].z);

  thd.vertex(t[0].x,t[0].y,t[0].z);
  thd.vertex(t[7].x,t[7].y,t[7].z);
  thd.vertex(t[2].x,t[2].y,t[2].z);
  
        thd.fill(60,60,120,alpha);            // 2,3,7,13
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[7].x,t[7].y,t[7].z);
  
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[13].x,t[13].y,t[13].z);

        thd.vertex(t[7].x,t[7].y,t[7].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[13].x,t[13].y,t[13].z);

        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[13].x,t[13].y,t[13].z);
        thd.vertex(t[7].x,t[7].y,t[7].z);
        
        
        thd.fill(180,60,0,alpha);            // 0,3,7,11
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[7].x,t[7].y,t[7].z);
  
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[11].x,t[11].y,t[11].z);

        thd.vertex(t[7].x,t[7].y,t[7].z);
        thd.vertex(t[3].x,t[3].y,t[3].z);
        thd.vertex(t[11].x,t[11].y,t[11].z);

        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[11].x,t[11].y,t[11].z);
        thd.vertex(t[7].x,t[7].y,t[7].z);
    */    
        thd.fill(60,180,0,alpha);            // 0,2,7,10
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[7].x,t[7].y,t[7].z);
  
        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[10].x,t[10].y,t[10].z);

        thd.vertex(t[7].x,t[7].y,t[7].z);
        thd.vertex(t[2].x,t[2].y,t[2].z);
        thd.vertex(t[10].x,t[10].y,t[10].z);

        thd.vertex(t[0].x,t[0].y,t[0].z);
        thd.vertex(t[10].x,t[10].y,t[10].z);
        thd.vertex(t[7].x,t[7].y,t[7].z);
  
  thd.endShape();
}

void show_points() {
  textAlign(CENTER, CENTER);
  
  fill(200,0,0);
  textSize(45);
  push();
  translate(a.x*1.2,a.y*1.2,a.z*1.2);
  text("C",0,0);
  pop();
  push();
  translate(b.x*1.2,b.y*1.2,b.z*1.2);
  text("E",0,0);
  pop();
  push();
  translate(c.x*1.2,c.y*1.2,c.z*1.2);
  text("G",0,0);
  pop();
  push();
  translate(d.x*1.2,d.y*1.2,d.z*1.2);
  text("B",0,0);
  pop();
  
  fill(200,200,200);
  push();
  translate(e.x*1.15,e.y*1.15,e.z*1.15);
  text("F#",0,0);
  pop();
  //push();
  //translate(f.x*1.15,f.y*1.15,f.z*1.15);
  //text("F# (15)",0,0);
  //pop();
  //push();
  //translate(g.x*1.15,g.y*1.15,g.z*1.15);
  //text("F#",0,0);
  //pop();
  push();
  translate(h.x*1.15,h.y*1.15,h.z*1.15);
  text("F#",0,0);
  pop();
  
  //push();
  //translate(i.x*1.1,i.y*1.1,i.z*1.1);
  //text("D",0,0);
  //pop();
  //push();
  //translate(j.x*1.1,j.y*1.1,j.z*1.1);
  //text("D",0,0);
  //pop();
  push();
  translate(k.x*1.1,k.y*1.1,k.z*1.1);
  text("D",0,0);
  pop();
  //push();
  //translate(l.x*1.1,l.y*1.1,l.z*1.1);
  //text("D",0,0);
  //pop();
  //push();
  //translate(m.x*1.1,m.y*1.1,m.z*1.1);
  //text("D",0,0);
  //pop();
  //push();
  //translate(n.x*1.1,n.y*1.1,n.z*1.1);
  //text("D",0,0);
  //pop();
  
}

void axes() {
  strokeWeight(dikte);  // Default
  
  stroke(200, 0, 0, 100);
  line(0, 0, 0, -4*s, -4*s, -4*s);
  stroke(255, 50, 50, 100);
  line(0, 0, 0,  4*s,  4*s,  4*s);
  stroke(0, 200, 0, 100);
  line(0, 0, 0, -4*s, -4*s,  4*s);
  stroke(50, 255, 50, 100);
  line(0, 0, 0,  4*s,  4*s, -4*s);
  stroke(0, 0, 200, 100);
  line(0, 0, 0, -4*s,  4*s, -4*s);
  stroke(50, 50, 255, 100);
  line(0, 0, 0,  4*s, -4*s,  4*s);
  stroke(255, 100);
  line(0, 0, 0,  4*s, -4*s, -4*s);
  stroke(150, 100);
  line(0, 0, 0, -4*s,  4*s,  4*s);
}

void draw(){
 background(0);
  shape(thd, 0, 0);
  hint(DISABLE_DEPTH_TEST);
  show_points();  
  hint(ENABLE_DEPTH_TEST);
  //axes();
}
