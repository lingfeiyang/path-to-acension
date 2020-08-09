abstract class Weapon{
  
  element e;  
  int range;
  int damage;
  int elementStrength;
  //fire a bullet
  abstract void attack(PVector start, PVector end);
  //move bullet
  abstract void moveAttack();
  //display bullets
  abstract void display(color c);
  //hit object
  abstract void hitObject(interActable inter);
  //hit player/enemy
  abstract void hitMovingObject(movingObject target, movingObject source);
  //to string
  abstract String toText();
}
