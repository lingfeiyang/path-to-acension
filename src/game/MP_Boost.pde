public class MP_boost extends buff{
  
  MP_boost(int effect) {
    duration = 30;
    this.effect = effect;
  }
  
  public void applyEffect(player p) {
    p.mp.changeMax(effect);
  }
  
  public void resetDuration() {
    return;
  }
}
