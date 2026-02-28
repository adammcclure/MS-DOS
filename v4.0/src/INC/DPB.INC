;	SCCSID = @(#)dpb.asm	1.1 85/04/10
;	SCCSID = @(#)dpb.asm	1.1 85/04/10
BREAK <DPB structure>
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
struc dpb
dpb_drive: db 0; Logical drive # assoc with DPB (A=0,B=1,...)
dpb_UNIT: db 0; Driver unit number of DPB
dpb_sector_size: dw 0; Size of physical sector in bytes
dpb_cluster_mask: db 0; Sectors/cluster - 1
dpb_cluster_shift: db 0; Log2 of sectors/cluster
dpb_first_FAT: dw 0; Starting record of FATs
dpb_FAT_count: db 0; Number of FATs for this drive
dpb_root_entries: dw 0; Number of directory entries
dpb_first_sector: dw 0; First sector of first cluster
dpb_max_cluster: dw 0; Number of clusters on drive + 1
dpb_FAT_size: dw 0;;Number of records occupied by FAT
dpb_dir_sector: dw 0; Starting record of directory
dpb_driver_addr: dd 0; Pointer to driver
dpb_media: db 0; Media byte
dpb_first_access: db 0; This is initialized to -1 to force a media
					; check the first time this DPB is used
dpb_next_dpb: dd 0; Pointer to next Drive parameter block
dpb_next_free: dw 0; Cluster # of last allocated cluster
dpb_free_cnt: dw 0; Count of free clusters, -1 if unknown
endstruc

DPBSIZ	EQU	dpb_size		; Size of the structure in bytes

DSKSIZ	=	dpb_max_cluster 	; Size of disk (temp used during init only)
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
