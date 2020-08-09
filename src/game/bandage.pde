public class bandage extends potion{
  
  bandage() {
    Name = "Banage";
  }
  //remove bleeding effect
  public void consume(player Myplayer) {
    for (int i = 0; i < MyPlayer.buffs.size(); i++) {
      if (MyPlayer.buffs.get(i) instanceof bleeding) {
        MyPlayer.buffs.remove(i);
        System.out.println("you stopped bleeding");
        return;
      }
    }   
  }
}
