public class crate extends interActable{
  //a crate only drops gold and potion
  PImage closedCrate;
  PImage openedCrate;
  
  crate() {
    closedCrate = loadImage("image/closedCrate.png");
    openedCrate = loadImage("image/openedCrate.jpg");
    opened = false;
    X_size = 30;
    Y_size = 30;
    max_hit = 3;
  }
  
  public void takeDamage() {
    max_hit--;
  }
  
  public void interAct(player MyPlayer) {
    if (opened) {
      return;
    }
    //50% chance drop 1-2potion
    if (randomNum(1, 100) <= 50) {
      DropPotion(MyPlayer);
    } else {
      System.out.println("you found nothing");
    }
    opened = true;
  }
  //drop 1-2 same type potion
  public void DropPotion(player MyPlayer) {
    //random a dropNum
    int dropNum = randomNum(1, 2);
    //random a slot(type) of potion
    int type = randomNum(0, MyPlayer.playerBag.useSlots.length - 1);
    MyPlayer.playerBag.useSlots[type].acquire(dropNum);
  }
  //display
  public void display() {
    imageMode(CENTER);
    if(!opened) {
      image(closedCrate, inRoom_x, inRoom_y , X_size, Y_size);
    } else {
      image(openedCrate, inRoom_x, inRoom_y , X_size, Y_size);
    }
  }
  //random number
  int randomNum(float min, float max) {
    return (int)((Math.random() * ((max - min) + 1)) + min);
  }
}
