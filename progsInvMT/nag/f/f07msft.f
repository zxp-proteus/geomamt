      SUBROUTINE F07MSF(UPLO,N,NRHS,A,LDA,IPIV,B,LDB,INFO)
C     MARK 15 RELEASE. NAG COPYRIGHT 1991.
C     .. Entry Points ..
      ENTRY             ZHETRS(UPLO,N,NRHS,A,LDA,IPIV,B,LDB,INFO)
C
C  Purpose
C  =======
C
C  ZHETRS solves a system of linear equations A*X = B with a complex
C  Hermitian matrix A using the factorization A = U*D*U' or A = L*D*L'
C  computed by F07MRF.
C
C  Arguments
C  =========
C
C  UPLO    (input) CHARACTER*1
C          Specifies whether the details of the factorization are stored
C          as an upper or lower triangular matrix.
C          = 'U':  Upper triangular (form is A = U*D*U')
C          = 'L':  Lower triangular (form is A = L*D*L')
C
C  N       (input) INTEGER
C          The order of the matrix A.  N >= 0.
C
C  NRHS    (input) INTEGER
C          The number of right hand sides, i.e., the number of columns
C          of the matrix B.  NRHS >= 0.
C
C  A       (input) COMPLEX array, dimension (LDA,N)
C          The block diagonal matrix D and the multipliers used to
C          obtain the factor U or L as computed by F07MRF.
C
C  LDA     (input) INTEGER
C          The leading dimension of the array A.  LDA >= max(1,N).
C
C  IPIV    (input) INTEGER array, dimension (N)
C          Details of the interchanges and the block structure of D
C          as determined by F07MRF.
C
C  B       (input/output) COMPLEX array, dimension (LDB,NRHS)
C          On entry, the right hand side vectors B for the system of
C          linear equations.
C          On exit, the solution vectors, X.
C
C  LDB     (input) INTEGER
C          The leading dimension of the array B.  LDB >= max(1,N).
C
C  INFO    (output) INTEGER
C          = 0:  successful exit
C          < 0: if INFO = -k, the k-th argument had an illegal value
C
C  -- LAPACK routine (adapted for NAG Library)
C     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
C     Courant Institute, Argonne National Lab, and Rice University
C
C  =====================================================================
C
C     .. Parameters ..
      COMPLEX*16        ONE
      PARAMETER         (ONE=1.0D+0)
C     .. Scalar Arguments ..
      INTEGER           INFO, LDA, LDB, N, NRHS
      CHARACTER         UPLO
C     .. Array Arguments ..
      COMPLEX*16        A(LDA,*), B(LDB,*)
      INTEGER           IPIV(*)
C     .. Local Scalars ..
      COMPLEX*16        AK, AKM1, AKM1K, BK, BKM1, DENOM
      DOUBLE PRECISION  S
      INTEGER           J, K, KP
      LOGICAL           UPPER
C     .. External Subroutines ..
      EXTERNAL          ZGEMV, ZGERU, ZDSCAL, ZSWAP, F06AAZ, F07FRY
C     .. Intrinsic Functions ..
      INTRINSIC         DCONJG, MAX, DBLE
C     .. Executable Statements ..
C
      INFO = 0
      UPPER = (UPLO.EQ.'U' .OR. UPLO.EQ.'u')
      IF ( .NOT. UPPER .AND. .NOT. (UPLO.EQ.'L' .OR. UPLO.EQ.'l')) THEN
         INFO = -1
      ELSE IF (N.LT.0) THEN
         INFO = -2
      ELSE IF (NRHS.LT.0) THEN
         INFO = -3
      ELSE IF (LDA.LT.MAX(1,N)) THEN
         INFO = -5
      ELSE IF (LDB.LT.MAX(1,N)) THEN
         INFO = -8
      END IF
      IF (INFO.NE.0) THEN
         CALL F06AAZ('F07MSF/ZHETRS',-INFO)
         RETURN
      END IF
C
C     Quick return if possible
C
      IF (N.EQ.0 .OR. NRHS.EQ.0) RETURN
C
      IF (UPPER) THEN
C
C        Solve A*X = B, where A = U*D*U'.
C
C        First solve U*D*X = B, overwriting B with X.
C
C        K is the main loop index, decreasing from N to 1 in steps of
C        1 or 2, depending on the size of the diagonal blocks.
C
         K = N
   20    CONTINUE
C
C        If K < 1, exit from loop.
C
         IF (K.LT.1) GO TO 60
C
         IF (IPIV(K).GT.0) THEN
C
C           1 x 1 diagonal block
C
C           Interchange rows K and IPIV(K).
C
            KP = IPIV(K)
            IF (KP.NE.K) CALL ZSWAP(NRHS,B(K,1),LDB,B(KP,1),LDB)
C
C           Multiply by inv(U(K)), where U(K) is the transformation
C           stored in column K of A.
C
            CALL ZGERU(K-1,NRHS,-ONE,A(1,K),1,B(K,1),LDB,B(1,1),LDB)
C
C           Multiply by the inverse of the diagonal block.
C
            S = DBLE(ONE)/DBLE(A(K,K))
            CALL ZDSCAL(NRHS,S,B(K,1),LDB)
            K = K - 1
         ELSE
C
C           2 x 2 diagonal block
C
C           Interchange rows K-1 and -IPIV(K).
C
            KP = -IPIV(K)
            IF (KP.NE.K-1) CALL ZSWAP(NRHS,B(K-1,1),LDB,B(KP,1),LDB)
C
C           Multiply by inv(U(K)), where U(K) is the transformation
C           stored in columns K-1 and K of A.
C
            CALL ZGERU(K-2,NRHS,-ONE,A(1,K),1,B(K,1),LDB,B(1,1),LDB)
            CALL ZGERU(K-2,NRHS,-ONE,A(1,K-1),1,B(K-1,1),LDB,B(1,1),LDB)
C
C           Multiply by the inverse of the diagonal block.
C
            AKM1K = A(K-1,K)
            AKM1 = A(K-1,K-1)/AKM1K
            AK = A(K,K)/DCONJG(AKM1K)
            DENOM = AKM1*AK - ONE
            DO 40 J = 1, NRHS
               BKM1 = B(K-1,J)/AKM1K
               BK = B(K,J)/DCONJG(AKM1K)
               B(K-1,J) = (AK*BKM1-BK)/DENOM
               B(K,J) = (AKM1*BK-BKM1)/DENOM
   40       CONTINUE
            K = K - 2
         END IF
C
         GO TO 20
   60    CONTINUE
C
C        Next solve U'*X = B, overwriting B with X.
C
C        K is the main loop index, increasing from 1 to N in steps of
C        1 or 2, depending on the size of the diagonal blocks.
C
         K = 1
   80    CONTINUE
C
C        If K > N, exit from loop.
C
         IF (K.GT.N) GO TO 100
C
         IF (IPIV(K).GT.0) THEN
C
C           1 x 1 diagonal block
C
C           Multiply by inv(U'(K)), where U(K) is the transformation
C           stored in column K of A.
C
            IF (K.GT.1) THEN
               CALL F07FRY(NRHS,B(K,1),LDB)
               CALL ZGEMV('Conjugate transpose',K-1,NRHS,-ONE,B,LDB,
     *                    A(1,K),1,ONE,B(K,1),LDB)
               CALL F07FRY(NRHS,B(K,1),LDB)
            END IF
C
C           Interchange rows K and IPIV(K).
C
            KP = IPIV(K)
            IF (KP.NE.K) CALL ZSWAP(NRHS,B(K,1),LDB,B(KP,1),LDB)
            K = K + 1
         ELSE
C
C           2 x 2 diagonal block
C
C           Multiply by inv(U'(K+1)), where U(K+1) is the transformation
C           stored in columns K and K+1 of A.
C
            IF (K.GT.1) THEN
               CALL F07FRY(NRHS,B(K,1),LDB)
               CALL ZGEMV('Conjugate transpose',K-1,NRHS,-ONE,B,LDB,
     *                    A(1,K),1,ONE,B(K,1),LDB)
               CALL F07FRY(NRHS,B(K,1),LDB)
C
               CALL F07FRY(NRHS,B(K+1,1),LDB)
               CALL ZGEMV('Conjugate transpose',K-1,NRHS,-ONE,B,LDB,
     *                    A(1,K+1),1,ONE,B(K+1,1),LDB)
               CALL F07FRY(NRHS,B(K+1,1),LDB)
            END IF
C
C           Interchange rows K and -IPIV(K).
C
            KP = -IPIV(K)
            IF (KP.NE.K) CALL ZSWAP(NRHS,B(K,1),LDB,B(KP,1),LDB)
            K = K + 2
         END IF
C
         GO TO 80
  100    CONTINUE
C
      ELSE
C
C        Solve A*X = B, where A = L*D*L'.
C
C        First solve L*D*X = B, overwriting B with X.
C
C        K is the main loop index, increasing from 1 to N in steps of
C        1 or 2, depending on the size of the diagonal blocks.
C
         K = 1
  120    CONTINUE
C
C        If K > N, exit from loop.
C
         IF (K.GT.N) GO TO 160
C
         IF (IPIV(K).GT.0) THEN
C
C           1 x 1 diagonal block
C
C           Interchange rows K and IPIV(K).
C
            KP = IPIV(K)
            IF (KP.NE.K) CALL ZSWAP(NRHS,B(K,1),LDB,B(KP,1),LDB)
C
C           Multiply by inv(L(K)), where L(K) is the transformation
C           stored in column K of A.
C
            IF (K.LT.N) CALL ZGERU(N-K,NRHS,-ONE,A(K+1,K),1,B(K,1),LDB,
     *                             B(K+1,1),LDB)
C
C           Multiply by the inverse of the diagonal block.
C
            S = DBLE(ONE)/DBLE(A(K,K))
            CALL ZDSCAL(NRHS,S,B(K,1),LDB)
            K = K + 1
         ELSE
C
C           2 x 2 diagonal block
C
C           Interchange rows K+1 and -IPIV(K).
C
            KP = -IPIV(K)
            IF (KP.NE.K+1) CALL ZSWAP(NRHS,B(K+1,1),LDB,B(KP,1),LDB)
C
C           Multiply by inv(L(K)), where L(K) is the transformation
C           stored in columns K and K+1 of A.
C
            IF (K.LT.N-1) THEN
               CALL ZGERU(N-K-1,NRHS,-ONE,A(K+2,K),1,B(K,1),LDB,B(K+2,1)
     *                    ,LDB)
               CALL ZGERU(N-K-1,NRHS,-ONE,A(K+2,K+1),1,B(K+1,1),LDB,
     *                    B(K+2,1),LDB)
            END IF
C
C           Multiply by the inverse of the diagonal block.
C
            AKM1K = A(K+1,K)
            AKM1 = A(K,K)/DCONJG(AKM1K)
            AK = A(K+1,K+1)/AKM1K
            DENOM = AKM1*AK - ONE
            DO 140 J = 1, NRHS
               BKM1 = B(K,J)/DCONJG(AKM1K)
               BK = B(K+1,J)/AKM1K
               B(K,J) = (AK*BKM1-BK)/DENOM
               B(K+1,J) = (AKM1*BK-BKM1)/DENOM
  140       CONTINUE
            K = K + 2
         END IF
C
         GO TO 120
  160    CONTINUE
C
C        Next solve L'*X = B, overwriting B with X.
C
C        K is the main loop index, decreasing from N to 1 in steps of
C        1 or 2, depending on the size of the diagonal blocks.
C
         K = N
  180    CONTINUE
C
C        If K < 1, exit from loop.
C
         IF (K.LT.1) GO TO 200
C
         IF (IPIV(K).GT.0) THEN
C
C           1 x 1 diagonal block
C
C           Multiply by inv(L'(K)), where L(K) is the transformation
C           stored in column K of A.
C
            IF (K.LT.N) THEN
               CALL F07FRY(NRHS,B(K,1),LDB)
               CALL ZGEMV('Conjugate transpose',N-K,NRHS,-ONE,B(K+1,1),
     *                    LDB,A(K+1,K),1,ONE,B(K,1),LDB)
               CALL F07FRY(NRHS,B(K,1),LDB)
            END IF
C
C           Interchange rows K and IPIV(K).
C
            KP = IPIV(K)
            IF (KP.NE.K) CALL ZSWAP(NRHS,B(K,1),LDB,B(KP,1),LDB)
            K = K - 1
         ELSE
C
C           2 x 2 diagonal block
C
C           Multiply by inv(L'(K-1)), where L(K-1) is the transformation
C           stored in columns K-1 and K of A.
C
            IF (K.LT.N) THEN
               CALL F07FRY(NRHS,B(K,1),LDB)
               CALL ZGEMV('Conjugate transpose',N-K,NRHS,-ONE,B(K+1,1),
     *                    LDB,A(K+1,K),1,ONE,B(K,1),LDB)
               CALL F07FRY(NRHS,B(K,1),LDB)
C
               CALL F07FRY(NRHS,B(K-1,1),LDB)
               CALL ZGEMV('Conjugate transpose',N-K,NRHS,-ONE,B(K+1,1),
     *                    LDB,A(K+1,K-1),1,ONE,B(K-1,1),LDB)
               CALL F07FRY(NRHS,B(K-1,1),LDB)
            END IF
C
C           Interchange rows K and -IPIV(K).
C
            KP = -IPIV(K)
            IF (KP.NE.K) CALL ZSWAP(NRHS,B(K,1),LDB,B(KP,1),LDB)
            K = K - 2
         END IF
C
         GO TO 180
  200    CONTINUE
      END IF
C
      RETURN
C
C     End of F07MSF (ZHETRS)
C
      END
