import controlP5.*;

ControlP5 cp5;
public class UI{
  PImage[] faceImgs = {loadImage("assets/img/face.png"),loadImage("assets/img/face0.png"),loadImage("assets/img/face0.png")};
  PImage[] faceImgsResized = faceImgs;
  PImage[] edgeImgs = {loadImage("assets/img/edge.png"), loadImage("assets/img/edge0.png"), loadImage("assets/img/edge0.png")};
  PImage[] edgeImgsResized = edgeImgs;
  PImage[] vertexImgs = {loadImage("assets/img/vertex.png"), loadImage("assets/img/vertex0.png"),loadImage("assets/img/vertex0.png")};
  PImage[] vertexImgsResized = vertexImgs;

  ImgToggle element;
  RadioButton placeMode;
  
  public UI(PApplet app){
    resizeAllImages(0.5);
    
    cp5 = new ControlP5(app);
    cp5.setAutoDraw(false);
    
    element = new ImgToggle(new String[]{"face", "edge", "vertex"}, 0, 0, new PImage[][]{faceImgsResized, edgeImgsResized, vertexImgsResized});
    element.setCallback(new ToggleCallback() {
      void toggleCallbackMethod(String toggleName){
        switch(toggleName){
            case "face": Options.setElement(Options.Element.FACE); break;
            case "edge": Options.setElement(Options.Element.EDGE); break;
            case "vertex": Options.setElement(Options.Element.VERTEX); break;
        }
        if(Options.placeMode == Options.PlaceMode.EXPLORE){
          changedExploreElement();
        }
      }
    });
    
  }
  
  public void createImgRadio(){
  }
  
  public void resizeAllImages(float scale){
    resizeImages(faceImgs, faceImgsResized, scale);
    resizeImages(edgeImgs, edgeImgsResized, scale);
    resizeImages(vertexImgs, vertexImgsResized, scale);
  }
  
  public void resizeImages(PImage[] imgs, PImage[] imgsCopy, float scale){
    for(int i=0; i<3; i++){
      imgsCopy[i] = imgs[i].copy();
      imgsCopy[i].resize(int(float(imgsCopy[i].width)*scale),int(float(imgsCopy[i].height)*scale));
    }
  } 
  
  public void draw(){
    cp5.draw();
  }
}

public class ImgToggle{
  final int offset = 2;
  String[] names;
  Toggle[] toggles;
  int selected = 0;
  ToggleCallback toggleCallback = null;
  
  public ImgToggle(String[] names, int x, int y, PImage[][] images){
    int imgWidth = images[0][0].width;
    toggles = new Toggle[names.length];
    this.names = names;
    
    for(int i = 0; i < names.length; i++){
      toggles[i] = cp5.addToggle(names[i])
       .setValue(i == selected)
       .setImages(images[i])
       .setSize(imgWidth, imgWidth)
       .setPosition(x+i*imgWidth+i*offset,y);
       
      toggles[i].addCallback(new ToggleCallbackListener(i));
    }  
    setSelected(0);
  }
  public void setSelected(int newSelected){
    selected = newSelected;
    for(int i = 0; i < toggles.length; i++){
      toggles[i].setValue(selected == i);
    }
  }
  
  public void setCallback(ToggleCallback toggleCallback){
    this.toggleCallback= toggleCallback;
  }
  
  public void callback(int toggleID, CallbackEvent event){
    if(event.getAction() == ControlP5.ACTION_PRESS){
      if(toggles[toggleID].getValue() > 0){
        for(int i = 0; i< toggles.length; i++){
          toggles[i].setValue(false);
        }
        toggles[toggleID].setValue(true);
        selected = toggleID;
        if(toggleCallback != null){
          toggleCallback.toggleCallbackMethod(names[selected]);
        }
      }else if(toggleID == selected){
        // Not allowed to turn off last remaining button
        toggles[toggleID].setValue(true);
      }
    }
  }
  
  public class ToggleCallbackListener implements CallbackListener{
    int toggleID;
    
    public ToggleCallbackListener(int ID){
      super();
      toggleID = ID;
    }
    
    public void controlEvent(CallbackEvent event) {
      callback(toggleID, event);
    }
  }
}

interface ToggleCallback { 
  void toggleCallbackMethod(String toggleName);
}
