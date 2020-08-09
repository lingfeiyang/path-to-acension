import java.util.LinkedList;
import java.util.Queue;
//colour of elements
color grey = color(130);
color green = color(0 ,200 , 0);
color black = color(0);
color red = color(200, 0, 0);
color yellow = color(200, 200, 0);
//player
boolean moveKey[];//hot key for moving
player MyPlayer;
player oldPlayer;//storing data of last generation for passing resourse to ne player
//rooms
int Base_RoomNo = 15;
ArrayList<room> Rooms;
room startRoom;
room endRoom;
room BossRoom;
//map
map Map;
//elements
element metal;
element wood;
element water;
element fire;
element earth;
element elements[];//store elements in array for random pick
//flags for game flow
newGeneration NG;//player died, start a new round of generateion, a wrapped up class of flags
boolean mapActive;//does the player ask for map?
boolean mapFinish;//current play map is finished (leave from end room/die)
boolean bagActive;//is plaer using bag?
boolean mapGenerated;//is map generated? 

void setup() {
  //background set up
  frameRate(120);
  size(1500,1000);
  background(100);
  //set up elements
  initElements();
  //initial flages;
  mapActive = false;
  mapFinish = true;
  bagActive = false;
  mapGenerated = false;
  NG = new newGeneration();
  //create objects for declaration
  Rooms = new ArrayList<room>();
  moveKey = new boolean[4];
  oldPlayer = null;
  //creat start room and end room
  CreateStartRoom();
  CreateBossRoom();
}

