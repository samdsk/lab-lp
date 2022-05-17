You have to write a class `Matrix` to represent and manipulate integer matrices. The class should be parametric on its dimensions and will provide the operations of matrix equivalence, matrix copy, matrix addition, scalar-matrix multiplication, matrix-matrix multiplication, matrix transposition, and matrix norm -- the "size" of a matrix. Override the appropriate operators and raise the appropriate exceptions.

The following gives the semantics of such operations.

Let aij denote the i,j-th element of matrix A, located at row i, column j. Using this notation, the matrix operations listed above may be defined precisely as follows:

*    **matrix equivalence** A ≃ B where A in Zm×n, B in Zp×q when m = p and n = q and bij = aij for i = 1,...,m j = 1,...,n;
*    **matrix copy** B = A where A, B in Zm×n (bij = aij for i = 1,...,m j = 1,...,n);
*    **matrix addition** C = A + B where A, B, C in Zm×n (cij = aij + bij for i = 1,...,m j = 1,...,n);
*    **scalar-matrix multiplication** B = aA where A, B in Zm×n, a in Z (bij = a·aij for i = 1,...,m j = 1,...,n);
*    **matrix-matrix multiplication** C = A·B where A in Zm×p, B in Zp×n, C in Zm×n (cij = Σk=1, ..., p aik·bkj for i = 1,...,m j = 1,...,n);
*    **matrix transposition** B = AT where A in Zm×n, B in Zn×m (bji = aij for i = 1,...,m j = 1,...,n);
*    **matrix norm (matrix 1-norm)** a = ‖A‖ where a in Z, A in Zm×n (a = maxj Σi | aij | for i = 1,...,m j = 1,...,n).

**Note** that in each case we state the proper matrix dimensions for the operation to be valid. For example, when multiplying two matrices A and B, the number of columns of A must match the number of rows of B.