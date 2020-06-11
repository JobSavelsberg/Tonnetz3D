import controlP5.*;

ControlP5 cp5;
public class UI{  
  PImage faceImg = loadImage("assets/img/face.png"); 
  PImage edgeImg = loadImage("assets/img/edge.png"); 
  PImage vertexImg = loadImage("assets/img/vertex.png"); 
  
  PImage exploreImg = loadImage("assets/img/explore.png");
  PImage buildImg = loadImage("assets/img/build.png");
  
  PImage resetImg = loadImage("assets/img/reset.png");
  PImage undoImg = loadImage("assets/img/undo.png");
  PImage redoImg = loadImage("assets/img/redo.png");
  
  PImage fontImg = loadImage("assets/img/font.png");

  ControlFont cf;

  ImgToggle element;
  ImgToggle placeMode;
  ImgToggle fontToggle;

  ImgButtonGroup stateControls;
  
  DropdownList seqdd;
  int listWidth = 210;
  boolean shouldOpen = false;
  boolean shouldClose = false;
  
  public UI(PApplet app){    
    cp5 = new ControlP5(app);
    cp5.setAutoDraw(false);
    cf = new ControlFont(createFont("Lucida Sans",20));

    
    element = new ImgToggle(new String[]{"face", "edge", "vertex"}, 0, 0, new PImage[]{faceImg, edgeImg, vertexImg}, false, false, false);
    element.setCallback(new ToggleCallback() {
      void toggleCallbackMethod(String toggleName, boolean on){
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
    
    placeMode = new ImgToggle(new String[]{"explore", "build"}, 0, 0, new PImage[]{exploreImg, buildImg}, true, false, false);
    placeMode.setCallback(new ToggleCallback() {
      void toggleCallbackMethod(String toggleName, boolean on){
        switch(toggleName){
            case "explore": Options.setPlaceMode(Options.PlaceMode.EXPLORE); break;
            case "build": Options.setPlaceMode(Options.PlaceMode.BUILD); break;
        }
      }
    });
    
    fontToggle = new ImgToggle(new String[]{"font"}, 0, 0, new PImage[]{fontImg}, false, true, true);
    fontToggle.setOn(0);
    fontToggle.setCallback(new ToggleCallback() {
      void toggleCallbackMethod(String toggleName, boolean on){
        switch(toggleName){
            case "font": Options.showNotes = on; break;
        }
      }
    });
    
    stateControls = new ImgButtonGroup(new String[]{"reset", "undo", "redo"}, 0, 0, new PImage[]{resetImg, undoImg, redoImg}, true, true);
    stateControls.setCallback(new ButtonCallback() {
      void buttonCallbackMethod(String buttonName){
        switch(buttonName){
            case "reset": reset(); break;
            case "undo": undo(); break;
            case "redo": redo(); break;
        }
      }
    });
    seqdd =new DropdownList(cp5, Options.Sequence.THIRDS.toString());
    seqdd.setPosition(2, 73);
    seqdd.setSize(listWidth,200);
    seqdd.setBarHeight(30);
    seqdd.setItemHeight(30);
    seqdd.setColorBackground(color(0,0,0,50));
    seqdd.setColorCaptionLabel(color(255));      // Color of lil dropdown arrow
    seqdd.setColorForeground(color(0,0,0,50));    // BackgroundColor when hover
    seqdd.setColorValueLabel(color(100));  // Color of idle text
    seqdd.setColorActive(color(100));
    seqdd.getCaptionLabel().setFont(cf);
    seqdd.getValueLabel().setFont(cf);
    seqdd.getCaptionLabel().getStyle().marginTop = 7;
    seqdd.getCaptionLabel().getStyle().marginBottom = 5;
    seqdd.getCaptionLabel().getStyle().marginLeft = 10;
    seqdd.getValueLabel().getStyle().marginTop = 7;
    seqdd.getValueLabel().getStyle().marginBottom = 5;
    seqdd.getValueLabel().getStyle().marginLeft = 10;
    for(Options.Sequence s : Options.Sequence.values()){
      seqdd.addItem(s.toString(),s);
    }
    seqdd.close();
    seqdd.onPress(new CallbackListener(){
      public void controlEvent(CallbackEvent event) {
        float[] position = seqdd.getPosition();
        int elementHeight = 30;
        for(int i = 0; i < Options.Sequence.values().length + 1; i++){
          if(mouseX > position[0] && mouseX < position[0]+listWidth){
            if(mouseY > position[1] + i*elementHeight && mouseY < position[1] + (i+1)*elementHeight){
              if(i>0){
                seqdd.setValue(i-1);
                seqdd.changeValue(i-1);
                seqdd.close();
                seqdd.update();
                seqdd.setCaptionLabel(Options.Sequence.values()[i-1].toString());
                Options.setNewSequence(Options.Sequence.values()[i-1]);
                reset();
              }else{
                if(seqdd.isOpen()){
                  shouldClose = true;
                }else{
                  shouldOpen = true;
                }
              }
            }
          }
        }
      }
    });
    seqdd.onRelease(new CallbackListener(){
      public void controlEvent(CallbackEvent event) {
        if(shouldOpen){
          seqdd.open();
          shouldOpen = false;
        }
        if(shouldClose){
          seqdd.close();  
          shouldClose = false;
        }
        
      }
    });

  }


  void customize(DropdownList ddl) {
    // a convenience function to customize a DropdownList
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    for (int i=0;i<40;i++) {
      ddl.addItem("item "+i, i);
    }
    //ddl.scroll(0);
    ddl.setColorBackground(color(60));
    ddl.setColorActive(color(255, 128));
  }
  
  public void setColor(color c){
    element.setOnColor(c);
    placeMode.setOnColor(c);
    fontToggle.setOnColor(c);
    stateControls.setOnColor(c);
    float s = 1.4;
    color saturatedColor = color(min(red(c)*s,255),min(green(c)*s,255),min(blue(c)*s,255));
    //seqdd.setColorLabel(saturatedColor); 
    seqdd.setColorForeground(saturatedColor);
  }
  
  
  public void draw(){
    cp5.draw();
  }
  
  public void resizeWindow(){
    element.resizeWindow();
    placeMode.resizeWindow();
    fontToggle.resizeWindow();
    stateControls.resizeWindow();
    cp5.draw();
  }
}

public class ImgButtonGroup{
  final PImage square = loadImage("assets/img/square.png"); 
  PImage buttonSquare;
  color squareColor = color(0);
  color offColor = color(100);
  color onColor = color(255);
  float scale = 0.55;
  String[] buttonNames;
  Button[] buttons;
  PImage[] images;
  PImage[][] buttonImages;
  ButtonCallback buttonCallback = null;
  int x, y;
  int offset;
  boolean floatRight;
  boolean floatBottom;

  public ImgButtonGroup(String[] names, int x, int y, PImage[] images, boolean right, boolean bottom){
    this(names, x, y, images, 2, right, bottom);
  }
  public ImgButtonGroup(String[] names, int x, int y, PImage[] images, int offset, boolean floatRight, boolean floatBottom){
    this.images = images;
    prepareButtonImages(images);
    int imgWidth = int(square.width*scale);
    buttons = new Button[names.length];
    buttonNames = names;
    this.x = x;
    this.y = y;
    this.offset = offset;
    this.floatRight = floatRight;
    this.floatBottom = floatBottom;

    int posx = floatRight ? width - (imgWidth*names.length + (names.length+1)*offset) : x;
    int posy = floatBottom ? height - imgWidth -offset: y;
    for(int i = 0; i < names.length; i++){
      buttons[i] = cp5.addButton(names[i])
       .setImages(buttonImages[i])
       .setSize(imgWidth, imgWidth)
       .setPosition(posx+i*imgWidth+(i+1)*offset,posy);
       
      buttons[i].addCallback(new ButtonCallbackListener(i));
    }  
  }
  
   public void setOnColor(color c){
    onColor = c;
    prepareButtonImages(images);
    for(int i = 0; i < buttons.length; i++){
      buttons[i].setImages(buttonImages[i]);
    }
  }
  
  public void prepareButtonImages(PImage[] images){
    buttonImages = new PImage[images.length][3];
    buttonSquare = colorImage(square, squareColor, false);
    for(int i = 0; i < images.length; i++){
      buttonImages[i][0] = addImage(buttonSquare, colorImage(images[i], offColor, true));
      buttonImages[i][1] = addImage(buttonSquare, colorImage(images[i], onColor, true));
      buttonImages[i][2] = buttonImages[i][1].copy();
      
      for(int j = 0; j < 3; j++){
        buttonImages[i][j].resize(int(float(buttonImages[i][j].width)*scale),int(float(buttonImages[i][j].height)*scale));
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
  
  public void setCallback(ButtonCallback buttonCallback){
    this.buttonCallback= buttonCallback;
  }
  
  public void callback(int buttonID, CallbackEvent event){
    if(event.getAction() == ControlP5.ACTION_RELEASE){
      if(buttonCallback != null){
        buttonCallback.buttonCallbackMethod(buttonNames[buttonID]);
      }
    }
  }
  
  public void resizeWindow(){
    if(floatRight || floatBottom){
      int imageWidth = int(square.width*scale);
      int posx = floatRight? width - (imageWidth*buttons.length + (buttons.length+1)*this.offset): x;
      int posy = floatBottom ? height - imageWidth -offset: y;
      
      for(int i = 0; i < buttons.length; i++){
        float[] position = new float[]{posx+i*imageWidth+(i+1)*offset,posy};
        buttons[i].setPosition(position);
      }  
    }
  }
  
  public class ButtonCallbackListener implements CallbackListener{
    int toggleID;
    
    public ButtonCallbackListener(int ID){
      super();
      toggleID = ID;
    }
    
    public void controlEvent(CallbackEvent event) {
      callback(toggleID, event);
    }
  }
}

interface ButtonCallback { 
  void buttonCallbackMethod(String buttonName);
}

public class ImgToggle{
  final PImage square = loadImage("assets/img/square.png"); 
  PImage toggleSquare;
  color toggleSquareColor = color(0);
  color offColor = color(100);
  color onColor = color(255);
  float scale = 0.55;
  String[] toggleNames;
  Toggle[] toggles;
  PImage[] images;
  PImage[][] toggleImages;
  int selected = 0;
  boolean[] toggled;
  ToggleCallback toggleCallback = null;
  int x, y;
  int offset;
  boolean floatRight;
  boolean floatBottom;
  boolean individualToggle;

  public ImgToggle(String[] names, int x, int y, PImage[] images, boolean right, boolean bottom, boolean individualToggle){
    this(names, x, y, images, 2, right, bottom, individualToggle);
  }
  public ImgToggle(String[] names, int x, int y, PImage[] images, int offset, boolean floatRight, boolean floatBottom, boolean individualToggle){
    this.images = images;
    prepareButtonImages(images);
    int imgWidth = int(square.width*scale);
    toggles = new Toggle[names.length];
    toggled = new boolean[names.length];
    toggleNames = names;
    this.x = x;
    this.y = y;
    this.offset = offset;
    this.floatRight = floatRight;
    this.floatBottom = floatBottom;
    this.individualToggle = individualToggle;

    int posx = floatRight ? width - (imgWidth*names.length + (names.length+1)*offset) : x;
    int posy = floatBottom ? height - imgWidth -offset: y;

    for(int i = 0; i < names.length; i++){
      toggles[i] = cp5.addToggle(names[i])
       .setValue(i == selected)
       .setImages(toggleImages[i])
       .setSize(imgWidth, imgWidth)
       .setPosition(posx+i*imgWidth+(i+1)*offset,posy);
       
      toggles[i].addCallback(new ToggleCallbackListener(i));
    }  
    setSelected(0);
  }
  
  public void setOn(int toggleID){
    toggled[toggleID] = true;
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
    toggleSquare = colorImage(square, toggleSquareColor, false);
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
      if(individualToggle){
        toggled[toggleID] =! toggled[toggleID];
        toggles[toggleID].setValue(toggled[toggleID]);
        toggleCallback.toggleCallbackMethod(toggleNames[selected], toggled[toggleID]);
      }else{
        if(toggles[toggleID].getValue() > 0){
          for(int i = 0; i< toggles.length; i++){
            toggles[i].setValue(false);
          }
          toggles[toggleID].setValue(true);
          selected = toggleID;
          if(toggleCallback != null){
            toggleCallback.toggleCallbackMethod(toggleNames[selected], true);
          }
        }else if(toggleID == selected){
          // Not allowed to turn off last remaining button
          toggles[toggleID].setValue(true);
        }
      }
    }
  }
  
  public void resizeWindow(){
    if(floatRight || floatBottom){
      int imageWidth = int(square.width*scale);
      int posx = floatRight? width - (imageWidth*toggles.length + (toggles.length+1)*this.offset): x;
      int posy = floatBottom ? height - imageWidth -offset: y;

      for(int i = 0; i < toggles.length; i++){
        toggles[i].setPosition(posx+i*imageWidth+(i+1)*this.offset,posy);
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
  void toggleCallbackMethod(String toggleName, boolean on);
}
