      SUBROUTINE E04KBU(IFLAG,N,NFREE,EPS,X,BL,BU,ISTATE,SFUN,STEP,FNEW,
     *                  NFUN,P,Y,GY,IS,IFAIL,IW,LIW,W,LW)
C
C     MARK 6 RELEASE NAG COPYRIGHT 1977
C     MARK 6B REVISED IER-128 (JUL 1978)
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     **************************************************************
C
C     E04KBU (LOCSD1) FORMS THE SEARCH-DIRECTION VECTOR P, WITH
C     NON-ZERO ELEMENTS (CORRESPONDING TO THE FREE VARIABLES) OF + 1
C     OR - 1, THAT GIVES THE MAXIMUM FEASIBLE POSITIVE STEP-LENGTH
C     (SPOS) FROM THE POINT X. IT THEN TRIES, BY TAKING A SERIES OF
C     INCREASING STEPS IN THE POSITIVE DIRECTION, TO FIND A FEASIBLE
C     POINT Y SUCH THAT F(Y) DIFFERS SIGNIFICANTLY FROM F(X). IN THE
C     SPECIAL CASE WHEN ONLY ONE VARIABLE (X(IS)) IS FREE, IF EITHER
C     F(X + SPOS*P) IS TOO CLOSE TO F(X) OR F(Y) IS GREATER THAN
C     F(X), A FURTHER ATTEMPT IS MADE BY TAKING THE MAXIMUM FEASIBLE
C     STEP IN THE NEGATIVE DIRECTION (SNEG).
C
C     PHILIP E. GILL, WALTER MURRAY, SUSAN M. PICKEN, MARGARET H.
C     WRIGHT AND ENID M. R. LONG, D.N.A.C., NATIONAL PHYSICAL
C     LABORATORY, ENGLAND
C
C     **************************************************************
C
C     SFUN
C     .. Scalar Arguments ..
      DOUBLE PRECISION  EPS, FNEW, STEP
      INTEGER           IFAIL, IFLAG, IS, LIW, LW, N, NFREE, NFUN
C     .. Array Arguments ..
      DOUBLE PRECISION  BL(N), BU(N), GY(N), P(N), W(LW), X(N), Y(N)
      INTEGER           ISTATE(N), IW(LIW)
C     .. Subroutine Arguments ..
      EXTERNAL          SFUN
C     .. Local Scalars ..
      DOUBLE PRECISION  DL, DPOS, DU, OLDF, SNEG, SPOS, STPNEG, TEMP, XJ
      INTEGER           J
C     .. Intrinsic Functions ..
      INTRINSIC         ABS
C     .. Executable Statements ..
      IFAIL = 5
      OLDF = FNEW
      SPOS = 1.0D+6
      TEMP = EPS*(1.0D+0+ABS(OLDF))
      STPNEG = -STEP
      DO 80 J = 1, N
         IF (ISTATE(J).LE.0) GO TO 60
         XJ = X(J)
         IS = J
         DL = XJ - BL(J)
         DU = BU(J) - XJ
         IF (DU.LT.DL) GO TO 20
         P(J) = 1.0D+0
         DPOS = DU
         SNEG = -DL
         GO TO 40
   20    P(J) = -1.0D+0
         DPOS = DL
         SNEG = -DU
   40    IF (SPOS.GT.DPOS) SPOS = DPOS
         GO TO 80
   60    P(J) = 0.0D+0
   80 CONTINUE
      IF (STEP.LE.SPOS) GO TO 120
      IF (NFREE.GT.1) RETURN
  100 IF (SNEG.GT.STPNEG) RETURN
      STEP = SNEG
  120 DO 140 J = 1, N
         Y(J) = X(J) + STEP*P(J)
  140 CONTINUE
      CALL SFUN(IFLAG,N,Y,FNEW,GY,IW,LIW,W,LW)
      NFUN = NFUN + 1
      IF (IFLAG.LT.0) RETURN
      IF (ABS(FNEW-OLDF).GE.TEMP) GO TO 160
      IF (STEP.LT.0.0D+0) RETURN
      STEP = 5.0D+0*STEP
      IF (STEP.LE.SPOS) GO TO 120
      IF (NFREE.EQ.1) GO TO 100
      RETURN
  160 IF (NFREE.EQ.1 .AND. STEP.GT.0.0D+0 .AND. FNEW.GT.OLDF) GO TO 100
      IF (NFREE.GT.1 .OR. FNEW.LE.OLDF) IFAIL = 0
      RETURN
C
C     END OF E04KBU (LOCSD1)
C
      END