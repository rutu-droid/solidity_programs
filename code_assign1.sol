

//Write a program to declare one state variable of uint type and assign 5 to it.
// And in the same program declare one local varaible inside a function localVariable()

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Demo {
    uint public a = 5; 
    function localVariable() public pure {
        uint num = 5;
    }
    
}

//*que2
//Write a program in solidity to return the sum of two numbers passed as an argument to the add().

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Demo {
  
    function add(uint a,uint b) public pure returns (uint){
     return a+b;
    }   
}

//*que 3
//Write a program to find the sum of the first five natural numbers.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Demo {
    uint public sum;
    function add() public returns (uint){
       
     for (uint a=1; a<=5; a++) 
     {
         sum +=a;
     }
     return sum;
    }
}  
//*que 4 Write a program in solidity where function greater(uint a,uint b) returns the greatest number.  

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Demo {
    function greater(uint a,uint b) public pure returns (uint){
       if (a==b) {
           return 0;
       }else if (a<b) {
           return 1;
       }else{
           return 2;
       }
    }
}   
 //que 5 write a program to calculate given no.

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 contract number{

     function cube(uint a) public pure returns(uint){
         return a*a*a;
     }
 }   

 //write a program to check whether a given no.is even or odd.if even return 1 else return 0.

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 contract number {

     function isEvenOdd(uint a)public pure returns(uint){
         if(a % 2 == 0){
             return 1;
         }else {
             return 0;
         }
     }    
 } 

 // write a program to calculate average of three no.

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 contract average {
     uint public avg;

     function Average(uint a,uint b,uint c) public  returns(uint){
         avg = (a+b+c)/3;
         return avg;
     } 
 }

 que 8 //write a program to swap two numbers using a third variable.

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 contract Swap {
     function swap(uint a ,uint b )public pure returns(uint ,uint ){
      uint temp=a;
       a = b ; 
       b = temp;
       return (a,b);
     }    
 } 

 // que 9 write a program to calculate the power of a number where x and y are two numbers and you have to calculate x^y
 
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 contract Power {
     function power(uint exp, uint base)public pure returns (uint){
        uint result = 1;
        while (exp != 0) {
        result *= base;
        --exp;
        }
        return result;
     }
 }

 //que 10 write a program to calculate two numbers without using third variable

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 contract Swap {
     function swap(uint num1,uint num2) public pure returns (uint ,uint){
         num1 = num1 + num2;
         num2 = num1 - num2;
         num1 = num1 - num2;
         return (num1,num2);
     }
 }

 //QUE 11: write a program to check given no is prime no or not if prime return 1 else 0;

 
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract prime {
     function primeno(uint num)public pure returns(uint){
         for (uint i=2; i<num ; i++) 
         {
             if(num % i == 0){
                 return 1;
             }else{
                 return 0;
             }
         }
     }
 }

 //que 12 : write a program to check whether an integer is an armstrong number or not

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Armstrong {
      function isArmstrong(uint number) public pure returns (uint) {
        uint originalNumber = number;
        uint sum = 0;
        uint numDigits = 0;

        while (number > 0) {
            numDigits++;
            number /= 10;
        }

        number = originalNumber;

        while (number > 0) {
            uint digit = number % 10;
            sum += digit**numDigits;
            number /= 10;
        }

        return sum ;
    }
}

//que 13: write a program to find the greatest among three numbers;

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Greatest {
    function greatestNumber(uint a,uint b, uint c) public pure returns(string memory){
        if(a !=b && a > b && a !=c && a > c){
            return "a is greatest";
        }else if( b != a && a < b && b !=c && b> c){
            return "b is greatest";
        }else{
            return "c is greatest";
        }
    }
}

//que 14 : write a program to check whether the number is a palindrome or not .if palindrome return 1 else 0

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Palindrome {
    function isNumberPalindrome(uint number) public pure returns (bool) {
        uint originalNumber = number;
        uint reversedNumber = 0;

        while (number > 0) {
            uint digit = number % 10;
            reversedNumber = reversedNumber * 10 + digit;
            number /= 10;
        }

        return reversedNumber == originalNumber;
    }
}


// que 15 : write a program to reverse an intager.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract reverse {
     function reverseno(uint a) public pure returns(uint){
         uint rno;
         while(a != 0){
            rno = rno * 10 + a %10;
            a= a/10;
         }
         return rno;
     }
 }

 //que 16: write a program to find the sum of the digits of no.

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Sum {
     function sumOf(uint number)public pure returns(uint) {
         uint sum;
        while(number != 0){
            sum += number % 10;
            number /= 10;
         }
         return sum;
     }    
 }

// que 17: write a program to calculate the factorial of the no.

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Factorial {
     function factorialOf(uint number)public pure returns(uint) {
         uint factor =1 ;
       for (uint i =1 ; i <= number; i++) 
       {
           factor =factor * i; 
       }
         return factor;
     }    
 }
  
//que 18: Write a program to find the nth fibonacci number

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Fibonacci {
    function fibonacciNum(uint n) public pure returns(uint  ){
      if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        } else {
            uint a = 0;
            uint b = 1;
            uint result;
            for (uint i = 2; i <= n; i++) {
                result = a + b;
                a = b;
                b = result;
                 return result;
            }
           
        }
    }
}

// que 19 : write a program  to do multiplication without using multiplication operators

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract MultiplicationWithoutOperator {
    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result = 0;
        for (uint256 i = 0; i < b; i++) {
            result += a;
        }
        return result;
    }
}*/
