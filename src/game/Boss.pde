public class boss{
  PVector position;
  PVector direction;
  int size;
  
  
  boss() {
    position = new PVector();
    position.x = width / 2;
    position.y = height / 2;
    size = 50;
  }
  void specialMove() {
    
  }
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    ellipseMode(CENTER);
    ellipse(position.x, position.y, size, size);
  }
  
}