void draw() {
  background(100);
  
  if (!NG.complete) {//a new round of generation reset/setup stuff
    //set up a new player
    SetUpPlayer();
    //newGeneration = false;
  } else {
    //if a game is finish, create new map, use flag to make generation only execute once
    if (MyPlayer.playRoom == startRoom && !mapGenerated) {
      //remove all rooms
      Rooms.clear();
      //create new room
      initRooms();
      //attach end room
      CreateEndRoom();
      //place objects
      placeObjects();
      //place enemies, -1 as last room is end room
      for (int i = 0; i < Rooms.size() - 1; i++) {
        placeEnemy(Rooms.get(i));
      }    
      //set up start room gate teleport target
      setStartRoomTarget();
      //map finish initialising
      mapGenerated = true;
      Map = new map(Rooms);
      //target to boss room
      System.out.println(((BossStatue)startRoom.interActables.get(1)).enabled);
      if (((BossStatue)startRoom.interActables.get(1)).enabled) {
        ((gate)startRoom.interActables.get(0)).targetRoom = BossRoom;
        ((gate)startRoom.interActables.get(0)).targetX = width / 2;
        ((gate)startRoom.interActables.get(0)).targetY = height / 2;       
      }
    } else {
      //reset generate map flag when play leave start room
      if (MyPlayer.playRoom != startRoom) {
        mapGenerated = false;
      }
      if (mapActive) {
        Map.display(MyPlayer.playRoom);     
      } else if (bagActive) {
        MyPlayer.playerBag.display();
      } else {
        //display contents first
        //display room contents
        MyPlayer.playRoom.display();
        MyPlayer.playRoom.displayPortal();
        MyPlayer.playRoom.displayInterActable();
        MyPlayer.playRoom.highLightClosetInterActable(MyPlayer);
        MyPlayer.displayInfo();
        //display player position
        MyPlayer.display();   
        //display enemy postions
        MyPlayer.playRoom.displayEnemies();
        //display player attacts positions
        MyPlayer.displayAttack();
        //display enemy attack positions
        MyPlayer.playRoom.displayEnemyAttack();   
        //calculate palyer direction
        MyPlayer.CalDirection(moveKey);
        //check the move of player ever collide object, reset direction if collide
        MyPlayer.direction = checkCollideObject(MyPlayer.playRoom, MyPlayer.position.x, MyPlayer.position.y, MyPlayer.direction.x, MyPlayer.direction.y, MyPlayer.size);
        //move player
        MyPlayer.move();
        //move enemies
        MyPlayer.playRoom.MoveEnemy(MyPlayer);
        //move player attact
        MyPlayer.moveAttack();
        //check player attack hit object
        MyPlayer.hitObject();
        /*
        //************************problems*******************
        //move enemy attack
        MyPlayer.playRoom.MoveEnemyAttack();
        
              
        MyPlayer.hitMovingObject();
        //check enemy attack
        MyPlayer.playRoom.hitPlayer(MyPlayer);
        //enemy launch attack
        MyPlayer.playRoom.enemyAttack(MyPlayer);
        //***********************************************
        */
        //check if the player is captured

        
        //player buff effects
        MyPlayer.buffEffect();
        //check if player died
        if (MyPlayer.hp.current_HP <= 0) {
          //start new generation
          System.out.println("you died");
          NG = new newGeneration();
        }
      }       
    } 
  }
}
//***************************************************************************Control************************************************
//control schema for player, w,a,s,d for moving
//m for map, b for bag, tab for teleport when on portal
void keyPressed() {
  if (NG.complete) {
    //in game play
    //move keys
    if (key == 'w') {
      moveKey[0] = true;
    } else if (key == 's') {
      moveKey[1] = true;
    } else if (key == 'a') {
      moveKey[2] = true;
    } else if (key == 'd') {
      moveKey[3] = true;
    } else if (key == 'm') {
      if (!mapActive) {
        mapActive = true;
      } else {
        mapActive = false;
      }
    } else if (key == 'b') {
      if (!bagActive) {
        bagActive = true;
      } else {
        bagActive = false;
      }
    } 
    //interaction key
    if (key == 'e') {
      if (MyPlayer.targetObject != null) {
        MyPlayer.targetObject.interAct(MyPlayer);
        MyPlayer.targetObject = null;
      }  
    }
    //enable/disable enchant attack
    if (key == 'q') {
      if (MyPlayer.enchanted) {
        MyPlayer.enchanted = false;
      } else {
        MyPlayer.enchanted = true;
      }
    }
    if (key == 'c') {
      MyPlayer.chargeShield();
    }
    //teleport key
    if (key == 9) {//ascii for tab
      teleport();
    }
    //usables
    if (key == '1') {
      MyPlayer.playerBag.useSlots[0].consume();
    } else if (key == '2') {
      MyPlayer.playerBag.useSlots[1].consume();
    } else if (key == '3') {
      MyPlayer.playerBag.useSlots[2].consume();
    }
  //in new player set up  
  } else {
    //chose race
    if (!NG.raceChosen) {
      if (key == '1') {
        //human
        MyPlayer.setRace(new human());
        System.out.println("you choose " + NG.races[0]);
        NG.raceChosen = true;
      } else if (key == '2') {
        //wilding
        MyPlayer.setRace(new wildling());
        System.out.println("you choose " + NG.races[1]);
        NG.raceChosen = true;
      } else if (key == '3') {
        //spirit
        MyPlayer.setRace(new spirit());
        System.out.println("you choose " + NG.races[2]);
        NG.raceChosen = true;
      }
    //chose profession
    } else if (!NG.proChosen) {
      if (key == '1') {
        //archer
        MyPlayer.setPro(new archer(elements[randomNum(0, 4)], randomNum(5,15), randomNum(5,10)));
        System.out.println("you choose " + NG.pros[0]);
        NG.proChosen = true;
      } else if (key == '2') {
        //mage
        MyPlayer.setPro(new mage(elements[randomNum(0, 4)], randomNum(5,10), randomNum(5,15)));
        System.out.println("you choose " + NG.pros[1]);
        NG.proChosen = true;
      } else if (key == '3') {
        //warrior
        MyPlayer.setPro(new warrior(elements[randomNum(0, 4)], randomNum(5,20), randomNum(1, 5)));
        System.out.println("you choose " + NG.pros[2]);
        NG.proChosen = true;
      }
    } 
  }
}

void keyReleased() {
  if (key == 'w') {
    moveKey[0] = false;
  } else if (key == 's') {
    moveKey[1] = false;
  } else if (key == 'a') {
    moveKey[2] = false;
  } else if (key == 'd') {
    moveKey[3] = false;
  }
}

