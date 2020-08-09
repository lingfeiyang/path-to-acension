class room{
  
  int room_id;
  //room in play always shown at center of screen
  //place it appear on map
  int Map_X;
  int Map_Y;
  int X_size;
  int Y_size;
  //list of portals
  ArrayList<portal> Portals;
  ArrayList<interActable> interActables;
  ArrayList<obstacle> obstacles;
  ArrayList<enemy> enemies;
  
  boolean visited;
  element e;
  
  room(int id, int X_size, int Y_size) {
    room_id = id;
    this.X_size = X_size;
    this.Y_size = Y_size;
    Portals = new ArrayList<portal>();
    interActables = new ArrayList<interActable>();
    obstacles = new ArrayList<obstacle>();
    enemies = new ArrayList<enemy>();
    visited = false;
    e = null;
  }
  //return all connections as room object
  ArrayList<room> getConnections() {
    ArrayList<room> temp = new ArrayList<room>();
    for (int i = 0; i < Portals.size(); i++) {
      temp.add(Portals.get(i).target);
    }
    return temp;
  }
  //return the closet interActable
  void highLightClosetInterActable(player MyPlayer) {
    float closestDistance = MyPlayer.interActRange;
    interActable closest = null;
    //find the closest object
    if (!interActables.isEmpty()) {    
      for (int i = 0; i < interActables.size(); i++) {
        float distX = interActables.get(i).inRoom_x - MyPlayer.position.x;
        float distY = interActables.get(i).inRoom_y - MyPlayer.position.y;
        //distance must greater than sum of two radius
        float distance = sqrt((distX*distX) + (distY*distY));
        if (distance <= closestDistance) {
          if (!interActables.get(i).opened) {
            closest = interActables.get(i);
            closestDistance = distance;
          }
        }
      }
    }
    MyPlayer.targetObject = closest;
    //highlight the stroke of it
    if (closest != null && !closest.opened) {//in case no object in range
      //cover with a transparent same size rectangle but a thick purple stroke    
      stroke(255, 0, 255);
      strokeWeight(3);
      fill(0, 0, 0, 0);
      rectMode(CENTER);
      rect(closest.inRoom_x, closest.inRoom_y, closest.X_size, closest.Y_size);
    }
  }
  void enemyAttack(player p) {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).attack(p);
    }
  }
  //if enemy hit player
  void hitPlayer(player p) {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).pro.w.hitMovingObject(p, enemies.get(i));
    }
  }
  //move enemy
  void MoveEnemy(player p) {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).CalDirection(p);
      enemies.get(i).move(this);
    }
  }
  //move enemy attack
  void MoveEnemyAttack() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).moveAttack();
    }
  }
  //display room
  void display() {
    if (e != null) {
      stroke(e.elementColour);
      strokeWeight(5);
    } else {
      stroke(0);
      strokeWeight(1);
    }  
    fill(255);
    rectMode(CENTER);
    rect(width / 2, height / 2, X_size, Y_size);
  }
  //display portal
  void displayPortal() {
    for (int i = 0; i < Portals.size(); i++) {
      Portals.get(i).display();
    }
  }
  //display objects
  void displayInterActable() {
    for (int i = 0; i < interActables.size(); i++) {
      interActables.get(i).display();
    }
  }
  //display enemies
  void displayEnemies() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).display();
    }
  }
  //display enemy attacks
  void displayEnemyAttack() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).displayAttack();
    }
  }
}
