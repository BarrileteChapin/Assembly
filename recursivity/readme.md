# p1

implements this function: 

    int mmod(int x, int y){
        int divisor;
        int dividend;
        divisor = x > y ? pow(2, (y % 4)) : pow(2, (x % 4));
        dividend = x > y ? x : y;
        return dividend % divisor;
    }

# p2

 implements these functions: 
 
    int fn(int x, int y){
      if(x <= 0)
      return 0;
      else if(y <= 0)
      return 0;
      else if(x < y)
      return 1;
      else
      return fn(x - 1, y) + 2 * fn(x, y + 2) + y;
    }
    
     int re(int x){ return (x > 0) ? 1 + re(x - 1) : 0;}
