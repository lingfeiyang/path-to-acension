public class newGeneration {
  
  String pros[];
  String races[];
  boolean newPlayer;//a new player object is created
  boolean proChosen;
  boolean raceChosen;
  boolean complete;//the porcess is complete
  boolean passProCheck;//is passing profession attempt?
  boolean cultiChosen;//if the cultivationm method is set
  boolean passCultiCheck;//is passing method attempt?
  newGeneration() {
    pros = new String[]{"1.archer", "2.mage", "3.warrior"};
    races = new String[]{"1.human", "2.wildling", "3.spirit"};
    newPlayer = false;
    proChosen = false;
    raceChosen = false;
    complete = false;
    passProCheck = false;
    cultiChosen = false;
    passCultiCheck = false;
  }
  
  void raceToText() {
    textSize(15);
    fill(0);
    text("Choose race:", 5, 15);
    text(races[0], 5, 30);
    text(races[1], 5, 45);
    text(races[2], 5, 60);
  }
  
  void proToText() {
    textSize(15);
    fill(0);
    text("Choose profession:", 5, 15);
    text(pros[0], 5, 30);
    text(pros[1], 5, 45);
    text(pros[2], 5, 60);
  }
}
