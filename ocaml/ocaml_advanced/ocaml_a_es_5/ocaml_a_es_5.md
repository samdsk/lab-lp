# Exercise 5: A Matrix Class.

* You have to write a module `Matrix` to represent and manipulate integer matrices. The module should be parametric and will provide the operations of matrix equivalence, matrix copy, matrix addition, scalar-matrix multiplication, matrix-matrix multiplication, matrix transposition, and matrix norm -- the "size" of a matrix. Override the appropriate operators and raise the appropriate exceptions.

We first define these operations, and then give a skeleton of the Matrix module showing the signatures for all methods and constructors you must implement.

**The operations**

Let aᵢⱼ denotes the i,j-th element of matrix A, located at row i, column j. Using this notation, the matrix operations listed above may be defined precisely as follows:

-    matrix equivalence A ≃ B where A in Ζᵐˣⁿ, B in Zp×q when m = p and n = q and bᵢⱼ = aᵢⱼ for i = 1,...,m j = 1,...,n;
-    matrix copy B = A where A, B in Ζᵐˣⁿ (bᵢⱼ = aᵢⱼ for i = 1,...,m j = 1,...,n);
-    matrix addition C = A + B where A, B, C in Ζᵐˣⁿ (cᵢⱼ = aᵢⱼ + bᵢⱼ for i = 1,...,m j = 1,...,n);
-   scalar-matrix multiplication B = aA where A, B in Ζᵐˣⁿ, a in Z (bᵢⱼ = a·aᵢⱼ for i = 1,...,m j = 1,...,n);
-    matrix-matrix multiplication C = A·B where A in Zᵐˣᵖ, B in Zᵖˣⁿp×n, C in Ζᵐˣⁿ (cᵢⱼ = Σₖ=1, ..., p aᵢₖ·bₖⱼ for i = 1,...,m j = 1,...,n);
-    matrix transposition B = AT where A in Ζᵐˣⁿ, B in Zⁿˣᵐ (bⱼᵢ = aᵢⱼ for i = 1,...,m j = 1,...,n);
-    matrix norm (matrix 1-norm) a = ‖A‖ where a in Z, A in Ζᵐˣⁿ (a = maxⱼ Σᵢ | aᵢⱼ | for i = 1,...,m j = 1, ..., n).

**Note** that in each case we state the proper matrix dimensions for the operation to be valid. For example, when multiplying two matrices A and B, the number of columns of A must match the number of rows of B.