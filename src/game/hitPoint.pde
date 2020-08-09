class hitPoint{
  
  int default_HP = 100;
  int max_HP;
  int current_HP;
  
  hitPoint() {
    max_HP = default_HP;
    current_HP = max_HP;
  }
  //change hit point
  void applyChange(int value) {
    current_HP = current_HP + value;
    //no more than max
    if (current_HP > max_HP) {
      current_HP = max_HP;
    }
    //no less than 0
    if (current_HP < 0) {
      current_HP = 0;
    }
  }
  //change max_HP
  void changeMax(int value) {
    max_HP = max_HP + value;
    if (current_HP > max_HP) {
      current_HP = max_HP;
    }
  }
}
