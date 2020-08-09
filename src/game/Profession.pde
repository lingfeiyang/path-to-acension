abstract class Profession{
  
  Weapon w;
  //enfore an attack rate
  boolean attackLock;
  int lockStart;
  float attackSpeed; //mutiplier to get attack frequency
  
  abstract void attack(PVector start, PVector end, movingObject p);
  
  abstract void setWeapon(Weapon w);
  
}
