public class statue extends interActable{
  //statue always appear at center of the room
  PImage statueIMG;
  
  statue() {
    inRoom_x = width / 2;
    inRoom_y = height /2;
    X_size = 50;
    Y_size = 50;
    max_hit = 100;
    statueIMG = loadImage("image/statue.jpg");
  }
  //a statue cannot be destroyed, therefore take no damage
  public void takeDamage() {
    return;
  }
  //inter act options of statue
  public void interAct(player MyPlayer) {
    if (opened) {
      return;
    }
    int ran = randomNum(1, 100);
    if (ran <= 10) {//10% of bleeding
      bleed(MyPlayer);
    } else if (ran <= 20) {//10% chance of finding an emblem
      DropEmblem(MyPlayer);    
    } else if (ran <= 30) {//10% chance find a method
      DropMethod(MyPlayer);
    } else if (ran <= 40) {//10% chance get a permanent buff
      buffGeneration(MyPlayer);
    } else {
      System.out.println("nothing happened");
    }
    opened = true;
  }
  //apply bleeding
  public void bleed(player MyPlayer) {
    //loop see if player have a bleed effect
    //reset lenght if have one
    System.out.println("Its a trap, you start bleeding");
    for (int i = 0; i < MyPlayer.buffs.size(); i++) {
      if (MyPlayer.buffs.get(i) instanceof bleeding) {
        MyPlayer.buffs.get(i).resetDuration();
        return;
      }
    }
    //add one if not have one
    MyPlayer.buffs.add(new bleeding());
  }
  //drop emblem
  void DropEmblem(player MyPlayer) {
    MyPlayer.playerBag.EmblemNum++;
    System.out.println("You found an emble");
  }
  //drop a cultivation method
  public void DropMethod(player MyPlayer) {
    //the method's attribute will float around the equiped method attribute
    //element type is random
    //instead of passing the element array, do a number of turn of getting generation or overcoming of element
    element current = MyPlayer.CM.currentElement;
    int turns = randomNum(1, 10);
    for (int i = 0; i < turns; i++) {
      current = current.generation;
    }
    //generate float +-3
    cultivationMethod culti = new cultivationMethod(current, randomNum(MyPlayer.CM.elementStrength - 3, MyPlayer.CM.elementStrength + 3), randomNum(MyPlayer.CM.shieldBoost - 3, MyPlayer.CM.shieldBoost + 3));

    boolean added = false;
    //add to bag if bag not full
    for (int i = 0; i < MyPlayer.playerBag.methods.length; i++) {
      if (MyPlayer.playerBag.methods[i] == null) {
        MyPlayer.playerBag.methods[i] = culti;
        added = true;
        System.out.println("you acquire a " + culti.toText());
        break;
      }
    }
    //if bag full
    if (!added) {
      System.out.println("bag full, weapon destroied");
    }
  }
  //reveal a hidden portal
  public void openHidden() {
    System.out.println("A hidden portal revealed");
    
    
  }
  //add a permanent buff
  public void buffGeneration(player MyPlayer) {
    //random a strength of boost;
    int randomEffect = randomNum(1, 3);
    //random a type
    int type = randomNum(1, 5);
    buff boost = null;
    if (type == 1) {
      boost = new AD_boost(randomEffect);
    } else if (type == 2) {
      boost = new AP_boost(randomEffect);
    } else if (type == 3) {
      boost = new HP_boost(randomEffect);
    } else if (type == 4) {
      boost = new MP_boost(randomEffect);
    } else if (type == 5) {
      boost = new Shield_boost(randomEffect);
    }
    //add the buff to pernanment list
    if (boost == null) {
      System.out.println("add buff error");
      System.exit(0);
    } else {
      for (int i = 0; i < MyPlayer.permanentBuffs.size(); i++) {
        //find same instance of buff
        if (boost.getClass() == (MyPlayer.permanentBuffs.get(i)).getClass()) {
          //apply new boost part
          boost.applyEffect(MyPlayer);
          //then add effect to instance in list rather than adding a new instance
          MyPlayer.permanentBuffs.get(i).effect = MyPlayer.permanentBuffs.get(i).effect + boost.effect;
        }
      }
    }  
  }
  void display() {
    imageMode(CENTER);
    image(statueIMG, inRoom_x, inRoom_y , X_size, Y_size);
  }
  //random number
  int randomNum(float min, float max) {
    return (int)((Math.random() * ((max - min) + 1)) + min);
  }
}
