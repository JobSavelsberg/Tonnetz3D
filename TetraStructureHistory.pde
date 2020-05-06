class TetraStructureHistory{
  ArrayList<ArrayList<Tetra>> tetraStructureHistory = new ArrayList<ArrayList<Tetra>>();
  ArrayList<Tetra> currentTetraStructure;
  int currentState = -1;
  
  public TetraStructureHistory(ArrayList<Tetra> tetraStructure){
    this.currentTetraStructure = tetraStructure;
    currentState = 0;
  }
  
  void push(){
    if(currentState != newestState()){
      revertToState(currentState);
    }
    if(currentState == newestState()){
       currentState++;
    }
    tetraStructureHistory.add(structureClone(tetraStructure));
  }
  
  ArrayList<Tetra> pop(){
    ArrayList<Tetra> popped = tetraStructureHistory.get(newestState()); 
    tetraStructureHistory.remove(newestState());
    if(currentState == newestState()+1){
      currentState = newestState();
    }
    return popped;
  }
  
  void previous(){
    if(currentState > 0 && currentState <= newestState()){
      currentState--;
      setCurrentTetraStructure(tetraStructureHistory.get(currentState));
    }
  }
  
  void next(){
    if(currentState >= 0 && currentState < newestState()){
      currentState++;
      setCurrentTetraStructure(tetraStructureHistory.get(currentState));
    }
  }
  
  void revertToState(int state){
    if(state < 0 || state > newestState()){
        return;
    }
    while(newestState() > state){
      tetraStructureHistory.remove(newestState());
    }
  }
  
  void reset(){
    currentState = -1;
    tetraStructureHistory.clear();
  }
  
  void setCurrentTetraStructure(ArrayList<Tetra> tetraStructure){
    currentTetraStructure.clear();
    for(Tetra t: tetraStructure){
      currentTetraStructure.add(t.getCopy());  
    }
    
  }
  
  ArrayList<Tetra> structureClone(ArrayList<Tetra> tetraStructure){
    ArrayList<Tetra> cloneStructure = new ArrayList<Tetra>();
    for(int i = 0; i < tetraStructure.size(); i++){
      Tetra clone = tetraStructure.get(i).getCopy();
      cloneStructure.add(clone);
    }
    return cloneStructure;
  }
  
  int newestState(){
    return tetraStructureHistory.size()-1;  
  }
}
