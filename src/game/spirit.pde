public class spirit extends race{
  
  spirit() {
    damage = 3;
    elementStrength = 7;
  }
  
  public void ModifyAttributes(player MyPlayer) {
    MyPlayer.hp.changeMax(-25);
    MyPlayer.mp.changeMax(25);
    MyPlayer.mp.current_MP = MyPlayer.mp.max_MP;
    MyPlayer.Shield.changeMax(25);
    MyPlayer.Shield.current_shield = MyPlayer.Shield.max_shield;
  }
}
