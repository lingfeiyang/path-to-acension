abstract class interActable{
  //objects are destroyed after an amount of hits
  int max_hit;
  //x,y coordinates and size
  int inRoom_x;
  int inRoom_y;
  int X_size;
  int Y_size;
  //if the objected is interacted
  boolean opened;
  abstract void takeDamage();
  
  abstract void interAct(player MyPlayer);
  
  abstract void display();
}
