public class manaPotion extends potion{
  
  int recoverEffect;
  
  manaPotion() {
    Name = "Mana Potion +20";
    recoverEffect = 20;
  }
  
  public void consume(player p) {
    p.mp.applyChange(recoverEffect);
  }
}
