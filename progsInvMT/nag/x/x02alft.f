      DOUBLE PRECISION FUNCTION X02ALF()
C     MARK 12 RELEASE. NAG COPYRIGHT 1986.
C
C     RETURNS  (1 - B**(-P)) * B**EMAX  (THE LARGEST POSITIVE MODEL
C     NUMBER)
C
      DOUBLE PRECISION X02CON
      DATA X02CON /1.79769313486231D+308 /
C     .. Executable Statements ..
      X02ALF = X02CON
      RETURN
      END