
public static class Options{
  public static int fontSize = 13;
  public static boolean showNotes;
  
  public static String midiDevice; 
  public interface MidiDevices {
    String MSWaveTableSynth = "Microsoft GS Wavetable Synth";
    String LoopMidi = "loopMIDI Port";
  }

  // The element determines if new tetras are placed on either the face, edge, of vertex of another tetra
  public static Element element;
  public enum Element {
    FACE, EDGE, VERTEX,
  }
  
  // The placemode is a set of combinations of the above booleans, giving a better interface for mode checks
  public static PlaceMode placeMode;
  public enum PlaceMode {
    BUILD, EXPLORE,
  }
  
  // removeOnNewRoot: whether the old tetras should be removed or not when a new root is created
  public static boolean removeOnNewRoot; 
  // keepPreviousRoot: Whether we should keep the previous root when exploring a new root
  public static boolean keepPreviousRoot;
  // allowReverseTravel: Allow the user to click on the previous root (this will not recreate the exact situation of the previous time that tetra was root)
  public static boolean allowReverseTravel;
  // placeSingle: whether only a single tetra should be connected to a single face of another tetra when clicked
  public static boolean placeSingle; 
  // edgeConnectStraight: wether the tetra connected to another tetra's edge should be straight (as a single tetra mirroring the other tetra at the edge)
  //    or if it should be connected as two tetras connected to each other by face.
  public static boolean edgeConnectStraight;
   
  /** 
  *  Sequence of notes added when a new root is created
  *  Follows the order of: major 3rd, minor 3rd, repeat.
  *  But is changable, it loops through the sequence using nextNote()
  *  Looping through the sequence with bigger steps can be done with nextNote(stepSize)
  */  
  public enum Sequence{
    THIRDS(new String[]{
      "A", "C#", "E", "G#", "B", "D#", "F#", "A#", "C#", "F", "G#",
      "C", "D#", "G", "A#", "D", "F", "A", "C", "E", "G", "B", "D", "F#"
    }),
    FOURTHS(new String[]{
      "A", "D", "G", "C", "F", "A#", "D#", "G#", "C#", "F#", "B", "E"
    }),
    FIFTHS(new String[]{
      "A", "E", "B", "F#", "C#", "G#", "D#", "A#", "F", "C", "G", "D"
    }),
    CHROMATIC(new String[]{
      "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#" 
    }),
    RANDOM(Chords.randomSequence(100));

    public String[] notes;
    
    private Sequence(String[] notes){
      this.notes = notes;
    }
  }
  public static Sequence seq;
  public static String getSeq(int i){ 
    return seq.notes[i%seq.notes.length];
  };
  public static void setNewSequence(Sequence newSequence){
    if(newSequence == Sequence.RANDOM){
      Sequence.RANDOM.notes = Chords.randomSequence(100);
    }
    seq = newSequence;
  }
  /*
  * Similar to the sequence of notes a sequence of colors is used to make new generated triangles have different colors
  * Use nextColor() and nextColor(step)
  */
  static int[][] colors = {{255,0,0},{0,255,0},{0,0,255},{255,255,0},{0,255,255},{255,0,255}};
  public static int[] getColor(int i){ return colors[i%colors.length];};

  static void setElement(Element newElement){
    element = newElement;
    updateSituationSettings();
  }

  static void setPlaceMode(PlaceMode mode){
    placeMode = mode;
    updateSituationSettings();
  }  
  
  static void updateSituationSettings(){
    if(placeMode == PlaceMode.BUILD){
      switch(element){
        case VERTEX: removeOnNewRoot = false; keepPreviousRoot = false; placeSingle = true; break;
        case EDGE: removeOnNewRoot = false; keepPreviousRoot = false; placeSingle = true; break;
        case FACE: removeOnNewRoot = false; keepPreviousRoot = false; placeSingle = true; break;
      }
    }else if(placeMode == PlaceMode.EXPLORE){
      switch(element){
        case VERTEX: removeOnNewRoot = true; keepPreviousRoot = false; placeSingle = false; break;
        case EDGE: removeOnNewRoot = true; keepPreviousRoot = false; placeSingle = false; break;
        case FACE: removeOnNewRoot = true; keepPreviousRoot = false; placeSingle = false; break;
      }
    }
  }
  
  public static void initDefault(){
    midiDevice = MidiDevices.MSWaveTableSynth;
    element = Element.FACE;
    placeMode = PlaceMode.EXPLORE;
    updateSituationSettings();
    allowReverseTravel = true;
    edgeConnectStraight = true;
    showNotes = true;
    seq = Sequence.THIRDS;
  }
}
