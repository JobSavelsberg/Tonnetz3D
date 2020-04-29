import java.util.*;
import themidibus.*;
/*
*  A bridge between themidibus and the program
 *  makes sure that notes can be played for longer durations while not pausing the program
 */
class Midi {
  MidiBus midiBus;
  int channel;
  boolean retrig = true;
  ArrayList<LongNote> playingNotes = new ArrayList<LongNote>();

  public Midi(int channel) {
    this.channel = channel;
    midiBus = new MidiBus(this, -1, "Microsoft GS Wavetable Synth");
  }

  public void playNote(String note, int octave, int velocity, int duration, int delay) {
    playNote(Chords.noteNameToMidi(note, octave),velocity, duration, delay);
  }
  public void playNote(String note, int octave, int velocity, int duration) {
    playNote(Chords.noteNameToMidi(note, octave),velocity, duration, 0);
  }
  public void playNote(int pitch, int velocity, int duration) {
    playNote(pitch,velocity, duration, 0);
  }
  public void playNote(int pitch, int velocity, int duration, int delay) {
    LongNote playingNote = getPlayingNote(pitch);
    if(playingNote != null){
      if(retrig){
        playingNote.retrigger(velocity, duration, delay);
      }else{
        playingNote.addDuration(duration);
      }
    }else{
      LongNote note = new LongNote(this.channel, pitch, velocity, duration, delay);
      note.play();
      playingNotes.add(note);
    }
  }
  
  public void strumChord(String[] notes, int velocity, int duration, int strumdelay, int minOctave, int maxOctave) {
    strumChord(Chords.noteNamesToMidiRandom(notes,minOctave,maxOctave), velocity, duration, strumdelay);
  }

  public void strumChord(String[] notes, int octave, int velocity, int duration, int strumdelay) {
    strumChord(Chords.noteNamesToMidi(notes,octave), velocity, duration, strumdelay);
  }
  public void strumChord(int[] pitches, int velocity, int duration, int strumdelay) {
    pitches = removeCopies(pitches);
    pitches = Chords.sort(pitches);
    int delay = 0;
    for(int pitch : pitches){
       playNote(pitch, velocity, duration, delay);
       delay += strumdelay;
    }
  }
  public void playChord(String[] notes, int octave, int velocity, int duration) {
    playChord(Chords.noteNamesToMidi(notes,octave), velocity, duration);
  }
  public void playChord(int[] pitches, int velocity, int duration) {
    pitches = removeCopies(pitches);
    for(int pitch : pitches){
       playNote(pitch, velocity, duration);
    }
  }

  public int[] removeCopies(int[] pitches){
    ArrayList<Integer> unique =  new ArrayList<Integer>();
    for(int pitch: pitches){
      if(!unique.contains(pitch)){
        unique.add(pitch);
      }
    }
    int[] result = new int[unique.size()];
    for(int i = 0; i < unique.size(); i++){
      result[i] = unique.get(i);
    }
    return result;
  }

  public void update(int millis) {
    Iterator<LongNote> itr = playingNotes.iterator();
    while (itr.hasNext()) { 
      LongNote note = itr.next(); 
      note.update(millis);
      if (note.hasStopped()) { 
        itr.remove();
      }
    } 
  }
  
  
  private LongNote getPlayingNote(int pitch){
     int index = indexOfNote(pitch);
     if(index != -1){
        return playingNotes.get(index); 
     }
     return null;
  }
  
  private int indexOfNote(int pitch){
    for(int i = 0; i < playingNotes.size(); i++){
       if(playingNotes.get(i).pitch == pitch){
          return i;
       }
    }
    return -1;
  }
  
  class LongNote extends Note {
    int delay;
    int life;
    boolean playing = false;
  
    public LongNote(int channel, int pitch, int velocity, int duration, int delay) {
      this(channel,pitch, velocity, duration);
      this.delay = delay;
    }
    public LongNote(int channel, int pitch, int velocity, int duration) {
      super(channel, pitch, velocity);
      life = duration;
    }
  
    public void play(){
       if(delay <= 0){
         midiBus.sendNoteOn(this);
         playing = true;
       }
    }
    
    public void retrigger(int velocity, int duration, int delay){
      if(playing){
        stop();
      }
      this.velocity = velocity;
      this.life = duration;
      this.delay = delay;
      if(delay <= 0){
        play();
      }      
    }
    
    public void stop(){
       midiBus.sendNoteOff(this); 
       playing = false;
    }
  
    public void update(int millis) {
      if(delay > 0){
        delay -= millis; 
        if(delay <= 0){
          play();
        }
      }
      if(playing){
        life -= millis;
        if(life <= 0){
          stop();
        }
      }
    }
    
    
    public void setDuration(int duration){
      this.life = duration; 
    }
    
    public void addDuration(int duration){
      this.life += duration;  
    }
  
    public boolean hasStopped() {
      return !playing && life <= 0;
    }
  }
}
