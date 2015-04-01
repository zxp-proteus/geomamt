      SUBROUTINE F04AXF(N,A,LICN,ICN,IKEEP,RHS,W,MTYPE,IDISP,RESID)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     DERIVED FROM HARWELL LIBRARY ROUTINE MA28C
C
C     THE PARAMETERS ARE AS FOLLOWS ....
C     N     INTEGER  ORDER OF MATRIX  NOT ALTERED BY SUBROUTINE.
C     A     REAL ARRAY  LENGTH LICN.  THE SAME ARRAY AS WAS USED
C     .     IN THE MOST RECENT CALL TO F01BRF OR F01BSF.
C     LICN  INTEGER  LENGTH OF ARRAYS A AND ICN.  NOT ALTERED BY
C     .     SUBROUTINE.
C     ICN   INTEGER ARRAY  LENGTH LICN.  SAME ARRAY AS OUTPUT FROM
C     .     F01BRF.  UNCHANGED BY F04AXF.
C     IKEEP INTEGER ARRAY  LENGTH 5*N.  SAME ARRAY AS OUTPUT FROM
C     .     F01BRF.  UNCHANGED BY F04AXF.
C     RHS   REAL ARRAY  LENGTH N.  ON ENTRY, IT HOLDS THE
C     .     RIGHT HAND SIDE.  ON EXIT, THE SOLUTION VECTOR.
C     W     REAL ARRAY  LENGTH N. USED AS WORKSPACE BY
C     .     F04AXZ.
C     MTYPE INTEGER  USED TO TELL F04AXZ TO SOLVE THE DIRECT
C     .     EQUATION (MTYPE=1) OR ITS TRANSPOSE (MTYPE.NE.1).
C     IDISP INTEGER ARRAY LENGTH 2.  SAME ARRAY AS OUTPUT BY
C     .     F01BRF.  IT IS UNCHANGED BY F04AXF.
C     RESID REAL VARIBLE. RETURNS MAXIMUM RESIDUAL OF EQUATIONS
C     .     WHERE PIVOT WAS ZERO.
C
C
C     F04AXZ PREFORMS THE SOLUTION OF THE SET OF EQUATIONS
C     .. Scalar Arguments ..
      DOUBLE PRECISION  RESID
      INTEGER           LICN, MTYPE, N
C     .. Array Arguments ..
      DOUBLE PRECISION  A(LICN), RHS(N), W(N)
      INTEGER           ICN(LICN), IDISP(2), IKEEP(N,5)
C     .. External Subroutines ..
      EXTERNAL          F04AXZ
C     .. Executable Statements ..
      CALL F04AXZ(N,ICN,A,LICN,IKEEP,IKEEP(1,4),IKEEP(1,5)
     *            ,IDISP,IKEEP(1,2),IKEEP(1,3),RHS,W,MTYPE,RESID)
      RETURN
      END