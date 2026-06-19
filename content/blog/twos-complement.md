---
title: Two's Complement
date: 2026-01-22
description: Some notes on the concept
---
Two's Complement is a way to represent positive and negative numbers in binary. It's useful because we want a way to represent each number's inverse within a limited number of bits.

## The sign bit

Putting aside two's complement, the "naive" way to represent a negative number is to simply use its highest order bit as a "sign" bit. That is, `0` for positive and `1` for negative. 

With 4 bits:
```
 5 = 0101
-5 = 1101
```

With 8 bits:
```
 5 = 00000101
-5 = 10000101
```

However with this method, arithmetic operations come out wrong. for example:
```
5 + (-5) = 2

 0101
+1101
-----
10010 = 2
```

We also have the curious existence of `-0`, if we flip the sign bit on `0`:
```
 0 = 0000
-0 = 1000
```

So we need a better method.

## One's Complement

This method inverts all the bits in a number to get its positive/negative equivalent, or "complement". The reason it's called *One's* Complement is that adding a number to its inverse results in a sequence of all ones: `1111`.

Notice that left-most bit still acts as a sign bit:
```
 5 = 0101
-5 = 1010

 7 = 0111
-7 = 1000
```

Unfortunately we still have `-0`, but arithmetic operations are *more* correct than before:
```
 0 = 0000
-0 = 1111

5 + (-5) = -0

 0101
+1010
-----
 1111 = -0
```

In fact, arithmetic results seem to be off by one:
```
5 + (-3) = 1

   0101
+  1100
-------
(1)0001 = 1 (should be 2)

6 + (-2) = 3

   0110
+  1101
-------
(1)0011 = 3 (should be 4)
```

By adding 1 to any of the above results, we can get the correct result.

## Two's Complement

With Two's Complement we get rid of `-0`, which shifts the negative numbers over by one. For example, `-1` in One's Complement is `1110`, whereas in Two's Complement it is `1111`. This has the effect of "incrementing" it in binary, thereby giving us the added 1 we wanted in order to achieve correct arithmetic results.

This method is called *Two's* Complement because when adding a number to its inverse, each addition operation results in the binary value for 2. This effectively "carries the one" all the way over to the left and into the overflow, giving us a sequence of zeroes. And any number added to its inverse should indeed be zero.

```
5 + (-5) = 0

   0101
+  1011
-------
(1)0000 = 0
```

Another interesting property of Two's Complement is the place values. From right to left in a 4-bit sequence, we have 1's, 2's, and 4's places as expected. However the final bit is actually the -8's place. 

For example:

```
1000    -8 (-8 + 0 + 0 + 0) = -8
1001    -7 (-8 + 0 + 0 + 1) = -7
1010    -6 (-8 + 0 + 2 + 0) = -6
.
.
.
1111    -1 (-8 + 4 + 2 + 1) = -1
```

So in addition to acting as the sign bit, that left-most bit also has mathematical meaning, which is what allows the arithmetic to work out.

### Inverting a number in Two's Complement

To invert a number in Two's Complement, we need to flip its bits and add one. This is one more step than with One's Complement, where we only need to flip the bits. 

```
0101 = 5
1010 (flip bits)
1011 = -5 (add one)
```

This is fairly trivial, but something that hardware designers need to keep in mind when building circuits that perform arithmetic.