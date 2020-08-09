public class warrior extends Profession{
  
  warrior(element e, int AD, int AP) {
    w = new hammer(e, AD, AP);
    attackLock = false;
    attackSpeed = 0.5;
  }
  
  public void attack(PVector start, PVector end, movingObject p) {
    if (!attackLock) {
      w.attack(start, end);
      if (p.enchanted) {
        if (p.mp.current_MP > 0) {
          p.mp.applyChange(-2);
        } else {
          p.enchanted = false;
        }
      }
      attackLock = true;
      lockStart = frameCount;
    } else {
      if (frameCount >= lockStart + attackSpeed + frameRate) {
        attackLock = false;
      }
    } 
  }
  
  void setWeapon(Weapon w) {
    if (w instanceof hammer) {
      this.w = w;
    } else {
      System.out.println("you can only equip hammer");
    }
  }
}
