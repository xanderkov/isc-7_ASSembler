PUBLIC NUMBER
PUBLIC INCMD
PUBLIC INOCTSGN
PUBLIC FLAG

DATASEG SEGMENT PARA PUBLIC 'DATA'
    NUMBER DW 0
    FLAG DB 0
    INMSG DB 'Enter signed octal number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

INCMD PROC NEAR
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV CL, 2
    MUL CL
    MOV SI, AX
    RET
INCMD ENDP

ADDCIFR PROC NEAR
    MOV CL, AL
    MOV AX, 8
    MUL BX
    MOV BX, AX
    MOV CH, 0
    SUB CL, '0'
    ADD BX, CX
    RET
ADDCIFR ENDP

INOCTSGN PROC NEAR
    MOV FLAG, 0
    MOV AH, 9
    MOV DX, OFFSET INMSG
    INT 21H

    MOV BX, 0
    MOV DX, 0
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE ENDINP
    CMP AL, "-"
    JNE NOTMAKESIGN
    MOV DH, AL
    MOV FLAG, DH
    JMP INSYMB
    NOTMAKESIGN: 
    call ADDCIFR
    INSYMB:
        MOV AH, 1
        INT 21H
        CMP AL, 13
        JE ENDINP
        call ADDCIFR
        JMP INSYMB

    ENDINP:
    MOV DH, FLAG
    CMP DH, "-"
    JNE NOTURNTONEG
    NEG BX
    NOTURNTONEG:
    MOV NUMBER, BX

    RET
INOCTSGN ENDP

CODESEG ENDS
END