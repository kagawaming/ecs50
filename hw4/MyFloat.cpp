#include "MyFloat.h"
#include <iostream>

MyFloat::MyFloat(){
  sign = 0;
  exponent = 0;
  mantissa = 0;
}

MyFloat::MyFloat(float f){
  unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
	sign = rhs.sign;
	exponent = rhs.exponent;
	mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f){
	strm << f.packFloat();
	return strm;

}
//
MyFloat MyFloat::operator+(const MyFloat& rhs) const{

    MyFloat myFloat(rhs);
    unsigned m1 = (mantissa | (1 << 23));
    unsigned m2 = (myFloat.mantissa | (1 << 23));
    if (rhs.exponent == 0)//take care of the cass where if one of the floats has exponent 0, then just return the float which is not equal to 0
    {
        return *this;
    }
    else if (exponent == 0)
    {
        return myFloat;
    }
    if (exponent == rhs.exponent) //take care of the case where f1 = -f2, so f1+f2=0
    {
        if(sign != rhs.sign)
        {
            if(mantissa == rhs.mantissa )
            {
                MyFloat zero(0.0);
                return zero;
            }
        }
    }
    unsigned gap;
    int s = exponent - myFloat.exponent;//find the difference of two exponents, and thake the abslute value and sign it to diff
    if (s <= 0){gap = myFloat.exponent - exponent;}
    else{gap = exponent - myFloat.exponent;}

    if (sign != myFloat.sign)//when the sign are different, than subtract the less mantissa from greater mantissa, and adjust the exponent
    {
        m1 <<= 8;
        m2 <<= 8;
        if (exponent <= myFloat.exponent)//case for f1<=f2
        {
            if (gap > 23)
            {
                m1 = 0;
            }
            m1 >>= gap;//shift the bits for calculation
            m2 -= m1;
            m2 >>= 8;
            int i = 0;
            while(i <= 31)
            {
                m1 = m2 << i;
                if (m1 & (1 << 23))
                {
                    myFloat.exponent = myFloat.exponent - i;
                    myFloat.mantissa = m1 - (1 << 23);
                    break;
                }
                i++;
            }
        }
        else//case for f1>f2
        {
            if (gap > 23)
            {
                m2 = 0;
            }
            myFloat.exponent = exponent;
            myFloat.sign = sign;
            m1 -= m2 >> gap;
            m1 >>= 8;

            int i = 0;
            while (i <= 31)
            {
                m2 = m1 << i;
                if (m2 & (1 << 23))
                {
                    myFloat.mantissa = m2 - (1 << 23);
                    myFloat.exponent = myFloat.exponent-i;
                    break;
                }
                i++;
            }

        }
    } else//when the sign are same, adjust the exponent to same level and do the add operation between two mantissas
    {
        if (exponent <= myFloat.exponent)
        {
            m1 >>= gap;
            myFloat.exponent = rhs.exponent;
            m1 += m2;
        } else
        {
            myFloat.exponent = exponent;
            m1 += m2 >>=  gap;
        }
        if (m1 & (1 << 24))//take care of the case where the sum of the mantissa is 24 bits
        {
            m1 >>= 1;
            myFloat.exponent++;
        }
        myFloat.mantissa = m1 - (1 << 23);

    }
	return myFloat;
}

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
    MyFloat myFloat(rhs);
    if(myFloat.sign == 1){
        myFloat.sign = 0;
    } else{
        myFloat.sign = 1;
    }
    return *this + myFloat;
}

void MyFloat::unpackFloat(float f) {
    __asm__(
            "movl $0, %[sign];"
            "movl %[f], %[sign];"
            "movl $0, %[exponent];"
            "movl %[f], %[exponent];"
            "shrl $31, %[sign];"//clear mantissa and sign
            "shll $1, %[exponent];"//clear sign
            "shrl $24, %[exponent];"//clear mantissa
            "movl $0, %[mantissa];"
            "movl %[f], %[mantissa];"
            "shll $9, %[mantissa];"//zero sign and exponent
            "shrl $9, %[mantissa]"
            :
            [exponent] "=r" (exponent),//output
            [sign] "=r" (sign),
            [mantissa] "=r" (mantissa)
            :
            [f] "r" (f)://input
            "cc"//clobber
            );
}//unpackFloat

float MyFloat::packFloat() const{
  //returns the floating point number represented by this
  float f = 0;
  __asm__(

          "movl $0, %[f];"
          "shll $31, %[sign];"
          "movl %[mantissa], %[f];" //set mantissa
          "shll $23, %[exponent];"
          "orl  %[exponent], %[f];" //set exponent
          "orl  %[sign], %[f]"  //set the sign
          :
          [f] "+r" (f)://output
          [mantissa] "r" (mantissa),
          [exponent] "r" (exponent),
          [sign] "r" (sign)://input
          );//clobber
  return f;
}//packFloat
//

bool MyFloat::operator==(float f) const {
    return f == packFloat();
}
