import java.lang.*;

public static class Chords{
  static final int OCTAVE = 12;
  static final ArrayList<String> noteNames = new ArrayList<String>(Arrays.asList(
    "A","A#","Bb","B","C","C#","Db","D","D#","Eb","E","F","F#","Gb","G","G#","Ab"
  ));
  static final int[] noteMidi = {1,2,2,3,4,5,5,6,7,7,8,9,10,10,11,12,12};
  
  public static int[] minor(String note, int octave){
    int n = noteNameToMidi(note, octave);
    return new int[]{n, n+3, n+7};
  }
  
  public static int[] major(String note, int octave){
    int n = noteNameToMidi(note, octave);
    return new int[]{n, n+4, n+7};
  }
    
  public static int[] min7(String note, int octave){
    int n = noteNameToMidi(note, octave);
    return new int[]{n, n+3, n+7, n+10};
  }
  
  public static int[] maj7(String note, int octave){
    int n = noteNameToMidi(note, octave);
    return new int[]{n, n+4, n+7, n+11};
  }
  
  public static int noteNameToMidi(String note){
    return noteMidi[noteNames.indexOf(note)];
  }
  
  public static int noteNameToMidi(String note, int octave){
    return noteMidi[noteNames.indexOf(note)] + octave * OCTAVE;
  }
  
  public static int[] noteNamesToMidi(String[] notes, int octave){
    int[] midiValues = new int[notes.length];
    for(int i = 0; i < notes.length; i++){
      midiValues[i] = noteNameToMidi(notes[i], octave);
    }
    return midiValues;
  }
  
  public static int[] noteNamesToMidiRandom(String[] notes, int minOctave, int maxOctave){
    int[] midiValues = new int[notes.length];
    for(int i = 0; i < notes.length; i++){
      float random = (float) Math.random();
      int randomOctave = minOctave + round(random*(maxOctave-minOctave));
      midiValues[i] = noteNameToMidi(notes[i], randomOctave);
    }
    return midiValues;
  }
  
  public static int[] invert(int[] chord){
    int[] inverted = new int[chord.length];
    inverted[chord.length-1] = chord[0] + OCTAVE;
    for(int i = 0; i < chord.length-1; i++){
      inverted[i] = chord[i+1];
    }
    return inverted;
  }
  
  public static int[] sort(int[] pitches){
    int[] sorted = pitches.clone();
    Arrays.sort(sorted);
    return sorted;
  }
}
