enum Type {
  METAL,
  WOOD,
  WATER,
  FIRE,
  EARTH   
}

public class element{
  
  String name;
  Type eleType;   //type of this element
  element generation;  //type of element generated by this element
  element overcoming;  //type of element overcoming this element
  color elementColour;
  
  element(String name, Type type, color c) {
    this.name = name;
    eleType = type;
    elementColour = c;
  }
  //set generation and overcoming rules
  void setRule(element gene, element over) {
    generation = gene;
    overcoming = over;
  }
}