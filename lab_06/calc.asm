EXTRN NUMBER : WORD
EXTRN FLAG : BYTE
PUBLIC SHEX
PUBLIC UBIN
PUBLIC SIGN

PUBLIC TOSHEX

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MASK16 DW 15
    MASK2 DW 1
    SHEX DB 4 DUP('0'), '$'
    UBIN DB 16 DUP('0'), '$'
    SIGN DB ' '
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

TOSHEX PROC NEAR
    MOV DH, FLAG
    MOV AX, NUMBER
    CMP DH, "-"
    JNE HEXNEG
    NEG AX
    HEXNEG:
    MOV BX, 3
    GETHEX:
        MOV DX, AX
        AND DX, MASK16
        CMP DL, 10
        JB ISDIGIT
        ADD DL, 7
        ISDIGIT:
        ADD DL, '0'
        MOV SHEX[BX], DL
        MOV CL, 4
        SAR AX, CL
        DEC BX
        CMP BX, -1
        JNE GETHEX
    RET
TOSHEX ENDP

TOUBIN PROC NEAR

    MOV AX, NUMBER
    MOV BX, 15
    GETBIN:
        MOV DX, AX
        AND DX, MASK2
        ADD DL, '0'
        MOV UBIN[BX], DL
        MOV CL, 1
        SAR AX, CL
        DEC BX
        CMP BX, -1
        JNE GETBIN
    RET
TOUBIN ENDP

CODESEG ENDS
END