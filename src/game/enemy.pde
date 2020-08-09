public class enemy extends movingObject{
  
  int senseRadius;
  int turnChance = 0;//a define a chance for enemy to change direction, increase by not turning.
  
  enemy(cultivationMethod CM, Profession pro) {
    position = new PVector();
    direction = new PVector();
    hp = new hitPoint();
    mp = new manaPoint();
    Shield = new shield();
    this.CM = CM;
    this.pro = pro;
    size = 20;
    senseRadius = 250;
    enchanted = true;//enemy always use enchanted attack, but not able to recover
  }
  //adjust attribute
  void adjustAttributes(player p) {
    hp.max_HP = randomNum(p.hp.max_HP - 25, p.hp.max_HP + 25);
    mp.max_MP = randomNum(p.mp.max_MP - 25, p.mp.max_MP + 25);
    Shield.max_shield = randomNum(p.Shield.max_shield - 25, p.Shield.max_shield + 25);
    hp.current_HP = hp.max_HP;
    mp.current_MP = mp.max_MP;
    Shield.current_shield = Shield.max_shield;
    p.CalTotalPhysicDamage();
    p.CalTotalMagicDamage();
    totalPhysicDamage = randomNum(p.totalPhysicDamage - 10, p.totalPhysicDamage + 10);
    totalMagicDamage = randomNum(p.totalMagicDamage - 10, p.totalMagicDamage + 10);
  }
  //calulate a direction
  void CalDirection(player p) {
    //see if player in sense
    Point_Circle_Collision_Checker PC = new Point_Circle_Collision_Checker();
    if (PC.Check(p.position.x, p.position.y, position.x, position.y, senseRadius)) {//in radius
      //construct a rectangle using coordinates of player and enemy's attack range and pick a point inside it
      float Xmax, Xmin, Ymax, Ymin;     
      Xmax = p.position.x + pro.w.range;
      Xmin = p.position.x - pro.w.range;
      Ymax = p.position.y + pro.w.range;
      Ymin = p.position.y - pro.w.range;
      if (Xmax > width) {
        Xmax = width;
      } else if (Xmin < 0) {
        Xmin = 0;
      }
      if (Ymax > height) {
        Ymax = height;
      } else if (Ymin < 0) {
        Ymin = 0;
      }
      int randomX = randomNum(Xmin, Xmax);
      int randomY = randomNum(Ymin, Ymax);
      
      if (randomNum(1, 3 * frameRate) <= turnChance) {
        //calculate a ratio of moving vertically and horizontally using linear formula y = ax + b
        //using y direction as unit, so y of velocity 1
        if (position.y > randomY) {
          direction = new PVector((randomX - position.x) / (position.y - randomY), -1);
        } else if (position.y < randomY) {
          direction = new PVector((position.x - randomX) / (position.y - randomY), 1);
        } else {
          direction = new PVector(randomX - position.x, 0);
        }
        //get unit vector of direction
        direction.normalize();
        //if player not in attack range, double speed
        float distX = position.x - p.position.x;
        float distY = position.y - p.position.y;
        //distance must greater than sum of two radius
        float distance = sqrt((distX*distX) + (distY*distY));
        if (distance > pro.w.range) {
          direction.mult(2);
        }
        turnChance = 0;
       } else {
         turnChance++;
       }   
    } else {//wander around
      //use an int array to map moving
      //0 as positive direction, 1 as negative
      //first int as in x, second y
      int[] dir = new int[2];
       dir[0] = randomNum(0, 1);
       dir[1] = randomNum(0, 1);
       //must turn when not turn for 3 secs
       if (randomNum(1, 3 * frameRate) <= turnChance) {
         //change direction
         if (dir[0] == 0) {
           direction.x = 1;
         } else {
           direction.x = -1;
         }
         if (dir[1] == 0) {
           direction.y = 1;
         } else {
           direction.y = -1;
         }
         turnChance = 0;
       } else {
         turnChance++;
       }
    }     
  }
  //move
  void move(room r) {
    position = position.add(direction);
    //not out of bound of room
    //x
    if (position.x > width / 2 + r.X_size / 2 - size / 2) {//right out
      position.x = width / 2 + r.X_size / 2 - size / 2;
    } else if (position.x < width / 2 - r.X_size / 2 + size / 2) {//left out
      position.x = width / 2 - r.X_size / 2 + size / 2;
    }
    //y
    if (position.y > height / 2 + r.Y_size / 2 - size / 2) {//down out
      position.y = height / 2 + r.Y_size / 2 - size / 2;
    } else if (position.y < height / 2 - r.Y_size / 2 + size / 2) {//up out
      position.y = height / 2 - r.Y_size / 2 + size / 2;
    }
  }
  //attack
  void attack(player p) {
    //lauch attack if in range
    float distX = position.x - p.position.x;
    float distY = position.y - p.position.y;
    //distance must greater than sum of two radius
    float distance = sqrt((distX*distX) + (distY*distY));
    if (distance <= pro.w.range) {
      pro.attack(position, p.position, this);
    }
  }
  //move attack
  void moveAttack() {
    if (frameCount % 2 == 0) {
      pro.w.moveAttack();
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
      }
    }
  }
  //display
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
  //random number
  int randomNum(float min, float max) {
    return (int)((Math.random() * ((max - min) + 1)) + min);
  }
}
