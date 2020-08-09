public class HP_boost extends buff{
  
  HP_boost(int effect) {
    duration = 30;
    this.effect = effect;
  }
  
  public void applyEffect(player p) {
    p.hp.changeMax(effect);
  }
  
  public void resetDuration() {
    return;
  }
}
