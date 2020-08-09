public class gate extends interActable{
  
  PImage gateIMG;
  room targetRoom;
  int targetX;
  int targetY;
  
  gate(int x, int y, int x_size, int y_size) {
    gateIMG = loadImage("image/gate.jpeg");
    max_hit = 100;
    inRoom_x = x;
    inRoom_y = y;
    X_size = x_size;
    Y_size = y_size;
    opened = false;
  }
  //indestructable
  public void takeDamage() {
    return;
  }
  
  public void interAct(player MyPlayer) {
    MyPlayer.playRoom = targetRoom;
    MyPlayer.position.x = targetX;
    MyPlayer.position.y = targetY;
  }
  
  public void display() {
    imageMode(CENTER);
    image(gateIMG, inRoom_x, inRoom_y , X_size, Y_size);
  }
}
