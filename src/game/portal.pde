class portal {
  
  room target;
  int x_inRoom;
  int y_inRoom;
  int size = 30;
  boolean enabled;//portal disable when there are enemies in room
  boolean visited;//show the room it connects to if visisted
  //transparency values to give a glowing effect
  int transparency = 200;
  int transChange = -1;
  //constructor
  portal(room target) {
    this.target = target;
    enabled = true;
    visited = false;
  }
  //display portal
  void display() {
    if (enabled) {
      //display glowing
      stroke(0, 240, 240, transparency);
      strokeWeight(1);
      fill(0, 240, 240, transparency);
      ellipse(x_inRoom, y_inRoom, size, size);
      
      transparency = transparency + transChange;
      if (transparency == 50) {
        transChange = 1;
      } else if (transparency == 200) {
        transChange = -1;
      }
    }
  }
}
