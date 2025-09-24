public class RectangleWithConstructor {
    
    Decimal length, breadth;
    //costructor
    public RectangleWithConstructor (Decimal l, Decimal b){
        length = l;
        breadth = b;
    }
	public void area(){ 
        Decimal a = length * breadth;
        System.debug('Area =' +a);
    }    
     public void perimeter(){
        Decimal p = length * breadth;
        System.debug('Perimeter =' +p);
    }
}