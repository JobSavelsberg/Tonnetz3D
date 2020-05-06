static class ToneColorMapping{
  private static final String[] circleOfFifthsArray = {"C", "G", "D","A", "E", "B", "F#", "C#", "G#", "D#", "A#", "F"};
  private static final ArrayList<String> circleOfFifths = new ArrayList<String>(Arrays.asList(circleOfFifthsArray));
  private static final Color[] circleOfColor = {new Color(255,0,0), new Color(255,148,0), new Color(255,197,0), new Color(255,255,0),new Color(140,199,0), 
  new Color(15,173,0), new Color(0,163,199),new Color(0,100,181), new Color(0,16,165),new Color(99,0,165), new Color(197,0,124)};
  private static final Color middleColor = new Color(127,127,127);
  private static final PVector up = new PVector(0,1);
  
  public static Color getColor(String[] notes){
    PVector average = new PVector(0,0);
    for(String note : notes){
      average.add(getVector(note));
    }
    average.div(notes.length);
    
    return vectorToColor(average);
  }
  
  private static PVector getVector(String note){
    int index = circleOfFifths.indexOf(note);
    float angle = index/11f*2*PI;
    return PVector.fromAngle(angle);
  }
  
  private static Color vectorToColor(PVector vector){
    float angle = PVector.angleBetween(up,vector);
    if(vector.x <0){
      angle = 2*PI-angle;
    }
    float index = angle/(2*PI)*11f;
    Color hue = colorFromFloatIndex(index);
    return Color.saturationLerp(hue,vector.mag());
  }
  

  private static Color colorFromFloatIndex(float index){
    int fromIndex = floor(index);
    int toIndex = ceil(index) % circleOfColor.length;
    float weight = index % 1;
    return Color.colorLerp(circleOfColor[fromIndex], circleOfColor[toIndex], weight);
  }

  public static class Color {
    int r;
    int g;
    int b;
    public Color(int r, int g, int b){
      this.r = r;
      this.g = g;
      this.b = b;
    }
    
    public static Color colorLerp(Color a, Color b, float amount){
      return new Color((int)lerp(a.r,b.r,amount), (int)lerp(a.g,b.g,amount),(int)lerp(a.b,b.b,amount));
    }
    
    public static Color saturationLerp(Color a, float amount){
      return colorLerp(middleColor,a,amount);
    }
  }
}
