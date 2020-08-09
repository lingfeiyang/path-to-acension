abstract class movingObject{
  
  PVector position;
  PVector direction;
  int size;
  hitPoint hp;
  manaPoint mp;
  cultivationMethod CM;
  shield Shield;
  Profession pro;
  
  int totalPhysicDamage;
  int totalMagicDamage;
  
  boolean enchanted;
  
  abstract void moveAttack();
  
  abstract void takeDamage(movingObject source);
}
