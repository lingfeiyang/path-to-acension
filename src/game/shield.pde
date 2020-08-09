class shield{
  
  int default_Strength = 100; //base shield strength
  int max_shield;             //max shield strength
  int current_shield;         //current strength
  element type;
  
  shield() {
    max_shield = default_Strength;
    current_shield = max_shield;
  }
  void setElement(element e) {
    type = e;
  }
  //calculate a multipier of shield strength to get the over strength
  void changeMax(int value) {
    max_shield = max_shield + value;
    if (current_shield > max_shield) {
      current_shield = max_shield;
    }
  }
}
