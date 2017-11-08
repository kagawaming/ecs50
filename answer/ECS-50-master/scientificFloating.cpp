//
// scientificFloating.cpp
//

#include <iostream>
using namespace std;

unsigned int findExponent(unsigned int exponent, unsigned int float_int, float f)
{

  exponent = (float_int & 0x7f800000) >> 23;
  
  if (exponent != 0)
    exponent = exponent - 127;
  
  return exponent;
}

void findMantissa(float f, unsigned int float_int, unsigned int* mantissa)
{
  
  for (int i = 22; i >= 0; i--)
  {
    mantissa[(22 - i)] = ((float_int >> i) & 1);
  }

  for (int i = 0; i <= 22; i++)
  {
    if (mantissa[i] == 0)
    {
      int count = 0;
      
      for (int j = i; j <= 22; j++)
      {
        if (mantissa[j] == 1)
          count++;
      }
      
      if (count == 0)
        mantissa[i] = 2;
    }
  }
  
}

void findSign(unsigned int sign, float f, unsigned int float_int, unsigned int* mantissa)
{
  
  sign = float_int >> 31;
  
  if (sign == 1)
  {
    cout << "-" << sign << ".";
  }
  
  else
  {
    sign = sign + 1;
    cout << sign << ".";
  }
  
  for (int i = 0; i <= 22; i++)
  {
    if (mantissa[i] == 0 || mantissa[i] == 1)
    {
      cout << mantissa[i];
    }
  }
}

int main()
{
  float f;
  
  cout << "Please enter a float: ";
  cin >> f;
  
  if (f == 0)
  {
    cout << "0E0" << endl;
    return 0;
  }
  
  unsigned int float_int = *((unsigned int*)&f);
  unsigned int sign, exponent, mantissa[23];
  
  findMantissa(f, float_int, mantissa);
  findSign(sign, f, float_int, mantissa);
  
  cout << "E" << findExponent(exponent, float_int, f) << endl;
  return 0;
}