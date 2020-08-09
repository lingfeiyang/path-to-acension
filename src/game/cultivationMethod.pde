public class cultivationMethod{
  
  int elementStrength;
  int shieldBoost;
  element currentElement;
  
  cultivationMethod(element e, int es, int boost) {
    currentElement = e;
    elementStrength = es;
    shieldBoost = boost;
    //random some values for attributes;
  }
  
  String toText(){
    return currentElement.name + " method " + " Strength+" + elementStrength + " Boost+" + shieldBoost;
  }
}
