class manaPoint{
  
  int default_MP = 100;
  int max_MP;
  int current_MP;
  
  manaPoint() {
    max_MP = default_MP;
    current_MP = max_MP;
  }
  //change mana point
  void applyChange(int value) {
    current_MP = current_MP + value;
    //no more than max
    if (current_MP > max_MP) {
      current_MP = max_MP;
    }
    //no less than 0
    if (current_MP < 0) {
      current_MP = 0;
    }
  }
  //change max_MP
  void changeMax(int value) {
    max_MP = max_MP + value;
    if (current_MP > max_MP) {
      current_MP = max_MP;
    }
  }
}
