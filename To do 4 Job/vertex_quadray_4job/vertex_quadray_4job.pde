import peasy.*;
PeasyCam cam;
PShape thd;
float s = 60;
float t = 2*sqrt(6)/3;
int alpha = 180;
int dikte = 5;

PVector a = new PVector(s, s, s); //op rode as
PVector b = new PVector(-s, -s, s); //op groene as
PVector c = new PVector(-s, s, -s); //op blauwe as
PVector d = new PVector(s, -s, -s); //op grijze as

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

PVector o = new PVector(s, 3*s, 3*s); 
PVector p = new PVector(3*s, 3*s, s); 
PVector q = new PVector(3*s, s, 3*s); 
PVector oo = new PVector(-3*s,-s,3*s); 
PVector pp = new PVector(-3*s,-3*s,s); 
PVector qq = new PVector(-s,-3*s,3*s); 
PVector ooo = new PVector(-3*s,3*s,-s); 
PVector ppp = new PVector(-3*s,s,-3*s); 
PVector qqq = new PVector(-s,3*s,-3*s); 
PVector oooo = new PVector(3*s,-3*s,-s); 
PVector pppp = new PVector(s,-3*s,-3*s); 
PVector qqqq = new PVector(3*s,-s,-3*s); 

PVector[] t26 = {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,oo,pp,qq,ooo,ppp,qqq,oooo,pppp,qqqq};

void setup(){
  size(1080, 720, P3D);   
  thd_all(t26);
  cam = new PeasyCam(this, 100);
  ortho();
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(2000);
} 

