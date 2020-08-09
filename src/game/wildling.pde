public class wildling extends race{
  
  wildling () {
    damage = 7;
    elementStrength = 3;
  }
  
  public void ModifyAttributes(player MyPlayer) {
    MyPlayer.hp.changeMax(25);
    MyPlayer.hp.current_HP = MyPlayer.hp.max_HP;
    MyPlayer.mp.changeMax(-25);
    MyPlayer.Shield.changeMax(-25);
  }
}
