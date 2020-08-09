public class BossStatue extends interActable {
  
  boolean enabled;
  PImage img;
  
  BossStatue(int x, int y, int x_size, int y_size) {
    max_hit = 100;
    inRoom_x = x;
    inRoom_y = y;
    X_size = x_size;
    Y_size = y_size;
    opened = false;
    img = loadImage("image/bossStatue.jpg");
    enabled = false;
  }
  
  public void takeDamage() {
    return;
  }
  
  public void interAct(player MyPlayer) {
    //enable if player has emblem;
    if (!enabled) {
      if (MyPlayer.playerBag.EmblemNum > 0) {
        MyPlayer.playerBag.EmblemNum--;
        enabled = true;
        System.out.println("boss room opened");
      } else {
        System.out.println("you don't have emblem");
      }
    } else {
      System.out.println("Already activated");    
    }    
  }
  public void display() {
    imageMode(CENTER);
    image(img, inRoom_x, inRoom_y , X_size, Y_size);
  }
}

  
  
