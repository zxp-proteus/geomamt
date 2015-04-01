      SUBROUTINE D01JAZ(IRAD2,X)
C     MARK 10 RELEASE. NAG COPYRIGHT 1982.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     **************************************************************
C
C     D01JAZ GENERATES, AT EACH CALL, A NEW GRID POINT
C     (X(1),...,X(N)) LYING ON THE REGULAR LATTICE WITH MESH
C     SIZE H, AT DISTANCE R=(IRAD2*H)**0.5 OF THE CENTRE OF THE
C     SPHERE. THE POINTS WHOSE COMPONENTS X(I) I=1...N ARE AN EVEN
C     MULTIPLE OF H MUST NOT BE GENERATED, BECAUSE THEY HAVE ALREADY
C     BEEN USED IN THE PREVIOUS APPROXIMATIONS.
C
C     MAJOR VARIABLES
C     --------------
C
C     IX     - THE PERMUTATION IX(1)...IX(N) IS GENERATED BY THE
C              ROUTINE D01JAX AND SATISFIES THE CONDITION
C                   IX(1)**2 + ... + IX(N)**2 = IRAD2.   (1)
C              STARTING FROM THIS PERMUTATION, D01JAZ GENERATES THE
C              POINTS (X(1),...,X(N)) SATISFYING
C                    ABS(X(I)) / H = IX(I)   I=1...N.     (2)
C     ITEL   - D01JAZ WAS ALREADY CALLED ITEL TIMES WITH THE GIVEN
C              VALUE OF IRAD2 AND THE GIVEN PERMUTATION
C              IX(1)...IX(N). WHEN ITEL=0, D01JAX IS CALLED TO
C              GENERATE A NEW PERMUTATION, SATISFYING (1).
C     INOG   - WHEN INOG=0, ALL THE GRID POINTS LYING AT DISTANCE
C              R ARE GENERATED.
C
C     **************************************************************
C
C     .. Scalar Arguments ..
      INTEGER           IRAD2
C     .. Array Arguments ..
      DOUBLE PRECISION  X(4)
C     .. Scalars in Common ..
      DOUBLE PRECISION  H
      INTEGER           INDEX, INDNN, INOG, IREST, ITEL, ITELMX, N,
     *                  NMIN, NPLUS
C     .. Arrays in Common ..
      DOUBLE PRECISION  Y(4)
      INTEGER           IX(4), IX2(4), NOTNUL(4)
C     .. Local Scalars ..
      DOUBLE PRECISION  TEK
      INTEGER           I, J, J2, NI
C     .. External Subroutines ..
      EXTERNAL          D01JAX
C     .. Intrinsic Functions ..
      INTRINSIC         DBLE
C     .. Common blocks ..
      COMMON            /AD01JA/H, Y, ITEL, ITELMX, NOTNUL, INDNN
      COMMON            /BD01JA/N, NMIN, NPLUS, IX, IX2, INDEX, INOG,
     *                  IREST
C     .. Executable Statements ..
      IF (ITEL.NE.0) GO TO 60
      CALL D01JAX(IRAD2)
      IF (INOG.EQ.0) GO TO 100
      INDNN = 0
      DO 40 I = 1, N
         IF (IX(I).EQ.0) GO TO 20
         INDNN = INDNN + 1
         NOTNUL(INDNN) = I
         Y(INDNN) = DBLE(IX(I))*H
         GO TO 40
   20    X(I) = 0.D0
   40 CONTINUE
      ITELMX = 2**INDNN
   60 ITEL = ITEL + 1
      J = ITEL
      DO 80 I = 1, INDNN
         J2 = J/2
         TEK = 1.D0
         IF (J-J2*2.NE.0) TEK = -1.D0
         NI = NOTNUL(I)
         X(NI) = TEK*Y(I)
         J = J2
   80 CONTINUE
      IF (ITEL.EQ.ITELMX) ITEL = 0
  100 RETURN
      END