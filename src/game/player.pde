class player extends movingObject{
  
  int interActRange;
  bag playerBag;
  ArrayList<buff> buffs;
  ArrayList<buff> permanentBuffs;
  room playRoom;
  interActable targetObject;
  race Race;
 
  player() {
    position = new PVector();
    direction = new PVector();
    size = 20;
    interActRange = 75;
    playerBag = new bag();
    hp = new hitPoint();
    mp = new manaPoint();
    Shield = new shield();
    buffs = new ArrayList<buff>();
    permanentBuffs = new ArrayList<buff>();
    targetObject = null;
    enchanted = false;
    //for test modify attributes
    
    hp.current_HP = 50;
    mp.current_MP = 50;
    Shield.current_shield = 50;
    buffs.add(new bleeding());
    
  }
  //set race of player
  void setRace(race Race) {
    this.Race = Race;
    Race.ModifyAttributes(this);
  }
  //set profession
  void setPro(Profession pro) {
    this.pro = pro;
  }
  void setCultivationMethod(cultivationMethod CM) {
    this.CM = CM;
  }
  //calculate total physical and magical damage can deal
  void CalTotalPhysicDamage() {
    totalPhysicDamage = Race.damage + pro.w.damage;
    //apply ad buff
    for (int i = 0; i < permanentBuffs.size(); i++) {
      if (permanentBuffs.get(i) instanceof AD_boost) {
        totalPhysicDamage = totalPhysicDamage + permanentBuffs.get(i).effect;
      }
    }
  }
  
  void CalTotalMagicDamage() {
    if (CM.currentElement == pro.w.e) {
      totalMagicDamage = Race.elementStrength + pro.w.elementStrength + CM.elementStrength;
    } else if (CM.currentElement == pro.w.e.overcoming) {
      totalMagicDamage = Race.elementStrength - pro.w.elementStrength + CM.elementStrength;
    } else if (CM.currentElement == pro.w.e.generation) {
      totalMagicDamage = Race.elementStrength + 2 * pro.w.elementStrength + CM.elementStrength;
    } else {
      totalMagicDamage = Race.elementStrength + CM.elementStrength;
    }
    //apply buff
    for (int i = 0; i < permanentBuffs.size(); i++) {
      if (permanentBuffs.get(i) instanceof AP_boost) {
        totalMagicDamage = totalMagicDamage + permanentBuffs.get(i).effect;
      }
    }
  }
  //calculate damage
  void takeDamage(movingObject source) {
    int baseAD = source.totalPhysicDamage;
    int baseAP = source.totalMagicDamage;
    int totalDamage;
    if (source.enchanted) {
      totalDamage = baseAD + baseAP;
      if (source.CM.currentElement == CM.currentElement.overcoming) {//attacker overcome
        totalDamage = totalDamage * 2;//double damage
        //deal damage to shield first
        if (Shield.current_shield > 0) {//shield not broken
          Shield.current_shield = Shield.current_shield - totalDamage;
          if (Shield.current_shield < 0) {//take excessive damage when break
            Shield.current_shield = 0;
          }
        } else {
          hp.current_HP = hp.current_HP - totalDamage;
          //50% chance bleeding
          if (randomNum(1, 100) <= 50) {
            buffs.add(new bleeding());
          }
        }
      } else if (source.CM.currentElement == CM.currentElement.generation) {//attacker generate
        Shield.current_shield = Shield.current_shield + totalDamage;
        if (Shield.current_shield > Shield.max_shield) {//generate
            Shield.current_shield = Shield.max_shield;
        }
      } else {//other
        //deal damage to shield first
        if (Shield.current_shield > 0) {//shield not broken
          Shield.current_shield = Shield.current_shield - totalDamage;
          if (Shield.current_shield < 0) {//take excessive damage when break
            Shield.current_shield = 0;
          }
        } else {
          hp.current_HP = hp.current_HP - totalDamage;
          //50% chance bleeding
          if (randomNum(1, 100) <= 50) {
            buffs.add(new bleeding());
          }
        }
      }
    } else {//not enchanted
      totalDamage = baseAD;
      //deal damage to shield first
      if (Shield.current_shield > 0) {//shield not broken
        Shield.current_shield = Shield.current_shield - totalDamage;
        if (Shield.current_shield < 0) {//take excessive damage when break
          Shield.current_shield = 0;
        }
      } else {
        hp.current_HP = hp.current_HP - totalDamage;
        //50% chance bleeding
        if (randomNum(1, 100) <= 50) {
          buffs.add(new bleeding());
        }
      }
    }
  }
  //charge shield
  void chargeShield() {
    if (mp.current_MP > 0 && Shield.current_shield < Shield.max_shield) {
      mp.current_MP--;
      Shield.current_shield = Shield.current_shield + 2;
      if (Shield.current_shield > Shield.max_shield) {
        Shield.current_shield = Shield.max_shield;
      }
    }
  }
  //move
  void move() {
    position = position.add(direction);
    //not out of bound of room
    //x
    if (position.x > width / 2 + playRoom.X_size / 2 - size / 2) {//right out
      position.x = width / 2 + playRoom.X_size / 2 - size / 2;
    } else if (position.x < width / 2 - playRoom.X_size / 2 + size / 2) {//left out
      position.x = width / 2 - playRoom.X_size / 2 + size / 2;
    }
    //y
    if (position.y > height / 2 + playRoom.Y_size / 2 - size / 2) {//down out
      position.y = height / 2 + playRoom.Y_size / 2 - size / 2;
    } else if (position.y < height / 2 - playRoom.Y_size / 2 + size / 2) {//up out
      position.y = height / 2 - playRoom.Y_size / 2 + size / 2;
    }
  }
  //calculate move of a player   
  void CalDirection(boolean[] keys) {
     PVector temp = new PVector();
     //player not move if opposite direction pressed at same time
     if (keys[0] && keys[1]) {
       temp.y = 0;
     } else {
       if (keys[0]) {//up
         temp.y = -1;
       }
       if (keys[1]) {//down
         temp.y = 1;
       }
     }     
     if (keys[2] && keys[3]) {
       temp.x = 0;
     } else {
       if (keys[2]) {//left
         temp.x = -1;
       }
       if (keys[3]) {//right
         temp.x = 1;
       }
     }
     direction = temp;
  }
  //launch an attack using the weapon in hand
  //attack frequency = 1/s (using frame rate and frame count as standard)
  void attack(PVector start, PVector end) {
    pro.attack(start, end, this);
  }
  //move attack
  void moveAttack() {
    if (frameCount % 2 == 0) {
      pro.w.moveAttack();
    }  
  }
  //hit object
  public void hitObject() {
    for (int i = 0; i < playRoom.interActables.size(); i++) {
      pro.w.hitObject(playRoom.interActables.get(i));
      if (playRoom.interActables.get(i).max_hit <= 0) {
        playRoom.interActables.remove(i);
        i--;
      }
    }
  }
  
  public void hitMovingObject() {
    for (int i = 0; i < playRoom.enemies.size(); i++) {
      pro.w.hitMovingObject(playRoom.enemies.get(i), this);
      if (playRoom.enemies.get(i).hp.current_HP <= 0) {
        playRoom.enemies.remove(i);
        i--;
      }
    }
  }
  //add buff
  void addBuff(buff b) {
    buffs.add(b);
  }
  //apply buff effect
  void buffEffect() {
    for (int i = 0; i < buffs.size(); i++) {
      if (buffs.get(i).duration > 0) {
        buffs.get(i).applyEffect(this);
      } else {
        buffs.remove(i);
        i--;
      }
    }
  }
  //add a buff that can be passed to children
  void addPermanent(buff b) {  
    permanentBuffs.add(b);
  }
  //switch type of element of cultivation method
  void switchElement() {
    CM.currentElement = CM.currentElement.generation; 
  }
  //display player
  void display() {
    stroke(CM.currentElement.elementColour);
    strokeWeight(2);
    fill(255);
    ellipseMode(CENTER);
    ellipse(position.x, position.y, size, size);
  }
  //display attack
  void displayAttack() {
    pro.w.display(CM.currentElement.elementColour);
  }
  //display information
  void displayInfo() {
    //player attributes
    String health = "HP: " + hp.current_HP;
    String mana = "MP: " + mp.current_MP;
    String c_shield = "shield: " + Shield.current_shield;
    String AD = "AD: " + totalPhysicDamage;
    String AP = "AP: " + totalMagicDamage;
    //usable slot
    String bagSlot1 = playerBag.useSlots[0].p.Name + " X " + playerBag.useSlots[0].usableNum;
    String bagSlot2 = playerBag.useSlots[1].p.Name + " X " +playerBag.useSlots[1].usableNum;
    String bagSlot3 = playerBag.useSlots[2].p.Name + " X " +playerBag.useSlots[2].usableNum;
    textSize(15);
    fill(0);
    text(health, 5, 15);
    text(mana, 5, 30);
    text(c_shield, 5, 45);
    text(AD, 5, 60);
    text(AP, 5, 75);
    text(bagSlot1, 5, 90);
    text(bagSlot2, 5, 105);
    text(bagSlot3, 5, 120);
    //display buff
  }
}
