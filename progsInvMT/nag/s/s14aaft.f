      DOUBLE PRECISION FUNCTION S14AAF(X,IFAIL)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 7C REVISED IER-184 (MAY 1979)
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     GAMMA FUNCTION
C
C     **************************************************************
C
C     TO EXTRACT THE CORRECT CODE FOR A PARTICULAR MACHINE-RANGE,
C     ACTIVATE THE STATEMENTS CONTAINED IN COMMENTS BEGINNING  CDD ,
C     WHERE  DD  IS THE APPROXIMATE NUMBER OF SIGNIFICANT DECIMAL
C     DIGITS REPRESENTED BY THE MACHINE
C     DELETE THE ILLEGAL DUMMY STATEMENTS OF THE FORM
C     * EXPANSION (NNNN) *
C
C     ALSO INSERT APPROPRIATE DATA STATEMENTS TO DEFINE CONSTANTS
C     WHICH DEPEND ON THE RANGE OF NUMBERS REPRESENTED BY THE
C     MACHINE, RATHER THAN THE PRECISION (SUITABLE STATEMENTS FOR
C     SOME MACHINES ARE CONTAINED IN COMMENTS BEGINNING CRD WHERE
C     D IS A DIGIT WHICH SIMPLY DISTINGUISHES A GROUP OF MACHINES).
C     DELETE THE ILLEGAL DUMMY DATA STATEMENTS WITH VALUES WRITTEN
C     *VALUE*
C
C     **************************************************************
C
C     .. Parameters ..
      CHARACTER*6                      SRNAME
      PARAMETER                        (SRNAME='S14AAF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION                 X
      INTEGER                          IFAIL
C     .. Local Scalars ..
      DOUBLE PRECISION                 G, GBIG, T, XBIG, XMINV, XSMALL,
     *                                 Y
      INTEGER                          I, M
C     .. Local Arrays ..
      CHARACTER*1                      P01REC(1)
C     .. External Functions ..
      INTEGER                          P01ABF
      EXTERNAL                         P01ABF
C     .. Intrinsic Functions ..
      INTRINSIC                        ABS, SIGN, DBLE
C     .. Data statements ..
C08   DATA XSMALL/1.0D-8/
C09   DATA XSMALL/3.0D-9/
C12   DATA XSMALL/1.0D-12/
C15   DATA XSMALL/3.0D-15/
      DATA XSMALL/1.0D-17/
C19   DATA XSMALL/1.7D-18/
C
      DATA XBIG,GBIG,XMINV/ 1.70D+2,4.3D+304,2.23D-308 /
C     XBIG = LARGEST X SUCH THAT  GAMMA(X) .LT. MAXREAL
C                            AND  1.0/GAMMA(X+1.0) .GT. MINREAL
C             (ROUNDED DOWN TO AN INTEGER)
C     GBIG = GAMMA(XBIG)
C     XMINV = MAX(1.0/MAXREAL,MINREAL)  (ROUNDED UP)
C     FOR IEEE SINGLE PRECISION
CR0   DATA XBIG,GBIG,XMINV /33.0E0,2.6E+35,1.2E-38/
C     FOR IBM 360/370 AND SIMILAR MACHINES
CR1   DATA XBIG,GBIG,XMINV /57.0D0,7.1D+74,1.4D-76/
C     FOR DEC-10, HONEYWELL, UNIVAC 1100 (S.P.)
CR2   DATA XBIG,GBIG,XMINV /34.0D0,8.7D+36,5.9D-39/
C     FOR ICL 1900
CR3   DATA XBIG,GBIG,XMINV /58.0D0,4.0D+76,1.8D-77/
C     FOR CDC 7600/CYBER
CR4   DATA XBIG,GBIG,XMINV /164.0D0,2.0D+291,3.2D-294/
C     FOR UNIVAC 1100 (D.P.)
CR5   DATA XBIG,GBIG,XMINV /171.0D0,7.3D+306,1.2D-308/
C     FOR IEEE DOUBLE PRECISION
CR7   DATA XBIG,GBIG,XMINV /170.0D0,4.3D+304,2.3D-308/
C     .. Executable Statements ..
C
C     ERROR 1 AND 2 TEST
      T = ABS(X)
      IF (T.GT.XBIG) GO TO 160
C     SMALL RANGE TEST
      IF (T.LE.XSMALL) GO TO 140
C     MAIN RANGE REDUCTION
      M = X
      IF (X.LT.0.0D0) GO TO 80
      T = X - DBLE(M)
      M = M - 1
      G = 1.0D0
      IF (M) 20, 120, 40
   20 G = G/X
      GO TO 120
   40 DO 60 I = 1, M
         G = (X-DBLE(I))*G
   60 CONTINUE
      GO TO 120
   80 T = X - DBLE(M-1)
C     ERROR 4 TEST
      IF (T.EQ.1.0D0) GO TO 220
      M = 1 - M
      G = X
      DO 100 I = 1, M
         G = (DBLE(I)+X)*G
  100 CONTINUE
      G = 1.0D0/G
  120 T = 2.0D0*T - 1.0D0
C
C      * EXPANSION (0026) *
C
C     EXPANSION (0026) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = ((((((((((((+1.88278283D-6)*T-5.48272091D-6)
C08  *    *T+1.03144033D-5)*T-3.13088821D-5)*T+1.01593694D-4)
C08  *    *T-2.98340924D-4)*T+9.15547391D-4)*T-2.42216251D-3)
C08  *    *T+9.04037536D-3)*T-1.34119055D-2)*T+1.03703361D-1)
C08  *    *T+1.61692007D-2)*T + 8.86226925D-1
C
C     EXPANSION (0026) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = (((((((((((((-6.463247484D-7)*T+1.882782826D-6)
C09  *    *T-3.382165478D-6)*T+1.031440334D-5)*T-3.393457634D-5)
C09  *    *T+1.015936944D-4)*T-2.967655076D-4)*T+9.155473906D-4)
C09  *    *T-2.422622002D-3)*T+9.040375355D-3)*T-1.341184808D-2)
C09  *    *T+1.037033609D-1)*T+1.616919866D-2)*T + 8.862269255D-1
C
C     EXPANSION (0026) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = (((((((((((((((-7.613347676160D-8)*T+2.218377726362D-7)
C12  *    *T-3.608242105549D-7)*T+1.106350622249D-6)
C12  *    *T-3.810416284805D-6)*T+1.138199762073D-5)
C12  *    *T-3.360744031186D-5)*T+1.008657892262D-4)
C12  *    *T-2.968993359366D-4)*T+9.158021574033D-4)
C12  *    *T-2.422593898516D-3)*T+9.040332894085D-3)
C12  *    *T-1.341185067782D-2)*T+1.037033635205D-1)
C12  *    *T+1.616919872669D-2)*T + 8.862269254520D-1
C
C     EXPANSION (0026) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((((((((((-1.243191705600000D-10
C15  *    *T+3.622882508800000D-10)*T-4.030909644800000D-10)
C15  *    *T+1.265236705280000D-9)*T-5.419466096640000D-9)
C15  *    *T+1.613133578240000D-8)*T-4.620920340480000D-8)
C15  *    *T+1.387603440435200D-7)*T-4.179652784537600D-7)
C15  *    *T+1.253148247777280D-6)*T-3.754930502328320D-6)
C15  *    *T+1.125234962812416D-5)*T-3.363759801664768D-5)
C15  *    *T+1.009281733953869D-4)*T-2.968901194293069D-4)
C15  *    *T+9.157859942174304D-4)*T-2.422595384546340D-3
C15   Y = ((((Y*T+9.040334940477911D-3)*T-1.341185057058971D-2)
C15  *    *T+1.037033634220705D-1)*T+1.616919872444243D-2)*T +
C15  *     8.862269254527580D-1
C
C     EXPANSION (0026) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = (((((((((((((((-1.46381209600000000D-11
     *    *T+4.26560716800000000D-11)*T-4.01499750400000000D-11)
     *    *T+1.27679856640000000D-10)*T-6.13513953280000000D-10)
     *    *T+1.82243164160000000D-9)*T-5.11961333760000000D-9)
     *    *T+1.53835215257600000D-8)*T-4.64774927155200000D-8)
     *    *T+1.39383522590720000D-7)*T-4.17808776355840000D-7)
     *    *T+1.25281466396672000D-6)*T-3.75499034136576000D-6)
     *    *T+1.12524642975590400D-5)*T-3.36375833240268800D-5)
     *    *T+1.00928148823365120D-4)*T-2.96890121633200000D-4
      Y = ((((((Y*T+9.15785997288933120D-4)*T-2.42259538436268176D-3)
     *    *T+9.04033494028101968D-3)*T-1.34118505705967765D-2)
     *    *T+1.03703363422075456D-1)*T+1.61691987244425092D-2)*T +
     *     8.86226925452758013D-1
