#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv){
  int i,j;
  unsigned int dividend, divisor,d;
  unsigned int quotient, remainder;
  sscanf(argv[1],"%u",&dividend);
  sscanf(argv[2],"%u",&divisor);
  remainder = dividend;
  quotient = 0;
  d=divisor;
  for (j=0;j<=32;j++){
    if((d>>j)==0){
      break;
    }
  }
  for (i=32-j;i>=0;i--){
    if (remainder ==0){
      break;
    }
    else if(remainder >= (divisor<<i)){
      remainder -= (divisor<<i);
      quotient = quotient | (1<<i);
    }
  }
  printf("%u / %u = %u R %u\n",dividend,divisor,quotient,remainder);

  return 0;
}
