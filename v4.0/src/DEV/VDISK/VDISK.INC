EMS_STATUS              EQU     40H
EMS_GET_NUM_PAGES       EQU     42H
EMS_ALLOC_PAGES         EQU     43H
EMS_MAP_HANDLE          EQU     44H
EMS_VERSION             EQU     46H
EMS_SAVE_STATE          EQU     47H
EMS_RESTORE_STATE       EQU     48H
EMS_GET_FRAME_ADDR      EQU     5100H
EMS_INT                 EQU     67H

EMS_EXPECTED_VERSION    EQU     34H
EMS_LOW_ERROR           EQU     80H
EMS_INSTALLED_FLAG      EQU     -1

EMS_ALLOC_ERROR         EQU     -1              ; ***RPS ??
SINGLE_SEGMENT          EQU     1
DOS_PAGE1               EQU     0FEH
DOS_PAGE2               EQU     0FFH
DOS_PAGE_SZ             EQU     16

struc GET_PAGE_FRAME_STRUC
  START_PAGE: resb 1
  NUM_PAGE: resb 1
  FRAME_SEGMENT: resw 1
endstruc
BUFFER_ENTRY_SIZE       EQU     TYPE GET_PAGE_FRAME_STRUC

