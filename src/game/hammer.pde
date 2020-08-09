public class hammer extends Weapon{
  
  ArrayList<swing> Swings;
  
  hammer(element e, int AD, int AP) {
    Swings = new ArrayList<swing>();
    range = 30;
    damage = AD;
    elementStrength = AP;
    this.e = e;
  }
  
  public void attack(PVector start, PVector end) {
    swing newSwing = new swing(start, end, range);
    newSwing.calDirection();
    Swings.add(newSwing);
  }
  
  public void moveAttack() {
    //enlarge blast
    for (int i = 0; i < Swings.size(); i++) {
      Swings.get(i).move();
      //remove max size blast 
      if (Swings.get(i).current_size > Swings.get(i).max_size) {
        //remove this arrow
        Swings.remove(i);
        i--;
      }
    }
  }

  public void hitObject(interActable inter) {
    for (int i = 0; i < Swings.size(); i++) {
      if (Swings.get(i).hitObject(inter)) {
        inter.takeDamage();
      }
    }
  }
  
  public void hitMovingObject(movingObject mo, movingObject source) {
    for (int i = 0; i < Swings.size(); i++) {
      if (Swings.get(i).hitMoveObject(mo)) {
        Swings.remove(i);
        mo.takeDamage(source);
        i--;
      }
    }
  }
  //display swings
  public void display(color c) {
    for (int i = 0; i < Swings.size(); i++) {
      Swings.get(i).display(c);
    }
  }
  
  String toText() {   
    return e.name + " hammer AD+" + damage + " AP+" + elementStrength; 
  }
}
