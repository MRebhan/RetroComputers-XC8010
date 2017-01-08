    dcode 1+,2,,INCR ; ( a -- a+1 )
        pla
        inc a
        pha
    nxt

    dcode 1-,2,,DECR ; ( a -- a-1 )
        pla
        dec a
        pha
    nxt

    dcode 2+,2,,INCRTWO ; ( a -- a+2 )
        pla
        inc a
        inc a
        pha
    nxt

    dcode 2-,2,,DECRTWO ; ( a -- a-2 )
        pla
        dec a
        dec a
        pha
    nxt

    dcode +,1,,ADD ; ( a b -- a+b )
        pla
        clc
        adc $01, s
        ply
        pha
    nxt

    dword -,1,,SUB ; ( a b -- a-b )
        .wp NEGATE
        .wp ADD
    .wp EXIT

    dcode UM*,3,,UMMUL ; ( a b -- d[a*b] )
        pla
        tsx
        sec
        mul $0001, x
        ply
        pha
        phd
    nxt

    dword U*,2,,UMUL ; ( a b -- a*b )
        .wp UMMUL
        .wp DROP
    .wp EXIT

    dcode M*,2,,MMUL ; (a b -- d[a*b] )
        pla
        tsx
        clc
        mul $0001, x
        ply
        pha
        phd
    nxt

    dword *,1,,MUL ; ( a b -- a*b )
        .wp MMUL
        .wp DROP
    .wp EXIT

    dcode 2*,2,,TWOMUL ; ( a -- 2*a )
        pla
        clc
        rol a
        pha
    nxt

    dword UM/MOD,6,,UMDIVMOD ; ( d b -- d/b d%b )
        .wp ROT
        .wp _DM
    nxt

    dword U/MOD,5,,UDIVMOD ; ( a b -- a/b a%b )
        .wp SWAP
        .wp ZERO
        .wp _DM
    .wp EXIT

    dword /MOD,4,,DIVMOD ; ( a b -- a/b a%b )
        .wp SWAP
        .wp NUM_TODOUBLE
        .wp _DM
    .wp EXIT

    dcode (UM/MOD),7,F_HIDDEN,_DM
        pld
        pla
        tsx
        sec
        div $0001, x
        ply
        pha
        phd
    nxt

    dword U/,2,,UDIV ; ( a b -- a/b )
        .wp UDIVMOD
        .wp DROP
    .wp EXIT

    dword /,1,,DIV ; ( a b -- a/b )
        .wp DIVMOD
        .wp DROP
    .wp EXIT

    dword MOD,3,, ; ( a b -- a%b )
        .wp UDIVMOD
        .wp NIP
    .wp EXIT

    dword 2/,2,,TWODIV ; ( a -- b/2 )
        .wp ONE
        .wp RSHIFT
    .wp EXIT

    dword ABS,3,, ; ( a -- |a| )
        .wp DUP
        .wp ZGE
        .wp ZBRANCH
        .wp ABS_noaction
        .wp NEGATE
    ABS_noaction:
    .wp EXIT

    dword DNEGATE,7,,
        .wp INVERT
        .wp SWAP
        .wp INVERT
        .wp SWAP
        .wp ONE
        .wp ZERO
        .wp DADD
    .wp EXIT

    dcode D+,2,,DADD ; ( a b -- a+b )
        plx
        pla
        clc
        adc $03, s
        tay
        txa
        adc $01, s
        plx
        plx
        phy
        pha
    nxt

    dword D-,2,,DSUB ; ( a b -- a-b )
        .wp DNEGATE
        .wp DADD
    .wp EXIT

    dcode SPLIT,5,, ; ( $1234 -- $34 $12 )
        pla
        sep #$30
        ldx #$00
        phx
        pha
        xba
        phx
        pha
        rep #$30
    nxt

    dcode JOIN,4,, ; ( $34 $12 -- $1234 )
        sep #$30
        plx
        ply
        ply
        pla
        phx
        phy
        rep #$30
    nxt

    .ifcflag disk_ext
    dword UNDER+,6,,UNDERADD ; ( a b c -- a+c b )
        .wp ROT
        .wp ADD
        .wp SWAP
    .wp EXIT
    .endif