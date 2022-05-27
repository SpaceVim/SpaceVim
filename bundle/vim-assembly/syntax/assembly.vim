if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

let b:file_extensions = expand('%:e')

if b:file_extensions ==# 'asm'
    " NOTE(compnerd) '.' is not in the default keyword, and will cause the
    " directives to not be recognised by default.  Also add '!' to ensure that the
    " increment operator is matched.
    if version < 600
        set iskeyword=!,#,$,%,.,48-57,:,;,=,@,_
    else
        setlocal iskeyword=!,#,$,.,48-57,:,;,=,@,_
    endif

    syntax case match

    syntax keyword assemblySpecial NOTE TODO XXX contained

    syntax case ignore

    syntax region assemblyComment start="//" end="$" keepend contains=assemblySpecial
    syntax region assemblyComment start="/\*" end="\*/" contains=assemblySpecial
    " MachO uses ; as a comment leader
    syntax region assemblyComment start=";" end="$" contains=todo

    syntax keyword assemblyDirective .align .p2align
    syntax keyword assemblyDirective .global .globl .type
    syntax keyword assemblyDirective .hword .word .xword .long .quad
    syntax keyword assemblyDirective .loh
    syntax keyword assemblyDirective .tlsdesccall
    syntax keyword assemblyDirective .ltorg .pool
    syntax keyword assemblyDirective .req .unreq
    syntax keyword assemblyDirective .inst
    syntax keyword assemblyDirective .private_extern .extern
    syntax keyword assemblyDirective .section .text .data
    " NOTE(compnerd) .type is already listed above
    syntax keyword assemblyDirective .def .endef .scl
    syntax keyword assemblyDirective .macro .endmacro .endm
    syntax keyword assemblyDirective .set
    syntax keyword assemblyDirective .if .else .endif
    syntax keyword assemblyDirective .fill

    syntax match assemblyModifier /:lo12:/ contained
    syntax match assemblyModifier /:abs_g3:/ contained
    syntax match assemblyModifier /:abs_g2:/ contained
    syntax match assemblyModifier /:abs_g2_s:/ contained
    syntax match assemblyModifier /:abs_g2_nc:/ contained
    syntax match assemblyModifier /:abs_g1:/ contained
    syntax match assemblyModifier /:abs_g1_s:/ contained
    syntax match assemblyModifier /:abs_g1_nc:/ contained
    syntax match assemblyModifier /:abs_g0:/ contained
    syntax match assemblyModifier /:abs_g0_s:/ contained
    syntax match assemblyModifier /:abs_g0_nc:/ contained
    syntax match assemblyModifier /:dtprel_g2:/ contained
    syntax match assemblyModifier /:dtprel_g1:/ contained
    syntax match assemblyModifier /:dtprel_g1_nc:/ contained
    syntax match assemblyModifier /:dtprel_g0:/ contained
    syntax match assemblyModifier /:dtprel_g0_nc:/ contained
    syntax match assemblyModifier /:dtprel_hi12:/ contained
    syntax match assemblyModifier /:dtprel_lo12:/ contained
    syntax match assemblyModifier /:dtprel_lo12_nc:/ contained
    syntax match assemblyModifier /:tprel_g2:/ contained
    syntax match assemblyModifier /:tprel_g1:/ contained
    syntax match assemblyModifier /:tprel_g1_nc:/ contained
    syntax match assemblyModifier /:tprel_g0:/ contained
    syntax match assemblyModifier /:tprel_g0_nc:/ contained
    syntax match assemblyModifier /:tprel_hi12:/ contained
    syntax match assemblyModifier /:tprel_lo12:/ contained
    syntax match assemblyModifier /:tprel_lo12_nc:/ contained
    syntax match assemblyModifier /:tlsdesc:/ contained
    syntax match assemblyModifier /:tlsdesc_lo12:/ contained
    syntax match assemblyModifier /:got:/ contained
    syntax match assemblyModifier /:got_lo12:/ contained
    syntax match assemblyModifier /:gottprel:/ contained
    syntax match assemblyModifier /:gottprel_lo12:/ contained
    syntax match assemblyModifier /:gottprel_g1:/ contained
    syntax match assemblyModifier /:gottprel_g0_nc:/ contained

    syntax match assemblyModifier /@PAGE/ contained
    syntax match assemblyModifier /@PAGEOFF/ contained

    syntax match assemblyIdentifier /[-_$.A-Za-z0-9]\+/
    syntax match assemblyIdentifier /:.*:[-_$.A-Za-z0-9]\+/ contains=assemblyModifier
    " MachO uses @modifiers
    syntax match assemblyIdentifier /[-_$.A-Za-z0-9]\+@[a-zA-Z]\+/ contains=assemblyModifier
    " MachO uses L for the PrivateGloablPrefix, ELF uses .L
    syntax match assemblyIdentifier /\.\?L[-_$.A-Za-z0-9]\+/ contains=assemblyModifier
    syntax match assemblyIdentifier /:.*:\.\?L[-_$.A-Za-z0-9]\+/ contains=assemblyModifier
    " MachO uses @modifiers
    syntax match assemblyIdentifier /\.\?L[-_$.A-Za-z0-9]\+[a-zA-Z]\+/ contains=assemblyModifier

    syntax match assemblyLabel /^[-_$.A-Za-z0-9]\+\s*:/
    " MachO uses L for the PrivateGloablPrefix, ELF uses .L
    syntax match assemblyLabel /^\.\?L[-_$.A-Za-z0-9]\+\s*:/
    syntax match assemblyLabel /^"[-_$.A-Za-z0-9 ]\+\s*":/

    syntax keyword assemblyMnemonic ADC ADCS ADD ADDS ADR ADRP AND ANDS ASR ASRV AT

    syntax keyword assemblyMnemonic BEQ BNE BCS BHS BCC BLO BMI BPL BVS BVC BHI BLS
    syntax keyword assemblyMnemonic BGE BLT BGT BLE BAL BNV
    syntax keyword assemblyMnemonic B.EQ B.NE B.CS B.HS B.CC B.LO B.MI B.PL B.VS B.VC
    syntax keyword assemblyMnemonic B.HI B.LS B.GE B.LT B.GT B.LE B.AL B.NV
    syntax keyword assemblyMnemonic B BFI BFM BFXIL BIC BICS BL BLR BR BRK

    syntax keyword assemblyMnemonic CBNZ CBZ CCMN CINC CINV CLREX CLS CLZ CMN CMP
    syntax keyword assemblyMnemonic CNEG CRC32B CRC32H CRC32W CRC32X CRC32CB CRC32CH
    syntax keyword assemblyMnemonic CRC32CW CRC32CX
    syntax keyword assemblyMnemonic CSEL CSET CSINC CSINV CSNEG

    syntax keyword assemblyMnemonic DC DCPS1 DCPS2 DCP3 DMB DRPS DSB

    syntax keyword assemblyMnemonic EON EOR ERET EXTR

    syntax keyword assemblyMnemonic HINT HLT HVC

    syntax keyword assemblyMnemonic IC ISB

    syntax keyword assemblyMnemonic LDAR LDARB LDARH LDAXP LDAXR LDAXRB LDAXRH LDNP
    syntax keyword assemblyMnemonic LDP LDPSW LDR LDRB LDRH LDRSH LDRSW LDTR LDTRB
    syntax keyword assemblyMnemonic LDTRH LDTRSB LDTRSH LDTRSW LDUR LDURB LDURH
    syntax keyword assemblyMnemonic LDURSB LDURSH LDURSW LDXP LDXR LDXRB LDXRH LSL
    syntax keyword assemblyMnemonic LSLV LSR LSRV

    syntax keyword assemblyMnemonic MADD MNEG MOV MOVK MOVN MOVZ MRS MSUB MUL MVN

    syntax keyword assemblyMnemonic NEGS NGC NGCS NOP

    syntax keyword assemblyMnemonic ORN ORR

    syntax keyword assemblyMnemonic PRFM PRFUM

    syntax keyword assemblyMnemonic RBIT RET REV REV16 REV32 ROR RORV

    syntax keyword assemblyMnemonic SBC SBCS SBFIZ SBFM SBFX SDIV SEV SEVL SMADDL
    syntax keyword assemblyMnemonic SMC SMNEGL SMSUBL SMULH SMULL STLR STLRB STLRH
    syntax keyword assemblyMnemonic STLXP STLXR STLXRB STLXRH XTNP STP STR STRB STRH
    syntax keyword assemblyMnemonic STTTR STTRB STTRH STUR STURB STURH STXP STXR
    syntax keyword assemblyMnemonic STXRB STXRH SUB SUBS SVC SXTB SXTH SXTW SYS SYSL

    syntax keyword assemblyMnemonic TBNZ TBZ TLBI TST

    syntax keyword assemblyMnemonic UBFIZ UBFM UBFX UDIV UMADDL UMNEGL UMSUBL UMULH
    syntax keyword assemblyMnemonic UMULL UXTB UXTH

    syntax keyword assemblyMnemonic WFE WFI

    syntax keyword assemblyMnemonic YIELD

    syntax keyword assemblyMnemonic ABS ADD ADDHN ADDHN2 ADDP ADDV AESD AESE AESIMC
    syntax keyword assemblyMnemonic AESMC AND

    syntax keyword assemblyMnemonic BIC BIF BIT BSL

    syntax keyword assemblyMnemonic CLS CLZ CMEQ CMGE CMGT CMHI CMHS CMLE CMLT CMTST
    syntax keyword assemblyMnemonic CNT

    syntax keyword assemblyMnemonic DUP

    syntax keyword assemblyMnemonic EOR EXT

    syntax keyword assemblyMnemonic FABD FABS FACGE FACGT FADD FADDP FCCMP FCCMPE
    syntax keyword assemblyMnemonic FCMEQ FCMGE FCMGT FCMLE FCMLT FCMP FCMPE FCSEL
    syntax keyword assemblyMnemonic FCVT FCVTAS FCVTAU FCVTL FCVTL2 FCVTNS FCVTNU
    syntax keyword assemblyMnemonic FCVTPS FCVTPU FCVTXN FCVTXN2 FCVTZS FCVTZU FDIV
    syntax keyword assemblyMnemonic FMADD FMAX FMAXNM FMAXMP FMAXNMV FMAXP FMAXV FMIN
    syntax keyword assemblyMnemonic FMINNM FMINNMP FMINNMV FMINP FMINV FMLA FMLS FMOV
    syntax keyword assemblyMnemonic FMSUB FMUL FMULX FNEG FNMADD FNMSUB FNMUL FRECPE
    syntax keyword assemblyMnemonic FRECPS FRECPX FRINTA FRINTI FRINTM FRINTN FRINTP
    syntax keyword assemblyMnemonic FRINTX FRINTX FRINTZ FRSQRTE FRSQRTS FSQRT FSUB

    syntax keyword assemblyMnemonic INS

    syntax keyword assemblyMnemonic LD1 LD1R LD2 LD2R LD3 LD3R LD4 LD4R LDNP LDP LDR
    syntax keyword assemblyMnemonic LDUR

    syntax keyword assemblyMnemonic MLA MLS MOV MOVI MUL MVN MVNI

    syntax keyword assemblyMnemonic NEG NOT

    syntax keyword assemblyMnemonic ORN ORR

    syntax keyword assemblyMnemonic PMUL PMULL PMULL2

    syntax keyword assemblyMnemonic RBIT REV16 REV32 REV64 RSHRN RSHRN2 RSUBHN
    syntax keyword assemblyMnemonic RSUBHN2

    syntax keyword assemblyMnemonic SABA SABAL SABAL2 SABD SABDL SABDL2 SADALP SADDL
    syntax keyword assemblyMnemonic SADDL2 SADDLP SADDLV SADDW SADDW2 SCVTF SHA1C
    syntax keyword assemblyMnemonic SHA1H SHA1M SHA1P SHA1SU0 SHA1SU1 SHA256H2
    syntax keyword assemblyMnemonic SHA256H SHA256SU0 SHA256SU1 SHADD SHL SHLL SHLL2
    syntax keyword assemblyMnemonic SHRN SHRN2 SHSUB SLI SMAX SMAXP SMAXV SMIN SMINP
    syntax keyword assemblyMnemonic SMINV SMLAL SMLAL2 SMLSL SMLSL2 SMOV SMULL SMULL2
    syntax keyword assemblyMnemonic SQABS SQADD SQDMLAL SQDMLAL2 SQDMLSL SQDMLSL2
    syntax keyword assemblyMnemonic SQDMULH SQDMULL SQDMULL2 SQNEG SQRDMULH SQRSHL
    syntax keyword assemblyMnemonic SQRSHRN SQRSHRN2 SQSHL SQSHLU SQSHRN SQSHRN2
    syntax keyword assemblyMnemonic SQSUB SQXTN SQXTN2 SQXTUN SQXTUN2 SHRADD SRI
    syntax keyword assemblyMnemonic SRSHL SRSHR SRSRA SSHL SSHLL SSHLL2 SSHHR SSRA
    syntax keyword assemblyMnemonic SSUBL SSUBL2 SSUBW SSUBW2 ST1 ST2 ST3 ST4 STNP
    syntax keyword assemblyMnemonic STP STR STUR SUB SUBHN SUBHN2 SUQADD SXTL

    syntax keyword assemblyMnemonic TBL TBX TRN1 TRN2

    syntax keyword assemblyMnemonic UABA UABAL UABAL2 UABD UABDL UABDL2 UADALP UADDL
    syntax keyword assemblyMnemonic UADDL2 UADDLP UADDLV UADDW UADDW2 UCVTF UHADD
    syntax keyword assemblyMnemonic UHSUB UMAX UMAXP UMAXV UMIN UMINP UMINV UMLAL
    syntax keyword assemblyMnemonic UMLAL2 UMLSL UMLSL2 UMOV UMULL UMULL2 UQADD
    syntax keyword assemblyMnemonic UQRSHL UQRSHRN UQRSHRN2 UQSHL UQSHRN UQSUB UQXTN
    syntax keyword assemblyMnemonic UQXTN2 URECPE URHADD URSHL URSHR URSQRTE URSRA
    syntax keyword assemblyMnemonic USHL USHLL USHLL2 USHR USQADD USRA USUBL USUBL2
    syntax keyword assemblyMnemonic USUBW USUBW2 UXTL UZP1 UZP2

    syntax keyword assemblyMnemonic XTN XTN2

    syntax keyword assemblyMnemonic ZIP1 ZIP2

    syntax match assemblyMacro  /#[_a-zA-Z][_a-zA-Z0-9]*/
    syntax match assemblyNumber /#-\?\d\+/
    syntax match assemblyNumber /#([^)]\+)/
    " TODO(compnerd) add floating point and hexadecimal numeric literal

    " NOTE(compnerd) this must be matched after numerics
    syntax match assemblyLabel /\d\{1,2\}[:fb]/

    syntax keyword assemblyOperator ! ==

    syntax keyword assemblyRegister  w0  w1  w2  w3  w4  w5  w6  w7  w8  w9 w10
    syntax keyword assemblyRegister w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20
    syntax keyword assemblyRegister w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30
    syntax keyword assemblyRegister w31

    syntax keyword assemblyRegister  x0  x1  x2  x3  x4  x5  x6  x7  x8  x9 x10
    syntax keyword assemblyRegister x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20
    syntax keyword assemblyRegister x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30
    syntax keyword assemblyRegister x31

    syntax keyword assemblyRegister  v0  v1  v2  v3  v4  v5  v6  v7  v8  v9 v10
    syntax keyword assemblyRegister v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20
    syntax keyword assemblyRegister v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30
    syntax keyword assemblyRegister v31

    syntax keyword assemblyRegister  q0  q1  q2  q3  q4  q5  q6  q7  q8  q9 q10
    syntax keyword assemblyRegister q10 q11 q12 q13 q14 q15 q16 q17 q18 q19 q20
    syntax keyword assemblyRegister q20 q21 q22 q23 q24 q25 q26 q27 q28 q29 q30
    syntax keyword assemblyRegister q31

    syntax keyword assemblyRegister  d0  d1  d2  d3  d4  d5  d6  d7  d8  d9 d10
    syntax keyword assemblyRegister d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20
    syntax keyword assemblyRegister d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 d30
    syntax keyword assemblyRegister d31

    syntax keyword assemblyRegister  s0  s1  s2  s3  s4  s5  s6  s7  s8  s9 s10
    syntax keyword assemblyRegister s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20
    syntax keyword assemblyRegister s20 s21 s22 s23 s24 s25 s26 s27 s28 s29 s30
    syntax keyword assemblyRegister s31

    syntax keyword assemblyRegister wzr xzr

    syntax keyword assemblyRegister sp pc pstate

    syntax match assemblyType /[@%]function/
    syntax match assemblyType /[@%]object/
    syntax match assemblyType /[@%]tls_object/
    syntax match assemblyType /[@%]common/
    syntax match assemblyType /[@%]notype/
    syntax match assemblyType /[@%]gnu_unique_object/
