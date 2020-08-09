public class Shield_boost extends buff{
  
  Shield_boost(int effect) {
    duration = 30;
    this.effect = effect;
  }
  
  public void applyEffect(player p) {
    p.Shield.changeMax(effect);
  }
  
  public void resetDuration() {
    return;
  }
}
