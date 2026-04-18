;;STRUC--Stucture Macro Library
;;Optimizing Version 2.30  03/31/87

%if 1  ; IF1 - pass-specific
$NoConj 	equ	0
$And		equ	1
$Or		equ	2
$Short		equ	3
$Near		equ	4
$NearToShort	equ	5
$ncxz		equ	6
$AndOr equ 0
$Temp equ 0
$Temp2 equ 0
$Dist equ 0

$NoType 	equ	10
$ConjIfType	equ	11
$IfType 	equ	12
$ElseType	equ	13
$WhileType	equ	14
$ConjWhileType	equ	15
$RepeatType	equ	16
$ConjUntilType	equ	17
$ForType	equ	18
$ConjLeaveType	equ	19
$SelectType	equ	20
$WhenType	equ	21
$ConjWhenType	equ	22
$OtherwiseType	equ	$ElseType

%macro $StrucError 1
					Structure error -- text
%endmacro

%macro J 0
%endmacro
%macro JN 0
%endmacro

%macro $BuildJump 2
	%macro j1 1
	    ; .xcref  j1
					j2 t
	%endmacro
%endmacro

; irp	x,<<jeq,je>,<jlt,jl>,<jgt,jg>,<jneq,jne>,<jnlt,jnl>,<jngt,jng>,<jnpe,jpo>,<jnpo,jpe>>
	$BuildJump x
%endmacro
; irp	x,<<jzero,jz>,<jnzero,jnz>,<jnonzero,jnz>,<jnnonzero,jz>,<jand,jnz>,<jnand,jz>,<jnnand,jnz>>
	$BuildJump x
%endmacro
; irp	x,<a,ae,b,be,c,e,g,ge,l,le,o,p,s,z,cxz>
	$BuildJump jnn&x,j&x
%endmacro

%macro jncxz 1
	%if $Dist eq $NearToShort
					jcxz $+5
					jmp t
	%else
					jcxz $+4
					jmp short t
	%endif
%endmacro

; purge	$BuildJump

%macro $GetConj 2
	$AndOr equ $NoConj
	; irp	parm,<p1,p2>
	    %if 1  ; IFNB <&parm>
		; irp	x,<and,AND,or,OR>
		    %ifidn <parm>,<x>
			 $AndOr equ $&&&x
			 exitm
		    %endif
		%endmacro
	    %endif
	%endmacro
%endmacro

%macro $GetDist 2
	; irp	parm,<p1,p2>
	    %if 1  ; IFNB <parm>
		; irp	x,<short,SHORT,near,NEAR>
		    %ifidn <parm>,<x>
			$Dist equ $&&&x
			 exitm
		     %endif
		%endmacro
	    %endif
	%endmacro
%endmacro


%macro $Poke 2
	$st&n	= m
; .xcref	$st&n
%endmacro

%macro $Peek 2
	x equ $st&n
%endmacro

%macro $Push 1
	$st equ $st+1
	$Poke	%$st,n
%endmacro

%macro $Pop 1
	%if $st gt 0
	    $Peek   x,%$st
	    $st equ $st-1
	%else
	    $StrucError <open structure>
	%endif
%endmacro

%macro $EquateLabel 2
	%if $LastLabelOrg eq $
	    $ll&last = this
	    ; .xcref  $ll&last
	%endif
%endmacro

%macro $TraceLabel 3
	%if $ll&a eq $ll&b
	    $ll&n   = b
	    ; .xcref  $ll&n
	%else
	    $TraceLabel n,%$ll&a,%$ll&b
	%endif
%endmacro

%macro $Label 1
	%if 1  ; IF1 - pass-specific
	    $EquateLabel %$LastLabel,n
	    $ll&n   = n
	    ; .xcref  $ll&n
	    $LastLabel equ n
	    $LastLabelOrg equ $
$l&n:
	%else
	    %if $ll&n eq n
$l&n:
	    %else
		; .xcref	$l&n
		; .xcref	$ll&n
	    %endif
	%endif
