      SUBROUTINE D02KDX(X,XEND,V,COEFFN,MAXFUN,HINFO,IFAIL)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 8 REVISED. IERS-227,249 (APR 1980).
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 12A REVISED. IER-500 (AUG 1986).
C
C     COEFFN
C     .. Scalar Arguments ..
      DOUBLE PRECISION  X, XEND
      INTEGER           IFAIL, MAXFUN
C     .. Array Arguments ..
      DOUBLE PRECISION  HINFO(2), V(21)
C     .. Subroutine Arguments ..
      EXTERNAL          COEFFN
C     .. Scalars in Common ..
      DOUBLE PRECISION  BP, LAMDA, MINSC, ONE, PI, PSIGN, TWO, ZER
      INTEGER           JINT
C     .. Arrays in Common ..
      DOUBLE PRECISION  YL(3), YR(3)
C     .. Local Scalars ..
      DOUBLE PRECISION  BNEW, CACC1, CACC2, DQDL, EPSDE, FAC1, FAC2, P,
     *                  Q, SY, SYOLD, TEMP, V2OLD, X1, XMAXFN, XOLD
      INTEGER           IFAIL1
C     .. Local Arrays ..
      DOUBLE PRECISION  CIN(6), COMM(5), CONST(3), W(3,7)
C     .. External Functions ..
      DOUBLE PRECISION  D02KDS, D02KDU
      EXTERNAL          D02KDS, D02KDU
C     .. External Subroutines ..
      EXTERNAL          D02KDV, D02KDW, D02KDY
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MAX, SIGN, LOG, COS, DBLE, SIN
C     .. Common blocks ..
      COMMON            /AD02KD/ZER, ONE, TWO, PI, LAMDA, PSIGN, MINSC,
     *                  BP, YL, YR, JINT
C     .. Data statements ..
      DATA              COMM(1), COMM(2), COMM(3), COMM(4),
     *                  COMM(5)/0.D0, 0.D0, 0.D0, 1.D0, 0.D0/, CONST(1),
     *                  CONST(2), CONST(3)/0.D0, 0.D0, 0.D0/,
     *                  CIN(2)/1.D0/, CACC1/4.D0/
C     .. Executable Statements ..
      CACC2 = LOG(CACC1)
      CIN(1) = ONE
      CIN(3) = ZER
      CIN(4) = HINFO(1)
      CIN(5) = HINFO(2)
C     IF MAXFUN.LE.0 ADD ON BIG QUANTITY
      XMAXFN = ZER
      IF (MAXFUN.LE.0) XMAXFN = 32767.D0
      COMM(1) = DBLE(MAXFUN) + XMAXFN
C     GIVE CIN(6) A STARTING VALUE AS IT IS USED IN CALCULATING BP
      CIN(6) = CIN(5)
      IF (CIN(6).EQ.ZER) CIN(6) = (XEND-X)*0.125D0
C     RE-SCALE PRUFER VARIABLES IF NECESSARY
      BNEW = D02KDU(X,COEFFN)
      IF (BNEW.NE.V(1)) CALL D02KDV(V,BNEW,IFAIL)
C     INITIAL EVALUATION OF BP
      IF (X.EQ.XEND) GO TO 120
      X1 = X + CIN(6)
C     INITIAL EVALUATION OF INTEGRAND FOR SENSITIVITY INTEGRAL
      CALL COEFFN(P,Q,DQDL,X,LAMDA,JINT)
      TEMP = MAX(D02KDU(X1,COEFFN)-V(1),-ABS(Q*CIN(6)))
      BP = TEMP/CIN(6)
      SY = D02KDS(V(3)-V(5))*DQDL/V(1)
C     STORE INITIAL P(X) IN COMMON SO AUX CAN CHECK SIGN CHANGE
      PSIGN = SIGN(ONE,P)
      IF (PSIGN.EQ.ZER) GO TO 180
C
C     MAIN LOOP - ADVANCES INTEGRATION ONE STEP
C
   20 CONTINUE
C     SET SOFT FAIL
      IFAIL1 = 1
C     SET LOCAL ERROR TOLERANCE FOR THIS STEP
      EPSDE = D02KDS(V(5)-V(3))
      EPSDE = EPSDE/(ONE+100.D0*EPSDE)
C     STORE OLD VALUES FOR SENSITIVITY INTEGRAL
      XOLD = X
      SYOLD = SY
      V2OLD = V(2)
C
      CALL D02KDY(X,XEND,3,V,CIN,EPSDE,D02KDW,COMM,CONST,V(8)
     *            ,W,3,7,COEFFN,COEFFN,HINFO,1,IFAIL1)
C
C     PSIGN SET TO 0 SHOWS P(X) ZERO OR CHANGED SIGN
      IF (PSIGN.EQ.ZER) GO TO 180
      IF (IFAIL1.NE.0) GO TO 160
C
C     ADVANCE ESTIMATE OF SENSITIVITY INTEGRAL
      CALL COEFFN(P,Q,DQDL,X,LAMDA,JINT)
      SY = D02KDS(V(3)-V(5))*DQDL/V(1)
      TEMP = V(2) - V2OLD
      IF (ABS(TEMP).LE.0.75D0) GO TO 40
      FAC1 = ONE - (SIN(V(2))-SIN(V2OLD))/TEMP
      FAC2 = FAC1
      GO TO 60
   40 FAC1 = ONE - COS(V2OLD)
      FAC2 = ONE - COS(V(2))
   60 CONTINUE
      V(4) = V(4) + (X-XOLD)*(SYOLD*FAC1+SY*FAC2)/TWO
C     CHECK IF ACCURACY UNNECESSARILY HIGH
   80 IF (ABS(V(4)*V(7)).LE.CACC1) GO TO 100
      V(4) = V(4)/CACC1
      SY = SY/CACC1
      V(5) = V(5) + CACC2
      GO TO 80
  100 CONTINUE
C
C     PREPARE FOR NEXT STEP, AND LOOP BACK
      IF (X.NE.X1) CALL D02KDV(V,D02KDU(X,COEFFN),IFAIL)
      IF (X.EQ.XEND) GO TO 120
      IF (CIN(1).NE.5.D0) GO TO 200
      X1 = X + CIN(6)
      IF (ABS(XEND-X).LT.ABS(CIN(6))) GO TO 110
      TEMP = MAX(D02KDU(X1,COEFFN)-V(1),-ABS(Q*CIN(6)))
      BP = TEMP/CIN(6)
  110 CONTINUE
      CALL D02KDW(3,X,V,W(1,1),COEFFN,COEFFN,1,HINFO)
      COMM(1) = COMM(1) - ONE
C     AND LOOP BACK
      IF (COMM(1).GT.ZER) GO TO 20
      IFAIL1 = 5
      GO TO 160
C     BEFORE EXIT, SET OUTPUT VALUES ETC.
  120 IFAIL = 0
  140 MAXFUN = COMM(1) - XMAXFN
      HINFO(2) = CIN(5)
      RETURN
C
C     FAILURE EXITS
  160 IFAIL = IFAIL1
      V(18) = EPSDE
      GO TO 140
  180 IFAIL = 8
      V(18) = EPSDE
      GO TO 140
  200 IFAIL = 9
      V(18) = CIN(1)
      GO TO 140
      END