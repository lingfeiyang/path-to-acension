public class obstacle extends interActable{

  //x,y coordinates and size   
  obstacle(int x, int y, int X_size, int Y_size) {
    inRoom_x = x;
    inRoom_y = y;
    this.X_size = X_size;
    this.Y_size = Y_size;
    max_hit = 10;
    opened = true;
  }
  
  void takeDamage() {
    max_hit--;
  }
  void interAct(player MyPlayer) {
    return;
  }
  void display(){
    stroke(0);
    strokeWeight(1);
    fill(100);
    rectMode(CENTER);
    rect(inRoom_x, inRoom_y, X_size, Y_size);
  }
}