%endmacro

%macro $CondJump 3
	%if 1  ; IF1 - pass-specific
	    %if 0  ; IFB <c>
		$EquateLabel %$LastLabel,l
	    %endif
	    ifndef  <$ll&l>
		$ll&l	= l
		; .xcref	$ll&l
	    %endif
	%else
	    $TraceLabel l,l,%$ll&l
	%endif
	$CondJump2 %$ll&l,tf,c
%endmacro

%macro $CondJump2 3
	%if $Dist eq $Short
	    %if 0  ; IFB <c>
					jmp short $l&l
	    %else
		%ifidn <tf>,<f>
					jn&c $l&l
		%else
					j&c $l&l
		%endif
	    %endif
	%else
	    %if 1  ; IFNB <c>
		ifdef	$l&l
		    %if (($ - $l&l) le 126) and (($l&l - $) le 129)
			$Dist equ $NearToShort
			$nops equ 3
			%ifidn <tf>,<f>
					jn&c $l&l
			    ifdef   $n&c
				%if $n&c eq $ncxz
				    $nops equ 0
				%endif
			    %endif
			    ifdef   $&c
				%if $&c eq $ncxz
				    $nops equ 5
				%endif
			    %endif
			%else
					j&c $l&l
			    ifdef   $n&c
				%if $n&c eq $ncxz
				    $nops equ 5
				%endif
			    %endif
			    ifdef   $&c
				%if $&c eq $ncxz
				    $nops equ 0
				%endif
			    %endif
			%endif
			    %rep $nops
				nop
			    %endmacro
		    %else
			%ifidn <tf>,<f>
					j&c $+5
			%else
					jn&c $+5
			%endif
					jmp $l&l
		    %endif
		%else
		    %ifidn <tf>,<f>
					j&c $+5
		    %else
					jn&c $+5
		    %endif
					jmp $l&l
		%endif
	    %else
		ifdef	$l&l
		    %ifidn <tf>,<NoFold>
					jmp $l&l
		    %else
			%if (($ - $l&l) le 126) and (($l&l - $) le 129)
					jmp short $l&l
					nop
			%else
					jmp $l&l
			%endif
		    %endif
		%else
					jmp $l&l
		%endif
	    %endif
	%endif
%endmacro


%macro $CondLoop 2
					loop&c $l&l
%endmacro

%macro $Test 6
	%if 0  ; IFB <a1>
	    $StrucError <invalid condition>
	%else
	%if 0  ; IFB <a2>
	    $CondJump %&tgt,a1
	%else
	%if 0  ; IFB <a3>
	    %ifnidn <a1>,<zero>
	    %ifnidn <a1>,<nonzero>
	    %ifnidn <a1>,<ZERO>
	    %ifnidn <a1>,<NONZERO>
		$StrucError <invalid condition>
		exitm
	    %endif
	    %endif
	    %endif
	    %endif
					or a2,a2
	    $CondJump %&tgt,a1
	%else
	%if 0  ; IFB <a4>
					cmp a1,a3
	    $CondJump %&tgt,a2
	%else
	%if 0  ; IFB <x>
	    %ifnidn <a1>,<bit>
	    %ifnidn <a1>,<BIT>
		$StrucError <invalid condition>
		exitm
	    %endif
	    %endif
					test a2,a4
	    $CondJump %&tgt,a3
	%else
	    $StrucError <invalid condition>
	%endif
	%endif
	%endif
	%endif
	%endif
%endmacro

%macro $TopTest 5
	$GetConj p4,p5
	$Dist equ $DefDist
	$GetDist p4,p5
	%if $AndOr eq $NoConj
	    $Test   <$sn-1,f>,args
	    $Pop    $Temp
	    %if $OrFound
		$Label	%$Temp
	    %endif
	    $Push   n
	%else
	    %if $AndOr eq $And
		$Test	<$sn-1,f>,args
	    %else
		$OrFound equ 1
		$Test	<$sn,t>,args
	    %endif
	    $Push   c
	%endif