C
C     EXPANSION (0026) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = (((((((((((((((+6.7108864000000000000D-13
C19  *    *T-1.6777216000000000000D-12)*T+6.7108864000000000000D-13)
C19  *    *T-4.1523609600000000000D-12)*T+2.4998051840000000000D-11)
C19  *    *T-6.8985815040000000000D-11)*T+1.8595971072000000000D-10)
C19  *    *T-5.6763875328000000000D-10)*T+1.7255563264000000000D-9)
C19  *    *T-5.1663077376000000000D-9)*T+1.5481318277120000000D-8)
C19  *    *T-4.6445740523520000000D-8)*T+1.3931958370304000000D-7)
C19  *    *T-4.1782339907584000000D-7)*T+1.2528422549504000000D-6)
C19  *    *T-3.7549858152857600000D-6)*T+1.1252456510305280000D-5
C19   Y = (((((((((Y*T-3.3637584239226880000D-5)
C19  *    *T+1.0092815021080832000D-4)
C19  *    *T-2.9689012151880000000D-4)*T+9.1578599714350784000D-4)
C19  *    *T-2.4225953843706897600D-3)*T+9.0403349402888779200D-3)
C19  *    *T-1.3411850570596516480D-2)*T+1.0370336342207529018D-1)
C19  *    *T+1.6169198724442506740D-2)*T + 8.8622692545275801366D-1
C
      S14AAF = Y*G
      IFAIL = 0
      GO TO 240
C
C     ERROR 3 TEST
  140 IF (T.LT.XMINV) GO TO 200
      S14AAF = 1.0D0/X
      IFAIL = 0
      GO TO 240
C
C     ERROR EXITS
  160 IF (X.LT.0.0D0) GO TO 180
      IFAIL = P01ABF(IFAIL,1,SRNAME,0,P01REC)
      S14AAF = GBIG
      GO TO 240
C
  180 IFAIL = P01ABF(IFAIL,2,SRNAME,0,P01REC)
      S14AAF = 0.0D0
      GO TO 240
C
  200 IFAIL = P01ABF(IFAIL,3,SRNAME,0,P01REC)
      T = X
      IF (X.EQ.0.0D0) T = 1.0D0
      S14AAF = SIGN(1.0D0/XMINV,T)
      GO TO 240
C
  220 IFAIL = P01ABF(IFAIL,4,SRNAME,0,P01REC)
      S14AAF = GBIG
C
  240 RETURN
      END