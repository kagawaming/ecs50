#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int main(int argc, char* argv[])
{
  unsigned int divisor = 0, dividend = 0;
  unsigned int quotient = 0, remainder = 0;
  unsigned int temp = 0;
  int i;
  
  sscanf(argv[1], "%u", &dividend);
  sscanf(argv[2], "%u", &divisor);
  
  //temp = dividend;
  temp = dividend;
  dividend = dividend >> 31;
  quotient = quotient >> 31;
  
  for(i = 0; i < 32; i++)
  {
    if (temp & (1 << (31 - i)))
      dividend = dividend | 1;
    
    if (dividend >= divisor)
    {
      dividend -= divisor;
      quotient = quotient | 1;
    }
    
    else
    {
      quotient = quotient | 0;
    }
    
    quotient *= 2;
    dividend *= 2;
  }
  
  remainder = dividend / 2;

  printf("%u / %u = %u R %u\n", temp, divisor, quotient/2, remainder);
  
  return 0;
  
}