void mousePressed() {
  if (NG.complete) {
    if (mouseButton == LEFT) {
      MyPlayer.attack(new PVector(MyPlayer.position.x, MyPlayer.position.y), new PVector(mouseX, mouseY));
    }
  }
}
//roll to switch element
void mouseWheel(MouseEvent event) {
  if (NG.complete) {
    if (event.getCount() > 0) {
      MyPlayer.switchElement();
      MyPlayer.CalTotalMagicDamage();
    }
  }
}
//map drag place
void mouseDragged() {
  if (mapActive) {
    Map.setXY();
  }
}
//***************************************************************************Initialising**********************************************************************
//set up a new generation player
void SetUpPlayer() {
  if (!NG.newPlayer) {
    //create an empty object
    MyPlayer = new player();
    NG.newPlayer = true;
    System.out.println("new player");
  }
  //choose profession and race
  if (!NG.raceChosen) {
    NG.raceToText();//display option
  } else if (!NG.proChosen) {
    //boolean as lock, only attempt pass this once
    if (oldPlayer != null && !NG.passProCheck) {
      //50% chance passing profession and weapon
      if (randomNum(1, 100) <= 50) {
        MyPlayer.setPro(oldPlayer.pro);
        System.out.println("you followed the path of your father");
        NG.proChosen = true;
      }
      NG.passProCheck = true;
    } else {
      NG.proToText();//display option
    }
  } else if (!NG.cultiChosen) {
    if (oldPlayer != null && !NG.passCultiCheck) {
      //50% chance passing
      if (randomNum(1, 100) <= 50) {
        MyPlayer.setCultivationMethod(oldPlayer.CM);
        System.out.println("you acquired your father's cultication method");
        NG.cultiChosen = true;
      }
      NG.passCultiCheck = true;
    } else {
      //random element
      MyPlayer.setCultivationMethod(new cultivationMethod(elements[randomNum(0, 4)], randomNum(5, 15), randomNum(15, 20)));
      System.out.println("you acquired a new cultivation method");
      NG.cultiChosen = true;
    }
  }
  //inherites some stuff from parent
  //set up bag
  if (oldPlayer != null) {
    //loose half of all usables
    for (int i = 0; i < MyPlayer.playerBag.useSlots.length; i++) {
      MyPlayer.playerBag.useSlots[i].usableNum = (int)(oldPlayer.playerBag.useSlots[0].usableNum / 2);    
    }
    //pass buffs
    MyPlayer.permanentBuffs = oldPlayer.permanentBuffs;
    //ad and ap boost does not apply effect, it apply when calculate damage
    for (int i = 0; i < MyPlayer.permanentBuffs.size(); i++) {
      MyPlayer.permanentBuffs.get(i).applyEffect(MyPlayer);
    }
  }
  
  //the set up is complete
  if (NG.newPlayer && NG.raceChosen && NG.proChosen && NG.cultiChosen) {
    MyPlayer.CalTotalPhysicDamage();
    MyPlayer.CalTotalMagicDamage();
    oldPlayer = MyPlayer;
    MyPlayer.playRoom = startRoom;
    NG.complete = true;
    MyPlayer.position.x = width / 2;
    MyPlayer.position.y = height / 2 + 110;
  }
}
//set up overcoming and generation rules of the 5 elements
void initElements() {
  //create element
  metal = new element("metal", Type.METAL, grey);
  wood = new element("wood", Type.WOOD, green);
  water = new element("water", Type.WATER, black);
  fire = new element("fire", Type.FIRE, red);
  earth = new element("earth",Type.EARTH, yellow);
  //set up rules
  metal.setRule(water, wood);
  wood.setRule(fire, earth);
  water.setRule(wood, fire);
  fire.setRule(earth, metal);
  earth.setRule(metal, water);
  //add to array
  elements = new element[5];
  elements[0] = metal;
  elements[1] = wood;
  elements[2] = water;
  elements[3] = fire;
  elements[4] = earth;
}
//create a rooms and connections
void initRooms() {
  //create a number of rooms
  //int randomRoomNum = Base_RoomNo + randomNum(0, 5);
  int randomRoomNum = 5;
  for (int i = 0; i < randomRoomNum; i++) {
    //random room size
    Rooms.add(new room(i, randomNum(600, 1000), randomNum(400, 700)));
  }
  //add connections
  for (int i = 0; i < Rooms.size(); i++) {
    //connect to a random room
    //loop until a connection added
    while(true) {
      //allow a maximum of 3 portals in a room(may add connections to hidden/start rooms etc.) 
      if (Rooms.get(i).Portals.size() == 3) {
        break;
      }
      //not itself
      int NextIndex = randomNum(0, Rooms.size() - 1);
      if (NextIndex == i) {
        continue;
      }
      //check if connection is not there and the target room has less than 3 connections
      //break loop after add
      if (!Rooms.get(i).getConnections().contains(Rooms.get(NextIndex)) && Rooms.get(NextIndex).getConnections().size() < 3) {
        //add portals to rooms
        Rooms.get(i).Portals.add(new portal(Rooms.get(NextIndex)));
        Rooms.get(NextIndex).Portals.add(new portal(Rooms.get(i)));
        break;
      }
    }
  }
  //check if rooms form groups (with no connection between groups) using breadth first search
  //create search queue
  Queue<room> searchQueue = new LinkedList<room>();
  //create explored list
  ArrayList<room> explored = new ArrayList<room>();
  //add start node into search queue
  searchQueue.add(Rooms.get(0));
  //must able to reach the room from any other room meaning the explore list must contains all room
  while (explored.size() != Rooms.size()) {
    //loop
    while (!searchQueue.isEmpty()) {
      room current = searchQueue.remove();
      explored.add(current);
      //add not visited room to search queue, prevent dupicate
      for (int j = 0; j < current.getConnections().size(); j++) {
        if (!explored.contains(current.getConnections().get(j)) && !searchQueue.contains(current.getConnections().get(j))) {
          //add to search Queue
          searchQueue.add(current.getConnections().get(j));
        }            
      }
    }
    //not all room visited, rooms form groups
    if (explored.size() != Rooms.size()) {
      //find first room not connected to the current explored
      room notConnected = null;
      for (int i = 0; i < Rooms.size(); i++) {
        if (!explored.contains(Rooms.get(i))) {
          notConnected = Rooms.get(i);
          break;
        }
      }
      //pick one room from explored
      int randomExplored = randomNum(0, explored.size() - 1);    
      if (notConnected != null) {
        //add portals
        explored.get(randomExplored).Portals.add(new portal(notConnected));
        notConnected.Portals.add(new portal(explored.get(randomExplored)));
      } else {
        System.out.println("connect group assign error");
        System.exit(1);
      }     
      //add not visited random pick room to search queue
      searchQueue.add(notConnected);
    }
  }
  //set up portal locations of each room
  for (int i = 0; i < Rooms.size(); i++) {
    for(int j = 0; j < Rooms.get(i).Portals.size(); j++) {
      //calculate room size
      int X_min = width / 2 - Rooms.get(i).X_size / 2 + Rooms.get(i).Portals.get(j).size / 2;
      int X_max = width / 2 + Rooms.get(i).X_size / 2 - Rooms.get(i).Portals.get(j).size / 2;
      int Y_min = height / 2 - Rooms.get(i).Y_size / 2 + Rooms.get(i).Portals.get(j).size / 2;
      int Y_max = height / 2 + Rooms.get(i).Y_size / 2 - Rooms.get(i).Portals.get(j).size / 2;
      int randomX = randomNum(X_min, X_max);
      int randomY = randomNum(Y_min, Y_max);
      //portal cannot overlap
      for (int k = 0; k < j; k++) {
        Circle_Circle_Collision_Checker CC = new Circle_Circle_Collision_Checker();
        //circle-circle collision, portals separate at least 100 form center to center (therefore 50,50)
        if (CC.Check(Rooms.get(i).Portals.get(k).x_inRoom, Rooms.get(i).Portals.get(k).y_inRoom, randomX, randomY, 50, 50)) {
          //random again if find collision
          randomX = randomNum(X_min, X_max);
          randomY = randomNum(Y_min, Y_max);
          //start from beginnin of list again
          k = 0;
        }
      }
      //assign coordinate
      Rooms.get(i).Portals.get(j).x_inRoom = randomX;
      Rooms.get(i).Portals.get(j).y_inRoom = randomY;
    }
  }
  //10% a room has a theme element
  for (int i = 0; i < Rooms.size(); i++) {
    if (randomNum(1, 100) <= 10) {
      Rooms.get(i).e = elements[randomNum(0, 4)];
    }
  }
}
//place different objects in room
void placeObjects() {
  //-1 because the last one is end room
  for (int i = 0; i < Rooms.size() - 1; i++) {
    placeStatue(Rooms.get(i));
    placeChest(Rooms.get(i));
    placeCrate(Rooms.get(i));
    placeObstacle(Rooms.get(i));
  }
}
//place statue
void placeStatue(room r) {
  //50% chance a statue will appear in the room
  if (randomNum(1, 100) <= 50) {
    //check if a portal appear at the center of room
    //dont put statue if this is the case   
    statue s = new statue();
    for (int i = 0; i < r.Portals.size(); i++) {
      Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
      if (CR.Check(r.Portals.get(i).x_inRoom, r.Portals.get(i).y_inRoom, r.Portals.get(i).size / 2, s.inRoom_x, s.inRoom_y, s.X_size, s.Y_size)) {
        return;
      }
    }
    r.interActables.add(s);
  } 
}
//place chest
void placeChest(room r) {
  int default_Num = 2;//define number of chest a room can have
  for (int i = 0; i < default_Num; i++) {
    //50% chance a chest will appear in the room
    if (randomNum(1, 100) <= 50) {
      //get a random postion in room for chest
      //loop to find a not collided place
      boolean collision = true;
      outerloop://label
      while (collision) {
        chest c = new chest();
        //room size
        int X_min = width / 2 - r.X_size / 2 + c.X_size / 2;
        int X_max = width / 2 + r.X_size / 2 - c.X_size / 2;
        int Y_min = height / 2 - r.Y_size / 2 + c.Y_size / 2;
        int Y_max = height / 2 + r.Y_size / 2 - c.Y_size / 2;
        int randomX = randomNum(X_min, X_max);
        int randomY = randomNum(Y_min, Y_max);
        //check if a portal at place
        for (int j = 0; j < r.Portals.size(); j++) {
          Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
          if (CR.Check(r.Portals.get(j).x_inRoom, r.Portals.get(j).y_inRoom, r.Portals.get(j).size / 2, randomX, randomY, c.X_size, c.Y_size)) {
            continue outerloop;
          }
        }
        //check if any other objects at place
        for (int j = 0; j < r.interActables.size(); j++) {
          Rect_Rect_Collision_Checker RR = new Rect_Rect_Collision_Checker();
          if (RR.Check(randomX, randomY, c.X_size, c.Y_size,
              r.interActables.get(j).inRoom_x, r.interActables.get(j).inRoom_y, r.interActables.get(j).X_size, r.interActables.get(j).Y_size)) {
            continue outerloop;
          }
        }
        //add if check pass
        c.inRoom_x = randomX;
        c.inRoom_y = randomY;
        r.interActables.add(c);
        collision = false;
      }
    }
  }
}
//place small cases
void placeCrate(room r) {
  int default_Num = 5;//define number of crate a room can have
  for (int i = 0; i < default_Num; i++) {
    //50% chance a crate will appear in the room
    if (randomNum(1, 100) <= 50) {
      //get a random postion in room for chest
      //loop to find a not collided place
      boolean collision = true;
      outerloop://label
      while (collision) {
        crate c = new crate();
        int X_min = width / 2 - r.X_size / 2 + c.X_size / 2;
        int X_max = width / 2 + r.X_size / 2 - c.X_size / 2;
        int Y_min = height / 2 - r.Y_size / 2 + c.Y_size / 2;
        int Y_max = height / 2 + r.Y_size / 2 - c.Y_size / 2;
        int randomX = randomNum(X_min, X_max);
        int randomY = randomNum(Y_min, Y_max);
        //check if a portal at place
        for (int j = 0; j < r.Portals.size(); j++) {
          Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
          if (CR.Check(r.Portals.get(j).x_inRoom, r.Portals.get(j).y_inRoom, r.Portals.get(j).size / 2, randomX, randomY, c.X_size, c.Y_size)) {
            continue outerloop;
          }
        }
        //check if any other objects at place
        for (int j = 0; j < r.interActables.size(); j++) {
          Rect_Rect_Collision_Checker RR = new Rect_Rect_Collision_Checker();
          if (RR.Check(randomX, randomY, c.X_size, c.Y_size,
              r.interActables.get(j).inRoom_x, r.interActables.get(j).inRoom_y, r.interActables.get(j).X_size, r.interActables.get(j).Y_size)) {
            continue outerloop;
          }
        }
        //add if check pass
        c.inRoom_x = randomX;
        c.inRoom_y = randomY;
        r.interActables.add(c);
        collision = false;
      }
    }
  }
}
//palce obstacle
void placeObstacle(room r) {
  int default_Num = 10;//define number of obstacle a room can have
  for (int i = 0; i < default_Num; i++) {
    //50% chance an obstacle will appear in the room
    if (randomNum(1, 100) <= 50) {
      //get a random postion in room for chest
      //loop to find a not collided place
      boolean collision = true;
      outerloop://label
      while (collision) {
        //random half size
        int X_size = randomNum(10, 25);
        int Y_size = randomNum(10, 25);
        int X_min = width / 2 - r.X_size / 2 + X_size;
        int X_max = width / 2 + r.X_size / 2 - X_size;
        int Y_min = height / 2 - r.Y_size / 2 + Y_size;
        int Y_max = height / 2 + r.Y_size / 2 - Y_size;
        int randomX = randomNum(X_min, X_max);
        int randomY = randomNum(Y_min, Y_max);
        //check if a portal at place
        for (int j = 0; j < r.Portals.size(); j++) {
          Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
          if (CR.Check(r.Portals.get(j).x_inRoom, r.Portals.get(j).y_inRoom, r.Portals.get(j).size / 2, randomX, randomY, X_size * 2, Y_size * 2)) {
            continue outerloop;
          }
        }
        //check if any other objects at place
        for (int j = 0; j < r.interActables.size(); j++) {
          Rect_Rect_Collision_Checker RR = new Rect_Rect_Collision_Checker();
          if (RR.Check(randomX, randomY, X_size * 2, Y_size * 2,
              r.interActables.get(j).inRoom_x, r.interActables.get(j).inRoom_y, r.interActables.get(j).X_size, r.interActables.get(j).Y_size)) {
            continue outerloop;
          }
        }
        //add if check pass
        r.interActables.add(new obstacle(randomX, randomY, X_size * 2, Y_size * 2));
        collision = false;
      }
    }
  }
}
//place enemies
void placeEnemy(room r) {
  int default_Num = 6;//define number of enemies a room can have
  //50% chance to place some enemies in room, theme room always has amx enemies
  if (r.e != null) {//theme room, enemies all theme element
    for (int i = 0; i < default_Num; i++) {
      int type = randomNum(1, 3);
      if (type == 1) {//archer
        r.enemies.add(new enemy(new cultivationMethod(r.e, randomNum(5, 15), randomNum(15, 25)), new archer(r.e, randomNum(5,15), randomNum(5,15))));
      } else if (type == 2) {//mage
        r.enemies.add(new enemy(new cultivationMethod(r.e, randomNum(5, 15), randomNum(15, 25)), new mage(r.e, randomNum(5,15), randomNum(5,15))));
      } else if (type == 3) {//warrior
        r.enemies.add(new enemy(new cultivationMethod(r.e, randomNum(5, 15), randomNum(15, 25)), new warrior(r.e, randomNum(5,15), randomNum(5,15))));
      }
    }  
  } else {
    //50% chance a room has enemy
    if (randomNum(0, 1) == 1) {
      for (int i = 0; i < default_Num; i++) {
        //50% chance this enemy will appear in the room
        if (randomNum(1, 100) <= 50) {
          int type = randomNum(1, 3);
          //random elements
          if (type == 1) {//archer
            r.enemies.add(new enemy(new cultivationMethod(elements[randomNum(0, 4)], randomNum(5, 15), randomNum(15, 25)), new archer(elements[randomNum(0, 4)], randomNum(5,15), randomNum(5,15))));
          } else if (type == 2) {//mage
            r.enemies.add(new enemy(new cultivationMethod(elements[randomNum(0, 4)], randomNum(5, 15), randomNum(15, 25)), new mage(elements[randomNum(0, 4)], randomNum(5,15), randomNum(5,15))));
          } else if (type == 3) {//warrior
            r.enemies.add(new enemy(new cultivationMethod(elements[randomNum(0, 4)], randomNum(5, 15), randomNum(15, 25)), new warrior(elements[randomNum(0, 4)], randomNum(5,15), randomNum(5,15))));
          }
        }
      }
    }
  }
  //assign positions to enemies avoid objects and portals
  for (int i = 0; i < r.enemies.size(); i++) {
    outerloop://label
    while (true) {
      //random place in room
      int X_min = width / 2 - r.X_size / 2 + r.enemies.get(i).size / 2;
      int X_max = width / 2 + r.X_size / 2 - r.enemies.get(i).size / 2;
      int Y_min = height / 2 - r.Y_size / 2 + r.enemies.get(i).size / 2;
      int Y_max = height / 2 + r.Y_size / 2 - r.enemies.get(i).size / 2;
      int randomX = randomNum(X_min, X_max);
      int randomY = randomNum(Y_min, Y_max);
      //check if a portal at place, make enemies 100 away from portals
      for (int j = 0; j < r.Portals.size(); j++) {
        Circle_Circle_Collision_Checker CC = new Circle_Circle_Collision_Checker();
        if (CC.Check(r.Portals.get(j).x_inRoom, r.Portals.get(j).x_inRoom, randomX, randomY, 50, 50)) {
          continue outerloop;
        }
      }
      //check if any other objects at place
      for (int j = 0; j < r.interActables.size(); j++) {
        Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
        if (CR.Check(randomX, randomY, r.enemies.get(i).size / 2,
            r.interActables.get(j).inRoom_x, r.interActables.get(j).inRoom_y, r.interActables.get(j).X_size, r.interActables.get(j).Y_size)) {
          continue outerloop;
        }
      }
      //set x, y
      r.enemies.get(i).position.x = randomX;
      r.enemies.get(i).position.y = randomY;
      break;
    }
  }
  //modify attributes of enemy to make them similar strength as player
  for (int i = 0; i <r.enemies.size(); i++) {
    r.enemies.get(i).adjustAttributes(MyPlayer);
  }
}
//initialise start room and end room
void CreateStartRoom() {
  //startRoom
  startRoom = new room(-1, 300, 300);
  //place a large gate at center of start room, this gate teleports to random playroom when a new round start
  //or teleport to boss room if boss fight enabled
  startRoom.interActables.add(new gate(width / 2, height / 2, 50, 100));
  //add boss statue to start room;
  startRoom.interActables.add(new BossStatue(width / 2 - 100, height / 2, 25, 50));
}
//set start room gate destination
void setStartRoomTarget() {
  //-2 because the end of list is end room
  room randomRoom = Rooms.get(randomNum(0, Rooms.size() -  2));
  //set the target of gate
  gate start = (gate)(startRoom.interActables.get(0));
  ((gate)(startRoom.interActables.get(0))).targetRoom = randomRoom;
  //prevent collison of other objects
  outerloop:
  while (true) {
    //random x and y for player in room
    int X_min = width / 2 - randomRoom.X_size / 2 + MyPlayer.size / 2;
    int X_max = width / 2 + randomRoom.X_size / 2 - MyPlayer.size / 2;
    int Y_min = height / 2 - randomRoom.Y_size / 2 + MyPlayer.size / 2;
    int Y_max = height / 2 + randomRoom.Y_size / 2 - MyPlayer.size / 2;
    int randomX = randomNum(X_min, X_max);
    int randomY = randomNum(Y_min, Y_max);
    //not on objects
    for (int i = 0; i < randomRoom.interActables.size(); i++) {
      Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
      if (CR.Check(randomX, randomY, MyPlayer.size / 2,
          randomRoom.interActables.get(i).inRoom_x, randomRoom.interActables.get(i).inRoom_y, randomRoom.interActables.get(i).X_size, randomRoom.interActables.get(i).Y_size)) {
        //find collision, redo random
        continue outerloop;
      }
    }    
    //set target x,y
    start.targetX = randomX;
    start.targetY = randomY;
    break;
  }
}
//create end room and attach to room list 
void CreateEndRoom() {
  //end room
  endRoom = new room(-2, 200, 200);
  //place a gate at center of end room link to bottom center of start room
  gate endRoomGate = new gate(width / 2, height / 2, 50, 100);
  endRoomGate.targetRoom = startRoom;
  endRoomGate.targetX = width / 2;
  endRoomGate.targetY = height / 2 + 110;
  endRoom.interActables.add(endRoomGate);
  //place a portal at bottom link to a random room
  //pick a random room
  room randomRoom = Rooms.get(randomNum(0, Rooms.size() -  1));
  //place end room side portal at bottom center
  endRoom.Portals.add(new portal(randomRoom));
  endRoom.Portals.get(0).x_inRoom = width / 2;
  endRoom.Portals.get(0).y_inRoom = height / 2 + 100 - endRoom.Portals.get(0).size / 2;
  //link the random room portal to endroom  
  //prevent collison of other portals
  //since no objects add to end room, only check portals
  portal newP = new portal(endRoom);
  outerloop:
  while (true) {
    //random x and y for portal in room
    int X_min = width / 2 - randomRoom.X_size / 2 + randomRoom.Portals.get(0).size / 2;
    int X_max = width / 2 + randomRoom.X_size / 2 - randomRoom.Portals.get(0).size / 2;
    int Y_min = height / 2 - randomRoom.Y_size / 2 + randomRoom.Portals.get(0).size / 2;
    int Y_max = height / 2 + randomRoom.Y_size / 2 - randomRoom.Portals.get(0).size / 2;
    int randomX = randomNum(X_min, X_max);
    int randomY = randomNum(Y_min, Y_max);
    for (int i = 0; i < randomRoom.Portals.size(); i++) {
      Circle_Circle_Collision_Checker CC = new Circle_Circle_Collision_Checker();
      if (CC.Check(randomX, randomY, randomRoom.Portals.get(i).x_inRoom, randomRoom.Portals.get(i).y_inRoom, randomRoom.Portals.get(0).size / 2, randomRoom.Portals.get(0).size / 2)) {
        //find collision, redo random
        continue outerloop;
      }
    }
    //set x,y
    newP.x_inRoom = randomX;
    newP.y_inRoom = randomY;
    randomRoom.Portals.add(newP);
    break;
  }
  //add end room to room list
  Rooms.add(endRoom);
}
//boss room
void CreateBossRoom() {
  
  BossRoom = new room(-3, 700, 700);
  
  
}
//******************************************************************movement checkers*************************************************************
//check enemy/player collide with object
PVector checkCollideObject(room r, float x, float y, float dx, float dy, float size) {
  ArrayList<interActable> blockings = new ArrayList<interActable>();
  for (int i = 0; i < r.interActables.size(); i++) {
    Circle_Rect_Collision_Checker CR = new Circle_Rect_Collision_Checker();
    if (CR.Check(x + dx, y + dy, size / 2,
        r.interActables.get(i).inRoom_x, r.interActables.get(i).inRoom_y, r.interActables.get(i).X_size, r.interActables.get(i).Y_size)) {
      blockings.add(r.interActables.get(i));
    }
  }
  //remove collide direction
  if (!blockings.isEmpty()) {
    for (int i = 0; i < blockings.size(); i++) {
      //x
      if (x + dx + size / 2 >= blockings.get(i).inRoom_x - blockings.get(i).X_size / 2//entering left edge
          || x - dx - size / 2 <= blockings.get(i).inRoom_x + blockings.get(i).X_size / 2) {//entering right edge
        dx = 0;
      }
      //y
      if (y + dy + size / 2 >= blockings.get(i).inRoom_y - blockings.get(i).Y_size / 2//entering top edge
          || y - dy - size / 2 <= blockings.get(i).inRoom_y + blockings.get(i).Y_size / 2) {//entering bottom edge
        dy = 0;
      }
    }   
  }
  return new PVector(dx, dy);
}
//*********************************************************************functions******************************************************************
void teleport() {
  //check if a player is in the portal
  for(int i = 0; i < MyPlayer.playRoom.Portals.size(); i++) {
    Circle_Circle_Collision_Checker CC = new Circle_Circle_Collision_Checker();
    if (CC.Check(MyPlayer.playRoom.Portals.get(i).x_inRoom, MyPlayer.playRoom.Portals.get(i).y_inRoom, MyPlayer.position.x, MyPlayer.position.y,
        MyPlayer.playRoom.Portals.get(i).size / 2, MyPlayer.size / 2)) {
      //switch room
      room oldRoom = MyPlayer.playRoom;
      room newRoom = MyPlayer.playRoom.Portals.get(i).target;    
      oldRoom.Portals.get(i).visited = true;                      //old room this portal visited  
      MyPlayer.playRoom = newRoom;                                //playRoom become target room of portal
      newRoom.visited = true;                                     //new room visited
      for (int j = 0; j < newRoom.Portals.size(); j++) {          //portal in new room connecting the old room visited and landed
        if (newRoom.Portals.get(j).target == oldRoom) {
          newRoom.Portals.get(j).visited = true;     
          //land the player on the new room portal
          MyPlayer.position.x = newRoom.Portals.get(j).x_inRoom;
          MyPlayer.position.y = newRoom.Portals.get(j).y_inRoom;
          return;
        }
      }
    }
  }
}
//*********************************************************************Utilities*****************************************************************
//random number
int randomNum(float min, float max) {
  return (int)((Math.random() * ((max - min) + 1)) + min);
}
