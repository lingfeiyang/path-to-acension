public class usableSlot{
  
  int usableNum;
  potion p;
  
  usableSlot(potion p) {
    this.p = p;
  }
  //use 1
  void consume() {
    if (usableNum > 0) {
      usableNum--;
      p.consume(MyPlayer);
    } else {
      System.out.println("You don't have any");
    }
  }
  //gain num potion
  public void acquire(int num) {
    usableNum = usableNum +num;
    System.out.println("you get " + num + " " + p.Name);
  }
}
