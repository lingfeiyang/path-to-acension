public class mage extends Profession{
  
  mage(element e, int AD, int AP) {
    w = new wand(e, AD, AP);
    attackLock = false;
    attackSpeed = 1.0;
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
      if (frameCount >= lockStart + attackSpeed * frameRate) {
        attackLock = false;
      }
    } 
  }
  
  void setWeapon(Weapon w) {
    if (w instanceof wand) {
      this.w = w;
    } else {
      System.out.println("you can only equip wand");
    }
  }
}
