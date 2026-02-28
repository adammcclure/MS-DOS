;	SCCSID = @(#)find.asm	1.1 85/04/10
;	SCCSID = @(#)find.asm	1.1 85/04/10
Break	<find first/next buffer>

struc find_buf
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
find_buf_drive: db 0; drive of search
find_buf_name: times 11 db 0; formatted name
find_buf_sattr: db 0; attribute of search
find_buf_LastEnt: dw 0; LastEnt
find_buf_DirStart: dw 0; DirStart
find_buf_NetID: times 4 db 0; Reserved for NET
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;

find_buf_attr: db 0; attribute found
find_buf_time: dw 0; time
find_buf_date: dw 0; date
find_buf_size_l: dw 0; low(size)
find_buf_size_h: dw 0; high(size)
find_buf_pname: times 13 db 0; packed name
endstruc
