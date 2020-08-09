public class bow extends Weapon{
  
  ArrayList<arrow> Arrows;
  
  bow(element e, int AD, int AP) {
    Arrows = new ArrayList<arrow>();
    range = 150;
    damage = AD;
    elementStrength = AP;
    this.e = e;
  }
  
  public void attack(PVector start, PVector end) {
    arrow newArrow = new arrow(start, end);
    newArrow.calDirection();
    Arrows.add(newArrow);
  }
  
  void moveAttack() {
    //move arrow
    for (int i = 0; i < Arrows.size(); i++) {
      Arrows.get(i).move();
      //remove reach range arrow
      //calculate distance of tail and start
      float distX = Arrows.get(i).start.x - Arrows.get(i).tail.x;
      float distY = Arrows.get(i).start.y - Arrows.get(i).tail.y;
      //calculate distance
      float distance = sqrt((distX*distX) + (distY*distY));
      if (distance > range) {
        //remove this arrow
        Arrows.remove(i);
        i--;
      }
    }
  }
  //hit object
  public void hitObject(interActable inter) {
    for (int i = 0; i < Arrows.size(); i++) {
      if (Arrows.get(i).hitObject(inter)) {
        Arrows.remove(i);
        inter.takeDamage();        
        i--;
      }
    }
  }
  
  public void hitMovingObject(movingObject mo, movingObject source) {
    for (int i = 0; i < Arrows.size(); i++) {
      if (Arrows.get(i).hitMoveObject(mo)) {
        Arrows.remove(i);
        mo.takeDamage(source);
        i--;
      }
    }
  }
  //display arrows
  void display(color c) {
    for (int i = 0; i < Arrows.size(); i++) {
      Arrows.get(i).display(c);
    }
  }
  
  String toText() {   
    return e.name + " bow AD+" + damage + " AP+" + elementStrength; 
  }
}
