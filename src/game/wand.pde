public class wand extends Weapon {
  
  ArrayList<magicBall> MagicBalls;
  
  wand(element e, int AD, int AP) {
    MagicBalls = new ArrayList<magicBall>();
    range = 200;
    damage = AD;
    elementStrength = AP;
    this.e = e;
  }
  //add new attack
  public void attack(PVector start, PVector end) {
    magicBall newBall = new magicBall(start, end);
    newBall.calDirection();
    MagicBalls.add(newBall);
  }
  //move magic balls
  public void moveAttack() {
    //move arrow
    for (int i = 0; i < MagicBalls.size(); i++) {
      MagicBalls.get(i).move();
      //remove reach range arrow
      //calculate distance of tail and start
      float distX = MagicBalls.get(i).start.x - MagicBalls.get(i).current.x;
      float distY = MagicBalls.get(i).start.y - MagicBalls.get(i).current.y;
      //calculate distance
      float distance = sqrt( (distX*distX) + (distY*distY));
      if (distance > range || distance > MagicBalls.get(i).TargetedDistance) {
        //remove this arrow
        MagicBalls.remove(i);
        i--;
      }
    }
  }

  public void hitObject(interActable inter) {
    for (int i = 0; i < MagicBalls.size(); i++) {
      if (MagicBalls.get(i).hitObject(inter)) {
        MagicBalls.remove(i);
        inter.takeDamage();        
        i--;
      }
    }
  }
  
  public void hitMovingObject(movingObject mo, movingObject source) {
    for (int i = 0; i < MagicBalls.size(); i++) {
      if (MagicBalls.get(i).hitMoveObject(mo)) {
        MagicBalls.remove(i);
        mo.takeDamage(source);
        i--;
      }
    }
  }
  //display all magic balls
  public void display(color c) {
    for (int i = 0; i < MagicBalls.size(); i++) {
      MagicBalls.get(i).display(c);
    }
  }
  
  String toText() {   
    return e.name + " wand AD+" + damage + " AP+" + elementStrength; 
  }
}