elseif b:file_extensions ==# 'agc'
    syntax keyword assemblySpecial NOTE TODO XXX contained
    syntax region assemblyComment start="#" end="$" keepend contains=assemblySpecial
    syntax keyword assemblyMnemonic ABS\* AST,[12] BOVF COMP\** COS\* CROSS DBSU DMOVE\** DTS ITC\** ITC[IQ] LOAD LODON NOLOD SHIFTL SHIFTR SMOVE\** SQUARE STZ SWITCH TEST TMOVE TRAD TSLC TSLT\** TSRT\** TSU TTS VMOVE\** VSLT\** VSQ VSRT\** VTS
    syntax keyword assemblyDirective -CADR XCADR
    syntax keyword assemblyDirective = =MINUS =ECADR \-2CADR \-GENADR 2BCADR 2CADR 2DEC\** 2FCADR 2OCT ADRES BANK BBCON\** BLOCK BNKSUM CADR CHECK= COUNT\** DEC\** EBANK= ECADR EQUALS ERASE FCADR GENADR MEMORY MM NV OCT OCTAL REMADR SBANK= SETLOC SUBRO VN
    syntax keyword assemblyDirective \-1DNADR \-2DNADR \-3DNADR \-4DNADR \-5DNADR -6DNADR \-DNCHAN \-DNPTR 1DNADR 2DNADR 3DNADR 4DNADR 5DNADR 6DNADR DNCHAN DNPTR
    syntax keyword assemblyRegister D Z N SL BI EDH CLHP HP LP ZI IN0 IN1 IN2 IN3 IN4 IN5 OUT0 OUT1 OUT2 OUT3 OUT4 RIP
    syntax keyword assemblyRegister A L Q EB FB Z BB ARUPT LRUPT QRUPT ZRUPT BBRUPT BRUPT CYR SR CYL EDOP
elseif b:file_extensions ==# 'ags'
    syntax region assemblyComment start="#" end="$" keepend contains=assemblySpecial
elseif b:file_extensions ==# 'argus'
    syntax region assemblyComment start="#" end="$" keepend contains=assemblySpecial
elseif b:file_extensions ==# 'binsource'
    syntax region assemblyComment start=";" end="$" keepend contains=assemblySpecial
    syntax match assemblyOperator /=/
    syntax keyword assemblyMnemonic BANK NUMWORDS CHECKWORDS
    syntax match assemblyMacro /[0-7]\+/
else
endif

highlight default link assemblyComment    Comment
highlight default link assemblyDirective  PreProc
highlight default link assemblyIdentifier Identifier
highlight default link assemblyLabel      Label
highlight default link assemblyMacro      Macro
highlight default link assemblyMnemonic   Keyword
highlight default link assemblyModifier   Special
highlight default link assemblyNumber     Number
highlight default link assemblyOperator   Operator
highlight default link assemblyRegister   StorageClass
highlight default link assemblyType       Tag
highlight default link assemblyTODO       Todo

let b:current_syntax = "assembly"
