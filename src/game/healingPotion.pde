public class healingPotion extends potion{
  
  int recoverEffect;
  
  healingPotion() {
    Name = "Healing Potion +20";
    recoverEffect = 20;
  }
  
  public void consume(player p) {
    p.hp.applyChange(recoverEffect);
  }
}