%endmacro
;;*****************************************************************************
; .if	macro	t,p2,p3
	$Peek	$Temp,%$st
	%if $Temp eq $ConjIfType
	    $Pop    $Temp
	%else
	    $OrFound equ 0
	    $sn equ $sn+1
	    $Push   $sn
	    $sn equ $sn+1
	    $Push   $sn
	    $sn equ $sn+1
	    $Push   $sn
	%endif
	$TopTest <t>,$IfType,$ConjIfType,p2,p3
%endmacro
;;*****************************************************************************
.then	macro
	$Peek	$Temp,%$st
	%if $Temp ne $IfType
	%if $Temp ne $WhenType
	    $StrucError <then without if or when>
	%endif
	%endif
%endmacro
;;*****************************************************************************
.elseif macro	t,p2,p3
	$Pop	$Temp
	%if $Temp ne $IfType
	    $StrucError <elseif without if>
	    exitm
	%endif
	$OrFound equ 0
	$Pop	$Temp
	$Peek	$Temp2,%$st
	$Dist equ $Near
	$CondJump %$Temp2
	$Label	%$Temp
	$sn equ $sn+1
	$Push	$sn
	$sn equ $sn+1
	$Push	$sn
	$TopTest <t>,$IfType,$ConjIfType,p2,p3
%endmacro
;;*****************************************************************************
; .else	macro	dist
	$Pop	$Temp
	%if $Temp ne $IfType
	%if $Temp ne $WhenType
	%if $Temp ne $SelectType
	    $StrucError <else without if, when or select>
	    exitm
	%endif
	%endif
	%endif
	$sn equ $sn+1
	%if $Temp eq $SelectType
	    $Push   $sn
	%else
	    $Dist equ $DefDist
	    $GetDist dist
	    $CondJump %$sn
	    $Pop    $Temp
	    $Label  %$Temp
	    $Push   $sn
	%endif
	$push	$ElseType
%endmacro
;;*****************************************************************************
; .endif	macro
	$Pop	$Temp
	%if $Temp ne $IfType
	    %if $Temp ne $ElseType
		$StrucError <endif without if>
		exitm
	    %endif
	%endif
	$Pop	$Temp
	$Label	%$Temp
	$Pop	$Temp
	$Label	%$Temp
%endmacro
;;*****************************************************************************
.select macro	x
	$OrFound equ 0
	$sn equ $sn+1
	$Push	$sn
	$Push	$SelectType
%endmacro
;;*****************************************************************************
.when	macro	tst,p2,p3
	$Pop	$Temp
	%if $Temp ne $SelectType
	%if $Temp ne $WhenType
	%if $Temp ne $ConjWhenType
	    $StrucError <when without select>
	    exitm
	%endif
	%endif
	%endif
	%if $Temp ne $ConjWhenType
	    $Dist equ $Near
	    $OrFound equ 0
	    %if $Temp eq $WhenType
		$Pop	$Temp2
		$Peek	$Temp,%$st
		$CondJump %$Temp
		$Label	 %$Temp2
	    %endif
	    $sn equ $sn+1
	    $Push   $sn
	    $sn equ $sn+1
	    $Push   $sn
	%endif
	$TopTest <tst>,$WhenType,$ConjWhenType,p2,p3
%endmacro
;;*****************************************************************************
.otherwise	macro	dist
	$Pop	$Temp
	%if $Temp ne $WhenType
	%if $Temp ne $SelectType
	%if $Temp ne $IfType
	    $StrucError <otherwise without if, when or select>
	    exitm
	%endif
	%endif
	%endif
	$sn equ $sn+1
	%if $Temp eq $SelectType
	    $Push   $sn
	%else
	    $Dist equ $DefDist
	    $GetDist dist
	    $CondJump %$sn
	    $Pop    $Temp
	    $Label  %$Temp
	    $Push   $sn
	%endif
	$push	$OtherwiseType
