public class bleeding extends buff{
  
  int rate;       //rate of hp loss in secs, 1 sec = 1 framRate
  boolean lock;
  int lockStart;
  
  bleeding () {
    effect = 1;
    duration = 15;
    rate = 1;
    lock = false;
    System.out.println("you are bleeding");
  }
  
  public void applyEffect(player p) {
    if (!lock) {
      p.hp.applyChange(-1 * effect);
      duration--;
      lock = true;
      lockStart = frameCount;
    } else {
      if (frameCount >= lockStart + rate * frameRate) {
        lock = false;
      }
    } 
  }
  //reset duration
  public void resetDuration() {
    duration = 30;
  }
}
