      SUBROUTINE E01AEF(M,XMIN,XMAX,X,Y,IP,N,ITMIN,ITMAX,A,WRK,LWRK,
     *                  IWRK,LIWRK,IFAIL)
C     MARK 8 RELEASE. NAG COPYRIGHT 1979.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     *******************************************************
C
C     NPL ALGORITHMS LIBRARY ROUTINE PINTRP
C
C     CREATED 17 07 79.  UPDATED 14 05 80.  RELEASE 00/42
C
C     AUTHORS ... GERALD T. ANTHONY, MAURICE G. COX,
C                 J. GEOFFREY HAYES AND MICHAEL A. SINGER.
C     NATIONAL PHYSICAL LABORATORY, TEDDINGTON,
C     MIDDLESEX TW11 OLW, ENGLAND
C
C     *******************************************************
C
C     E01AEF. A ROUTINE, WITH CHECKS, WHICH DETERMINES AND
C     REFINES A POLYNOMIAL INTERPOLANT  Q(X)  TO DATA WHICH
C     MAY CONTAIN DERIVATIVES.
C
C     INPUT PARAMETERS
C        M        NUMBER OF DISTINCT X-VALUES
C        XMIN,
C        XMAX     LOWER AND UPPER ENDPOINTS OF INTERVAL
C        X        INDEPENDENT VARIABLE VALUES (DISTINCT)
C        Y        VALUES AND DERIVATIVES OF
C                    DEPENDENT VARIABLE.
C        IP       HIGHEST ORDER OF DERIVATIVE AT EACH X-VALUE.
C        N        NUMBER OF INTERPOLATING CONDITIONS.
C                    N = M + IP(1) + IP(2) + ... + IP(M).
C        ITMIN,
C        ITMAX    MINIMUM AND MAXIMUM NUMBER OF ITERATIONS TO BE
C                    PERFORMED.
C
C     OUTPUT PARAMETERS
C        A        CHEBYSHEV COEFFICIENTS OF  Q(X)
C
C     WORKSPACE (AND ASSOCIATED DIMENSION) PARAMETERS
C        WRK      REAL WORKSPACE ARRAY.  THE FIRST IMAX ELEMENTS
C                    CONTAIN, ON EXIT, PERFORMANCE INDICES FOR
C                    THE INTERPOLATING POLYNOMIAL, AND THE NEXT
C                    N  ELEMENTS THE COMPUTED RESIDUALS
C        LWRK     DIMENSION OF WRK. LWRK MUST BE AT LEAST
C                    7*N + 5*IMAX + M + 2, WHERE
C                    IMAX IS ONE MORE THAN THE LARGEST ELEMENT
C                    OF THE ARRAY IP.
C        IWRK     INTEGER WORKSPACE ARRAY.  ON EXIT,  IWRK(1)
C                    CONTAINS THE NUMBER OF ITERATIONS TAKEN
C        LIWRK    DIMENSION OF IWRK.  AT LEAST 2*M + 2.
C
C     FAILURE INDICATOR PARAMETER
C        IFAIL    FAILURE INDICATOR.
C                    0 - SUCCESSFUL TERMINATION.
C                    1 - AT LEAST ONE OF THE FOLLOWING CONDITIONS
C                        HAS BEEN VIOLATED -
C                           M AT LEAST 1,
C                           N = M + IP(1) + IP(2) + ... + IP(M),
C                           LWRK AT LEAST 7*N + 5*IMAX + M + 2,
C                           LIWRK AT LEAST 2*M + 2.
C                    2 - FOR SOME I, IP(I) IS LESS THAN 0.
C                    3 - AT LEAST ONE OF THE FOLLOWING CONDITIONS
C                        HAS BEEN VIOLATED -
C                           XMIN STRICTLY LESS THAN XMAX,
C                           FOR EACH I, X(I) MUST LIE IN THE
C                              INTERVAL XMIN TO XMAX,
C                           THE X-VALUES MUST ALL BE DISTINCT
C                    4 - NOT ALL PERFORMANCE INDICES LESS THAN
C                        ONE, BUT ITMAX ITERATIONS PERFORMED,
C                    5 - COMPUTATION TERMINATED BECAUSE
C                        ITERATIONS DIVERGING.
C
C
C     CHECK AND SET ITERATION LIMITS
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='E01AEF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  XMAX, XMIN
      INTEGER           IFAIL, ITMAX, ITMIN, LIWRK, LWRK, M, N
C     .. Array Arguments ..
      DOUBLE PRECISION  A(N), WRK(LWRK), X(M), Y(N)
      INTEGER           IP(M), IWRK(LIWRK)
C     .. Local Scalars ..
      DOUBLE PRECISION  XI
      INTEGER           I, IERROR, IMAX, IP1, ITMAX1, ITMIN1, J, NN
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          E01AEW
C     .. Executable Statements ..
      ITMIN1 = ITMIN
      ITMAX1 = ITMAX
      IF (ITMIN1.LE.0) ITMIN1 = 2
      IF (ITMAX1.LE.0) ITMAX1 = 10
      IF (ITMAX1.LT.ITMIN1) ITMAX1 = ITMIN1
C
C     FIRST SET OF CHECKS ON INPUT DATA
C
      IERROR = 1
C
      IF (M.LT.1) GO TO 100
C
C     DETERMINE  IMAX = MAX(IP(I) + 1),  AND  NN = SUM
C     OF VALUES OF  (IP(I) + 1)  FOR COMPARISON WITH  N
C
      IMAX = 0
      NN = M
      DO 20 I = 1, M
         IF (IP(I).GT.IMAX) IMAX = IP(I)
         NN = NN + IP(I)
   20 CONTINUE
      IMAX = IMAX + 1
C
C     REMAINDER OF FIRST SET OF INPUT DATA CHECKS
C
      IF (NN.NE.N) GO TO 100
      IF (LWRK.LT.7*N+5*IMAX+M+2) GO TO 100
      IF (LIWRK.LT.2*M+2) GO TO 100
C
C     SECOND SET OF CHECKS ON INPUT DATA
C
      IERROR = 2
      DO 40 I = 1, M
         IF (IP(I).LT.0) GO TO 100
   40 CONTINUE
C
C     THIRD SET OF CHECKS ON INPUT DATA
C
      IERROR = 3
      IF (XMIN.GE.XMAX) GO TO 100
      DO 80 I = 1, M
         XI = X(I)
         IF (XI.LT.XMIN .OR. XI.GT.XMAX) GO TO 100
         IF (I.EQ.M) GO TO 80
         IP1 = I + 1
         DO 60 J = IP1, M
            IF (XI.EQ.X(J)) GO TO 100
   60    CONTINUE
   80 CONTINUE
C
C     END OF CHECKS ON INPUT DATA
C
      IERROR = 0
C
C     INDICATE THAT ZEROIZING POLYNOMIAL  Q0(X)  IS
C     NOT REQUIRED
C
      IWRK(1) = 0
      CALL E01AEW(M,XMIN,XMAX,X,Y,IP,N,N+1,ITMIN1,ITMAX1,A,WRK,WRK,LWRK,
     *            IWRK,LIWRK,IERROR)
C
C     SET APPROPRIATE VALUE FOR FAILURE INDICATOR
C
      IF (IERROR.NE.0) IERROR = IERROR + 3
  100 IFAIL = P01ABF(IFAIL,IERROR,SRNAME,0,P01REC)
      RETURN
C
C     END E01AEF
C
      END