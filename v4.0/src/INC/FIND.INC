;	SCCSID = @(#)find.asm	1.1 85/04/10
;	SCCSID = @(#)find.asm	1.1 85/04/10
Break	<find first/next buffer>

struc find_buf
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
find_buf_drive: resb 1; drive of search
find_buf_name: resb 11; formatted name
find_buf_sattr: resb 1; attribute of search
find_buf_LastEnt: resw 1; LastEnt
find_buf_DirStart: resw 1; DirStart
find_buf_NetID: resb 4; Reserved for NET
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;

find_buf_attr: resb 1; attribute found
find_buf_time: resw 1; time
find_buf_date: resw 1; date
find_buf_size_l: resw 1; low(size)
find_buf_size_h: resw 1; high(size)
find_buf_pname: resb 13; packed name
endstruc