void thd_all(PVector [] t) {
  thd = createShape();
  thd.beginShape(TRIANGLES);
  
  thd.stroke(200,200,200);
  thd.strokeWeight(3);

// MIDDLE  
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
  
// RED
/*
    thd.fill(210,0,0,alpha);                // 1,17,18,19
    thd.vertex(t[1].x,t[1].y,t[1].z);
    thd.vertex(t[17].x,t[17].y,t[17].z);
    thd.vertex(t[18].x,t[18].y,t[18].z);
    
    thd.vertex(t[1].x,t[1].y,t[1].z);
    thd.vertex(t[17].x,t[17].y,t[17].z);
    thd.vertex(t[19].x,t[19].y,t[19].z);
    
    thd.vertex(t[18].x,t[18].y,t[18].z);
    thd.vertex(t[17].x,t[17].y,t[17].z);
    thd.vertex(t[19].x,t[19].y,t[19].z);
    
    thd.vertex(t[1].x,t[1].y,t[1].z);
    thd.vertex(t[19].x,t[19].y,t[19].z);
    thd.vertex(t[18].x,t[18].y,t[18].z);
    
            thd.fill(100,0,0,alpha);            // base 1,17,4,9
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[17].x,t[17].y,t[17].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
  
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[17].x,t[17].y,t[17].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[4].x,t[4].y,t[4].z);
            thd.vertex(t[17].x,t[17].y,t[17].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);
            thd.vertex(t[4].x,t[4].y,t[4].z); 
             
            thd.vertex(t[1].x,t[1].y,t[1].z);      // base 1,17,4,8 
            thd.vertex(t[17].x,t[17].y,t[17].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
  
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[17].x,t[17].y,t[17].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[4].x,t[4].y,t[4].z);
            thd.vertex(t[17].x,t[17].y,t[17].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
                     
            thd.vertex(t[1].x,t[1].y,t[1].z);    // 1,5,19,12 
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[19].x,t[19].y,t[19].z);
  
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[19].x,t[19].y,t[19].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);
            thd.vertex(t[19].x,t[19].y,t[19].z);
            
            thd.vertex(t[1].x,t[1].y,t[1].z);    // 1,5,19,9
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[19].x,t[19].y,t[19].z);
  
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[19].x,t[19].y,t[19].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);
            thd.vertex(t[19].x,t[19].y,t[19].z);
            
            thd.fill(125,0,0,alpha);            // 18,1,6,8
            thd.vertex(t[18].x,t[18].y,t[18].z);
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
  
            thd.vertex(t[18].x,t[18].y,t[18].z);
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[6].x,t[6].y,t[6].z);
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[18].x,t[18].y,t[18].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
            
            thd.fill(125,0,0,alpha);            // 18,1,6,12
            thd.vertex(t[18].x,t[18].y,t[18].z);
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
  
            thd.vertex(t[18].x,t[18].y,t[18].z);
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[6].x,t[6].y,t[6].z);
            thd.vertex(t[1].x,t[1].y,t[1].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[18].x,t[18].y,t[18].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
    */
// GREEN

    thd.fill(0,210,0,alpha);                //0,14,15,16
    thd.vertex(t[0].x,t[0].y,t[0].z);
    thd.vertex(t[14].x,t[14].y,t[14].z);
    thd.vertex(t[15].x,t[15].y,t[15].z);
    
    thd.vertex(t[0].x,t[0].y,t[0].z);
    thd.vertex(t[14].x,t[14].y,t[14].z);
    thd.vertex(t[16].x,t[16].y,t[16].z);
    
    thd.vertex(t[15].x,t[15].y,t[15].z);
    thd.vertex(t[14].x,t[14].y,t[14].z);
    thd.vertex(t[16].x,t[16].y,t[16].z);
    
    thd.vertex(t[0].x,t[0].y,t[0].z);
    thd.vertex(t[16].x,t[16].y,t[16].z);
    thd.vertex(t[15].x,t[15].y,t[15].z);
  
            thd.fill(0,100,0,alpha);            // base 0,14,4,9
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[14].x,t[14].y,t[14].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
  
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[14].x,t[14].y,t[14].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[4].x,t[4].y,t[4].z);
            thd.vertex(t[14].x,t[14].y,t[14].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
            
            thd.vertex(t[0].x,t[0].y,t[0].z);      //   base 0,14,4,10
            thd.vertex(t[14].x,t[14].y,t[14].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
  
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[14].x,t[14].y,t[14].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);

            thd.vertex(t[4].x,t[4].y,t[4].z);
            thd.vertex(t[14].x,t[14].y,t[14].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);

            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
            
            thd.vertex(t[0].x,t[0].y,t[0].z);     // 0,5,16,11
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[16].x,t[16].y,t[16].z);
  
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[16].x,t[16].y,t[16].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);
            thd.vertex(t[16].x,t[16].y,t[16].z);
            
            thd.vertex(t[0].x,t[0].y,t[0].z);    // 0,5,16,9 
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[16].x,t[16].y,t[16].z);
  
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[16].x,t[16].y,t[16].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);

            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[9].x,t[9].y,t[9].z);
            thd.vertex(t[16].x,t[16].y,t[16].z);
            
            thd.vertex(t[0].x,t[0].y,t[0].z);    // 0,15,7,10
            thd.vertex(t[15].x,t[15].y,t[15].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
  
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[15].x,t[15].y,t[15].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);

            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[15].x,t[15].y,t[15].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);

            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
            
            thd.vertex(t[0].x,t[0].y,t[0].z);    // 0,15,7,11
            thd.vertex(t[15].x,t[15].y,t[15].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
  
            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[15].x,t[15].y,t[15].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[15].x,t[15].y,t[15].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[0].x,t[0].y,t[0].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
  
// BLUE
    /*
    thd.fill(0,0,210,alpha);                //2,20,21,22
    thd.vertex(t[2].x,t[2].y,t[2].z);
    thd.vertex(t[20].x,t[20].y,t[20].z);
    thd.vertex(t[21].x,t[21].y,t[21].z);
    
    thd.vertex(t[2].x,t[2].y,t[2].z);
    thd.vertex(t[20].x,t[20].y,t[20].z);
    thd.vertex(t[22].x,t[22].y,t[22].z);
    
    thd.vertex(t[21].x,t[21].y,t[21].z);
    thd.vertex(t[20].x,t[20].y,t[20].z);
    thd.vertex(t[22].x,t[22].y,t[22].z);
    
    thd.vertex(t[2].x,t[2].y,t[2].z);
    thd.vertex(t[22].x,t[22].y,t[22].z);
    thd.vertex(t[21].x,t[21].y,t[21].z);
  
            thd.fill(0,0,100,alpha);            // base 2,20,4,8
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[20].x,t[20].y,t[20].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
  
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[20].x,t[20].y,t[20].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[4].x,t[4].y,t[4].z);
            thd.vertex(t[20].x,t[20].y,t[20].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);  
            
            thd.vertex(t[2].x,t[2].y,t[2].z);    // base 2,20,4,10
            thd.vertex(t[20].x,t[20].y,t[20].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
  
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[20].x,t[20].y,t[20].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);

            thd.vertex(t[4].x,t[4].y,t[4].z);
            thd.vertex(t[20].x,t[20].y,t[20].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);

            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);
            thd.vertex(t[4].x,t[4].y,t[4].z);
            
            thd.vertex(t[21].x,t[21].y,t[21].z);    // 21,2,6,8
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
  
            thd.vertex(t[21].x,t[21].y,t[21].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[6].x,t[6].y,t[6].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);

            thd.vertex(t[21].x,t[21].y,t[21].z);
            thd.vertex(t[8].x,t[8].y,t[8].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
            
            thd.vertex(t[21].x,t[21].y,t[21].z);    // 21,2,6,13 
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
  
            thd.vertex(t[21].x,t[21].y,t[21].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);

            thd.vertex(t[6].x,t[6].y,t[6].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);

            thd.vertex(t[21].x,t[21].y,t[21].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
                
            thd.vertex(t[22].x,t[22].y,t[22].z);    // 22,7, 13, 2
            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);
  
            thd.vertex(t[22].x,t[22].y,t[22].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);

            thd.vertex(t[13].x,t[13].y,t[13].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);

            thd.vertex(t[22].x,t[22].y,t[22].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);
              
            thd.vertex(t[22].x,t[22].y,t[22].z);    // 22,7, 10, 2
            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);
  
            thd.vertex(t[22].x,t[22].y,t[22].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);

            thd.vertex(t[10].x,t[10].y,t[10].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);

            thd.vertex(t[22].x,t[22].y,t[22].z);
            thd.vertex(t[2].x,t[2].y,t[2].z);
            thd.vertex(t[10].x,t[10].y,t[10].z);
  
// YELLOW

    thd.fill(210,210,0,alpha);                //3,23,24,25
    thd.vertex(t[3].x,t[3].y,t[3].z);
    thd.vertex(t[23].x,t[23].y,t[23].z);
    thd.vertex(t[24].x,t[24].y,t[24].z);
    
    thd.vertex(t[3].x,t[3].y,t[3].z);
    thd.vertex(t[23].x,t[23].y,t[23].z);
    thd.vertex(t[25].x,t[25].y,t[25].z);
    
    thd.vertex(t[24].x,t[24].y,t[24].z);
    thd.vertex(t[23].x,t[23].y,t[23].z);
    thd.vertex(t[25].x,t[25].y,t[25].z);
    
    thd.vertex(t[3].x,t[3].y,t[3].z);
    thd.vertex(t[25].x,t[25].y,t[25].z);
    thd.vertex(t[24].x,t[24].y,t[24].z);
  
            thd.fill(100,100,0,alpha);            // 3,5,23,11 
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[23].x,t[23].y,t[23].z);
  
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[23].x,t[23].y,t[23].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);
            thd.vertex(t[23].x,t[23].y,t[23].z); 
            
            thd.vertex(t[3].x,t[3].y,t[3].z);    // 3,5,23,12
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[23].x,t[23].y,t[23].z);
  
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[23].x,t[23].y,t[23].z);
            thd.vertex(t[5].x,t[5].y,t[5].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);
            thd.vertex(t[23].x,t[23].y,t[23].z);
            
            thd.vertex(t[24].x,t[24].y,t[24].z);    // 24,3,6,13
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
  
            thd.vertex(t[24].x,t[24].y,t[24].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);

            thd.vertex(t[6].x,t[6].y,t[6].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);

            thd.vertex(t[24].x,t[24].y,t[24].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
            
            thd.vertex(t[24].x,t[24].y,t[24].z);    // 24,3,6,12
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
  
            thd.vertex(t[24].x,t[24].y,t[24].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[6].x,t[6].y,t[6].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);

            thd.vertex(t[24].x,t[24].y,t[24].z);
            thd.vertex(t[12].x,t[12].y,t[12].z);
            thd.vertex(t[6].x,t[6].y,t[6].z);
            
            thd.vertex(t[25].x,t[25].y,t[25].z);    // 25,3,7,11
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
  
            thd.vertex(t[25].x,t[25].y,t[25].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);

            thd.vertex(t[25].x,t[25].y,t[25].z);
            thd.vertex(t[11].x,t[11].y,t[11].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
            
            thd.vertex(t[25].x,t[25].y,t[25].z);    // 25,3,7,13
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
  
            thd.vertex(t[25].x,t[25].y,t[25].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);

            thd.vertex(t[7].x,t[7].y,t[7].z);
            thd.vertex(t[3].x,t[3].y,t[3].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);

            thd.vertex(t[25].x,t[25].y,t[25].z);
            thd.vertex(t[13].x,t[13].y,t[13].z);
            thd.vertex(t[7].x,t[7].y,t[7].z);
 */
  thd.endShape();
}

