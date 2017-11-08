//
// changeOfBase.cpp
//

#include <iostream>
#include <string>
#include <cmath>
#include <algorithm>
using namespace std;

int convertToBaseTen(char* num, int base)
{
  int number[33];
  int char_rep = 0;
  int digit = 0;
  int numBaseTen = 0;
  size_t length = strlen(num);
  
  for (int i = 0; i < length; i++)
  {
    char_rep = char(num[i]);
    
    // *** TRY TO FIX UP THIS PART ***
    if (char_rep < 58)
      number[i] = char_rep - 48;
    else
      number[i] = char_rep - 55;
  }
  
  for (int i = 0; i < length; i++)
  {
    int reverse = (int)length - i - 1;
    digit = (int)(pow(base, i));
    numBaseTen = numBaseTen + (number[reverse] * digit);
  }

  return numBaseTen;
}

char* convertToBase(long num, int newBase)
{
  int remainder;
  int i = 0;
  char* newNum = new char[33];
  char* revNewNum = new char[strlen(newNum) + 1];
  
  while (true)
  {
    remainder = num % newBase;
    num = num / newBase;
    if (remainder < 10)
      newNum[i] = '0' + remainder;
    else
      newNum[i] = 'A' + (remainder - 10);
  
    i++;
    
    if (num == 0)
      break;
  }
  
  // Reverse string
  int j = 0;
  
  for (i = (int)strlen(newNum) - 1; i >= 0; i--)
  {
    revNewNum[j] = newNum[i];
    j++;
  }

  return revNewNum;
}


int main()
{
  int base, newBase;
  char* num = new char[33];

  cout << "Please enter the number's base: ";
  cin >> base;
  
  cout << "Please enter the number: ";
  cin >> num;
  
  cout << "Please enter the new base: ";
  cin >> newBase;
  
  cout << num << " base " << base << " " << "is " << convertToBase(convertToBaseTen(num, base), newBase) << " " << "base " << newBase << endl;
  
}