%endmacro
;;*****************************************************************************
.endselect	macro
	$Pop	$Temp
	%if $Temp ne $WhenType
	%if $Temp ne $OtherwiseType
	%if $Temp ne $SelectType
	    $StrucError <endselect without select>
	    exitm
	%endif
	%endif
	%endif
	$pop	$Temp2
	%if $Temp ne $SelectType
	    $Label  %$Temp2
	    $Pop    $Temp2
	    $Label  %$Temp2
	%endif
%endmacro
;;*****************************************************************************
; .while	macro	t,p2,p3
	$Peek	$Temp,%$st
	%if $Temp eq $ConjWhileType
	    $Pop    $Temp
	%else
	    $Push   $LoopEnd
	    $OrFound equ 0
	    $sn equ $sn + 1
	    $Push   $sn
	    $Label  %$sn
	    $sn equ $sn + 2
	    $Push   $sn
	    $LoopEnd equ $sn - 1
	%endif
	$TopTest <t>,$WhileType,$ConjWhileType,p2,p3
%endmacro
;;*****************************************************************************
.endwhile macro p1
	$Pop	$Temp
	%if $Temp ne $WhileType
	    $StrucError <endwhile without while>
	    exitm
	%endif
	$Dist equ $Near
	$Pop	$Temp
	$CondJump %$Temp,NoFold
	$Label	%$Temp+1
	$Pop	$LoopEnd
%endmacro
;;*****************************************************************************
; .repeat macro
	$Push	$LoopEnd
	$Push	$LeaveFound
	$sn equ $sn+1
	$Label	%$sn
	$Push	$sn
	$Push	$RepeatType
	$sn equ $sn+1
	$LoopEnd equ $sn
	$LeaveFound equ 0
%endmacro
;;*****************************************************************************
; .until	macro	t,p2,p3
	$until2 p2,p3,t
%endmacro
%macro $until2 7
	$Pop	$Temp
	%if $Temp ne $RepeatType
	    %if $Temp ne $ConjUntilType
		$StrucError <until without repeat>
		exitm
	    %endif
	%else
	    $OrFound equ 0
	%endif
	$Dist equ $DefDist
	$GetDist p2,p3
	$GetConj p2,p3

	%if $AndOr eq $NoConj
	    $Pop    $Temp
	    %if 0  ; IFB <a1>
		$Dist equ $Near
		$CondJump %$Temp,NoFold
	    %else
		$Test	 <$Temp,f>,<a1>,<a2>,<a3>,<a4>,<x>
	    %endif
	    %if $OrFound or $LeaveFound
		$Label	 %$Temp+1
	    %endif
	    $Pop    $LeaveFound
	    $Pop    $LoopEnd
	%else
	    $Peek   $Temp,%$st
	    %if $AndOr eq $And
		$Test	 <$Temp,f>,<a1>,<a2>,<a3>,<a4>,<x>
	    %else
		$OrFound equ 1
		$Test	 <$Temp+1,t>,<a1>,<a2>,<a3>,<a4>,<x>
	    %endif
	    $Push   $ConjUntilType
	%endif
%endmacro
;;*****************************************************************************
.loop	macro	cond
	$Pop	$Temp
	%if $Temp ne $RepeatType
	    $StrucError <loop without repeat>
	    exitm
	%endif
	$Pop	$Temp
	$CondLoop %$Temp,cond
	%if $LeaveFound
	    $Label  %$Temp+1
	%endif
	$Pop	$LeaveFound
	$Pop	$LoopEnd
%endmacro
;;*****************************************************************************
.for	macro	index,equals,start,to,stop,by,step,dist
					mov index,start
	$Push	$LoopEnd
	$sn equ $sn+1
	$Push	$sn
	$Label	%$sn
	$sn equ $sn+1
	$LoopEnd equ $sn
					cmp index,stop
	$Dist equ $DefDist
	%if 0  ; IFB <step>
	    $Push   1
	    $GetDist by
	    $CondJump %$sn,t,gt
	%else
	    $GetDist dist
	    $Push   %(step)
	    %if step lt 0
		$CondJump %$sn,t,lt
	    %else
		$CondJump %$sn,t,gt
	    %endif
	%endif
	$Push	$ForType
