abstract class bullet{
  
  PVector start;      //start position
  PVector end;        //end position
  PVector direction;  //direction(unit vector), an arrow has 5 unit vector
  //calculate direction/facing of the attact
  abstract void calDirection();
  //move the bullect
  abstract void move();
  //display the bullet
  abstract void display(color c);
  //hit an interActable object
  abstract boolean hitObject(interActable inter);
  //hit player/enemy
  abstract boolean hitMoveObject(movingObject mo);
}
