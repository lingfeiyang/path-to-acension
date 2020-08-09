public class human extends race{
  
  human() {
    damage = 5;
    elementStrength = 5;
  }
  
  public void ModifyAttributes(player MyPlayer) {
    for (int i = 0; i < MyPlayer.playerBag.useSlots.length; i++) {
      MyPlayer.playerBag.useSlots[i].usableNum  = MyPlayer.playerBag.useSlots[i].usableNum + 3;
    } 
  }
}
