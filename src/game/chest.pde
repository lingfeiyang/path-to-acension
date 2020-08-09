public class chest extends interActable{
  //a chest always drop gold and potion, a tiny chance drop a gear
  PImage closedChest;
  PImage openedChest;

  chest() {
    closedChest = loadImage("image/closed_chest.png");
    openedChest = loadImage("image/opened_chest.png");
    opened = false;
    X_size = 40;
    Y_size = 40;
    max_hit = 5;
  }
  
  public void takeDamage() {
    max_hit--;
  }
  
  public void interAct(player MyPlayer) {
    if (opened) {
      return;
    }
    //100% chance drop potion
    DropPotion(MyPlayer);  
    //10% chance drop a weapon
    if (randomNum(1, 100) <= 10) {
      DropWeapon();
    }  
    opened = true;
  }
  //drop 1-2 type potion, do two times so chance to drop different potions
  public void DropPotion(player MyPlayer) {
    //random a dropNum
    int dropNum1 = randomNum(1, 2);
    int dropNum2 = randomNum(1, 2);
    //random a slot(type) of potion
    int type1 = randomNum(0, MyPlayer.playerBag.useSlots.length - 1);
    int type2 = randomNum(0, MyPlayer.playerBag.useSlots.length - 1);
    MyPlayer.playerBag.useSlots[type1].acquire(dropNum1);
    MyPlayer.playerBag.useSlots[type2].acquire(dropNum2);
  }
  //drop a weapon
  public void DropWeapon() {
    //the weapon's attribute will float around the equiped weapon attribute
    //weapon type is random
    int type = randomNum(1, 3);
    //element type is random
    //instead of passing the element array, do a number of turn of getting generation or overcoming of element of current weapon
    element current = MyPlayer.pro.w.e;
    int turns = randomNum(1, 10);
    for (int i = 0; i < turns; i++) {
      current = current.generation;
    }
    //generate float +-3
    Weapon lootWeapon = null;
    if (type == 1) {//bow
      lootWeapon = new bow(current, randomNum(MyPlayer.pro.w.damage - 3, MyPlayer.pro.w.damage + 3), randomNum(MyPlayer.pro.w.elementStrength - 3, MyPlayer.pro.w.elementStrength + 3));
    } else if (type == 2) {//hammer
      lootWeapon = new hammer(current, randomNum(MyPlayer.pro.w.damage - 3, MyPlayer.pro.w.damage + 3), randomNum(MyPlayer.pro.w.elementStrength - 3, MyPlayer.pro.w.elementStrength + 3));
    } else if (type == 3) {//wand
      lootWeapon = new wand(current, randomNum(MyPlayer.pro.w.damage - 3, MyPlayer.pro.w.damage + 3), randomNum(MyPlayer.pro.w.elementStrength - 3, MyPlayer.pro.w.elementStrength + 3));
    }
    if (lootWeapon == null) {
      System.out.println("drop weapon error");
      System.exit(1);
    } else {
      boolean added = false;
      //add weapon to bag if bag not full
      for (int i = 0; i < MyPlayer.playerBag.LootWeapons.length; i++) {
        if (MyPlayer.playerBag.LootWeapons[i] == null) {
          MyPlayer.playerBag.LootWeapons[i] = lootWeapon;
          added = true;
          System.out.println("you acquire a " + lootWeapon.toText());
          break;
        }
      }
      //if bag full
      if (!added) {
        System.out.println("bag full, weapon destroied");
      }
    }   
  }
  //display
  public void display() {
    imageMode(CENTER);
    if(!opened) {
      image(closedChest, inRoom_x, inRoom_y , X_size, Y_size);
    } else {
      image(openedChest, inRoom_x, inRoom_y , X_size, Y_size);
    }
  }
  //random number
  int randomNum(float min, float max) {
    return (int)((Math.random() * ((max - min) + 1)) + min);
  }
}
