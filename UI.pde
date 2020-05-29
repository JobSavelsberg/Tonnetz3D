import controlP5.*;

ControlP5 cp5;
public class UI{
  PImage faceImg = loadImage("assets/img/face.png"); 
  PImage edgeImg = loadImage("assets/img/edge.png"); 
  PImage vertexImg = loadImage("assets/img/vertex.png"); 
  PImage[] faceImgs, edgeImgs, vertexImgs;
  
  PImage exploreImg = loadImage("assets/img/explore.png");
  PImage buildImg= loadImage("assets/img/build.png");
  PImage[] exploreImgs, buildImgs;
  
  ImgToggle element;
  ImgToggle placeMode;
  
  public UI(PApplet app){    
    cp5 = new ControlP5(app);
    cp5.setAutoDraw(false);
    
    element = new ImgToggle(new String[]{"face", "edge", "vertex"}, 0, 0, new PImage[]{faceImg, edgeImg, vertexImg}, false);
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
    
    placeMode = new ImgToggle(new String[]{"explore", "build"}, 0, 0, new PImage[]{exploreImg, buildImg}, true);
    placeMode.setCallback(new ToggleCallback() {
      void toggleCallbackMethod(String toggleName){
        switch(toggleName){
            case "explore": Options.setPlaceMode(Options.PlaceMode.EXPLORE); break;
            case "build": Options.setPlaceMode(Options.PlaceMode.BUILD); break;
        }
      }
    });
  }
  
  public void setColor(color c){
    element.setOnColor(c);
    placeMode.setOnColor(c);
  }
  
  
  public void draw(){
    cp5.draw();
  }
}

public class ImgToggle{
  final PImage square = loadImage("assets/img/square.png"); 
  PImage toggleSquare;
  color toggleSquareColor = color(0);
  color offColor = color(100);
  color onColor = color(255);
  float scale = 0.65;
  int offset;
  String[] toggleNames;
  Toggle[] toggles;
  PImage[] images;
  PImage[][] toggleImages;
  int selected = 0;
  ToggleCallback toggleCallback = null;
  
  public ImgToggle(String[] names, int x, int y, PImage[] images, boolean right){
    this(names, x, y, images, 2, right);
  }
  public ImgToggle(String[] names, int x, int y, PImage[] images, int offset, boolean right){
    this.images = images;
    prepareButtonImages(images);
    int imgWidth = int(square.width*scale);
    toggles = new Toggle[names.length];
    toggleNames = names;

    int posx = right ? width - (imgWidth*names.length + (names.length+1)*offset) : x;
    
    for(int i = 0; i < names.length; i++){
      toggles[i] = cp5.addToggle(names[i])
       .setValue(i == selected)
       .setImages(toggleImages[i])
       .setSize(imgWidth, imgWidth)
       .setPosition(posx+i*imgWidth+(i+1)*offset,y);
       
      toggles[i].addCallback(new ToggleCallbackListener(i));
    }  
    setSelected(0);
  }
  
  public void setOnColor(color c){
    onColor = c;
    prepareButtonImages(images);
    for(int i = 0; i < toggles.length; i++){
      toggles[i].setImages(toggleImages[i]);
    }
  }
  
  public void prepareButtonImages(PImage[] images){
    toggleImages = new PImage[images.length][3];
    PImage toggleSquare = colorImage(square, toggleSquareColor, false);
    for(int i = 0; i < images.length; i++){
      toggleImages[i][0] = addImage(toggleSquare, colorImage(images[i], offColor, true));
      toggleImages[i][1] = addImage(toggleSquare, colorImage(images[i], onColor, true));
      toggleImages[i][2] = toggleImages[i][1].copy();
      
      for(int j = 0; j < 3; j++){
        toggleImages[i][j].resize(int(float(toggleImages[i][j].width)*scale),int(float(toggleImages[i][j].height)*scale));
      }
    }
  }
  
  public PImage addImage(PImage a, PImage b){
    PImage result = a.copy();
    result.blend(b,0,0,b.width,b.height,0,0,a.width,a.height, ADD);
    return result;
  }
  
  final float s = 0.5f;//saturation
  final float l = 1.5f;
  public PImage colorImage(PImage image, color c, boolean black){
    PImage newImage = image.copy();
    for (int i = 0; i < image.width*image.height; i++) { 
      if(black){
        newImage.pixels[i] = color(red(c)*l, green(c)*l, blue(c)*l, alpha(image.pixels[i]));  
      }else{
        newImage.pixels[i] = color(
          red(image.pixels[i])+(red(c)-127)*s, 
          green(image.pixels[i])+(green(c)-127)*s, 
          blue(image.pixels[i])+(blue(c)-127)*s, 
          alpha(image.pixels[i])
        ); 
      }
    }
    return newImage;
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
          toggleCallback.toggleCallbackMethod(toggleNames[selected]);
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
