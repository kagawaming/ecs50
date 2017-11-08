#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv){
  int i,j;
  unsigned int dividend, divisor,d;
  unsigned int quotient, remainder;
  sscanf(argv[1],"%u",&dividend);//put the first number into dividend as unsigned integer
  sscanf(argv[2],"%u",&divisor);//put the second number into dividend as unsigned integer
  remainder = dividend;//initial the remainder
  quotient = 0;
  d=divisor;
  for (j=0;j<=32;j++){//find out how many bit in the divisor
    if((d>>j)==0){
      break;
    }
  }
  for (i=32-j;i>=0;i--){
    if (remainder ==0){//if the remainder = 0, the loop end
      break;
    }
    else if(remainder >= (divisor<<i)){//keep subtract the remainder by shifted divisor untill divisor >remiander
      remainder -= (divisor<<i);
      quotient = quotient | (1<<i);
    }
  }
  printf("%u / %u = %u R %u\n",dividend,divisor,quotient,remainder);
  return 0;
}