void show_points_cegb() {
  textAlign(CENTER, CENTER);
  
  fill(255,0,0);
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
}

void show_points_d() {    // 14-25
  textAlign(CENTER, CENTER);
  fill(200,200,200);
  
  push();
  translate(p.x*1.1,p.y*1.1,p.z*1.1);
  text("D 15",0,0);
  pop();
  push();
  translate(pp.x*1.1,pp.y*1.1,pp.z*1.1);
  text("D 18",0,0);
  pop();
  push();
  translate(ppp.x*1.1,ppp.y*1.1,ppp.z*1.1);
  text("D 21",0,0);
  pop();
  push();
  translate(pppp.x*1.1,pppp.y*1.1,pppp.z*1.1);
  text("D 24",0,0);
  pop();
}

void show_points_fis() {
  textAlign(CENTER, CENTER);
  fill(200,200,200);
  
  push();
  translate(q.x*1.1,q.y*1.1,q.z*1.1);
  text("F# 16",0,0);
  pop();  
  push();
  translate(qq.x*1.1,qq.y*1.1,qq.z*1.1);
  text("F# 19",0,0);
  pop();
  push();
  translate(qqq.x*1.1,qqq.y*1.1,qqq.z*1.1);
  text("F# 22",0,0);
  pop();
  push();
  translate(qqqq.x*1.1,qqqq.y*1.1,qqqq.z*1.1);
  text("F# 25",0,0);
  pop();
}

