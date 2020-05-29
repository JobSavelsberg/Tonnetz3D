import controlP5.*;

ControlP5 cp5;
public class UI{
  PImage faceImage = loadImage("assets/img/face.png");
  PImage face0Image = loadImage("assets/img/face0.png");
  PImage edgeImage = loadImage("assets/img/edge.png");
  PImage edge0Image = loadImage("assets/img/edge0.png");
  PImage vertexImage = loadImage("assets/img/vertex.png");
  PImage vertex0Image = loadImage("assets/img/vertex0.png");

  RadioButton element;
  RadioButton placeMode;
  
  public UI(PApplet app){
    cp5 = new ControlP5(app);
    cp5.setAutoDraw(false);
    element = cp5.addRadioButton("radioButton")
         .setPosition(0,5)
         .setSize(faceImage.width/2, faceImage.height/2)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(3)
         .setSpacingColumn(5)
         .setSpacingRow(5)
         .addItem("FACE",1)
         .setImages(faceImage,face0Image,face0Image)
         .addItem("EDGE",2)
         .setImages(edgeImage,edge0Image,edge0Image)
         .addItem("VERTEX",3)
         .setImages(vertexImage,vertex0Image,vertex0Image)
         .hideLabels() 
         ;
  }
  
  
  public void draw(){
    cp5.draw();
  }
}
