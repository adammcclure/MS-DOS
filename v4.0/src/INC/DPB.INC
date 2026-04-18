;	SCCSID = @(#)dpb.asm	1.1 85/04/10
;	SCCSID = @(#)dpb.asm	1.1 85/04/10
BREAK <DPB structure>
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
struc dpb
dpb_drive: resb 1; Logical drive # assoc with DPB (A=0,B=1,...)
dpb_UNIT: resb 1; Driver unit number of DPB
dpb_sector_size: resw 1; Size of physical sector in bytes
dpb_cluster_mask: resb 1; Sectors/cluster - 1
dpb_cluster_shift: resb 1; Log2 of sectors/cluster
dpb_first_FAT: resw 1; Starting record of FATs
dpb_FAT_count: resb 1; Number of FATs for this drive
dpb_root_entries: resw 1; Number of directory entries
dpb_first_sector: resw 1; First sector of first cluster
dpb_max_cluster: resw 1; Number of clusters on drive + 1
dpb_FAT_size: resw 1;;Number of records occupied by FAT
dpb_dir_sector: resw 1; Starting record of directory
dpb_driver_addr: resd 1; Pointer to driver
dpb_media: resb 1; Media byte
dpb_first_access: resb 1; This is initialized to -1 to force a media
					; check the first time this DPB is used
dpb_next_dpb: resd 1; Pointer to next Drive parameter block
dpb_next_free: resw 1; Cluster # of last allocated cluster
dpb_free_cnt: resw 1; Count of free clusters, -1 if unknown
endstruc

DPBSIZ	EQU	dpb_size		; Size of the structure in bytes

DSKSIZ equ dpb_max_cluster; Size of disk (temp used during init only)
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