void show_points_a() {
  textAlign(CENTER, CENTER);
  fill(200,200,200);  
  
  push();
  translate(o.x*1.1,o.y*1.1,o.z*1.1);
  text("A 14",0,0);
  pop();
  push();
  translate(oo.x*1.1,oo.y*1.1,oo.z*1.1);
  text("A 17",0,0);
  pop();
  push();
  translate(ooo.x*1.1,ooo.y*1.1,ooo.z*1.1);
  text("A 20",0,0);
  pop();
  push();
  translate(oooo.x*1.1,oooo.y*1.1,oooo.z*1.1);
  text("A 23",0,0);
  pop();
}

void show_points_cis() {
  textAlign(CENTER, CENTER);
  fill(200,200,200);
  
  push();
  translate(e.x*1.15,e.y*1.15,e.z*1.15);
  text("C# 4",0,0);
  pop();
  push();
  translate(f.x*1.15,f.y*1.15,f.z*1.15);
  text("C# 5",0,0);
  pop();
  push();
  translate(g.x*1.15,g.y*1.15,g.z*1.15);
  text("C# 6",0,0);
  pop();
  push();
  translate(h.x*1.15,h.y*1.15,h.z*1.15);
  text("C# 7",0,0);
  pop();  
}

void show_points_e2() {
  textAlign(CENTER, CENTER);
  fill(200,200,200); 
  
  push();
  translate(i.x*1.1,i.y*1.1,i.z*1.1);
  text("E* 8",0,0);
  pop();
  push();
  translate(j.x*1.1,j.y*1.1,j.z*1.1);
  text("E* 9",0,0);
  pop();
  push();
  translate(k.x*1.1,k.y*1.1,k.z*1.1);
  text("E* 10",0,0);
  pop();
  push();
  translate(l.x*1.1,l.y*1.1,l.z*1.1);
  text("E* 11",0,0);
  pop();
  push();
  translate(m.x*1.1,m.y*1.1,m.z*1.1);
  text("E* 12",0,0);
  pop();
  push();
  translate(n.x*1.1,n.y*1.1,n.z*1.1);
  text("E* 13",0,0);
  pop();  
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
  show_points_cegb();  
  show_points_d();  
  show_points_fis();
  show_points_a(); 
  show_points_cis();
  show_points_e2();
  hint(ENABLE_DEPTH_TEST);
  //axes();  
}