%endmacro
;;*****************************************************************************
.next	macro	index,dist
	$Pop	$Temp
	%if $Temp ne $ForType
	    $StrucError <next without for>
	    exitm
	%endif
	$Pop	$Temp
	%if $Temp eq 1
					inc index
	%else
	    %if $Temp eq -1
					dec index
	    %else
					add index,$Temp
	    %endif
	%endif
	$Pop	$Temp
	$Dist equ $Near
	$CondJump %$Temp,NoFold
	$Label	%$Temp+1
	$Pop	$LoopEnd
%endmacro
;;*****************************************************************************
.leave	macro	t,p2,p3
	$leave2 p2,p3,t
%endmacro
%macro $leave2 7
	%if ($LoopEnd) == 0
	    $StrucError <leave outside a loop>
	    exitm
	%endif
	$LeaveFound equ 1
	$Peek	$Temp,%$st
	%if $Temp eq $ConjLeaveType
	    $Pop    $Temp
	%else
	    $OrFound equ 0
	    $sn equ $sn + 1
	%endif
	$Dist equ 0
	$GetDist <a1>
	%if $Dist
	    $CondJump %$LoopEnd
	    %if $OrFound
		$Label	%$sn
	    %endif
	%else
	    $Dist equ $DefDist
	    $GetDist p2,p3
	    $GetConj p2,p3
	    %if $AndOr eq $NoConj
		%if 0  ; IFB <a1>
		    $CondJump %$LoopEnd,t
		%else
		    $Test   <$LoopEnd,t>,<a1>,<a2>,<a3>,<a4>,<x>
		%endif
		%if $OrFound
		    $Label  %$sn
		%endif
	    %else
		%if $AndOr eq $And
		    $OrFound equ 1
		    $Test   <$sn,f>,<a1>,<a2>,<a3>,<a4>,<x>
		%else
		    $Test   <$LoopEnd,t>,<a1>,<a2>,<a3>,<a4>,<x>
		%endif
		$Push	$ConjLeaveType
	    %endif
	%endif
%endmacro
;;*****************************************************************************
%else;else for if1
$Pop	$Temp
;;if	   $Temp ne $NoType
%if $st ne 0
     $StrucError <open structure(s)>
%endif
; .xcref $NoConj,$And,$Or,$Short,$Near,$NearToShort,$AndOr,$Temp,$Temp2,$Dist
; .xcref $NoType,$ConjIfType,$IfType,$ElseType,$WhileType,$ConjWhileType
; .xcref $RepeatType,$ConjUntilType,$ForType,$ConjLeaveType,jncxz
; .xcref $SelectType,$WhenType,$OtherwiseType,$ConjWhenType
; .xcref jeq,jgt,jlt,jneq,jngt,jnlt,jnna,jnnae,jnnb,jnnbe,jnnc,jnncxz
; .xcref jnne,jnng,jnnge,jnnl,jnnle,jnno,jnnp,jnns,jnnz,jnpe,jnpo,$BuildJump
; .xcref $GetConj,$GetDist,$Poke,$Peek,$Push,$Pop,$Label,$CondJump,$CondLoop,$Test
; .xcref $TopTest,$leave2,$until2,$StrucError,j,jn,jand,jnand,jnnand
; .xcref jnnonzero,jnonzero,jnzero,jzero
; .xcref $st,$sn,$OrFound,$LoopEnd,$LeaveFound,$DefDist
; .xcref $LastLabel,$LastLabelOrg,$EquateLabel,$TraceLabel,$CondJump2,$ncxz
%endif


$st equ 0
$sn equ 0
$OrFound equ 0
$LoopEnd equ 0
$LeaveFound equ 0
$LastLabel equ -1
$LastLabelOrg equ $
$DefDist= $Short
$Push	%$NoType
