public class bag{
  
  usableSlot[] useSlots;
  Weapon[] LootWeapons;
  cultivationMethod[] methods;
  int EmblemNum;
  
  bag() {
    EmblemNum = 1;
    useSlots = new usableSlot[3];
    LootWeapons = new Weapon[5];
    methods = new cultivationMethod[3];   
    useSlots[0] = new usableSlot(new healingPotion());
    useSlots[1] = new usableSlot(new manaPotion());
    useSlots[2] = new usableSlot(new bandage());
    
    
    
    for (int i = 0; i < useSlots.length; i++) {
      useSlots[i].usableNum = 3;
    }
    
    for (int i = 0; i < LootWeapons.length; i++) {
      LootWeapons[i] = null;
    }
    
    LootWeapons[0] = new bow(fire, 5, 5);
  }
  
  void display() {
    textSize(15);
    fill(0);
    int textPlace = 15;
    for (int i = 0; i < LootWeapons.length; i++) {
      if (LootWeapons[i] == null) {
        text("Empty", 5, textPlace);
      } else {
        text(LootWeapons[i].toText(), 5, textPlace);
      }     
      textPlace = textPlace +15;
    }
  }
}
