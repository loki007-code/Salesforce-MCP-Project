public class RectangleStaticMethod {
	public static void area(){
        Decimal length = 5.5, breadth = 6;
        Decimal a = length * breadth;
        System.debug('Area =' +a);
    }
    
     public static void perimeter(){
        Decimal length = 5.5, breadth = 6;
        Decimal p = length * breadth;
        System.debug('Perimeter =' +p);
    }
}