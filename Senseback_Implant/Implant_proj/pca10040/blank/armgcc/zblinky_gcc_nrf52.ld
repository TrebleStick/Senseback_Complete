/* Linker script to configure memory regions. */

SEARCH_DIR(.)
GROUP(-lgcc -lc -lnosys)

MEMORY
{
  FLASH (rx) : ORIGIN = 0x40000, LENGTH = 0x3A000
  UICR (rx) : ORIGIN = 0x10001000, LENGTH = 0x0FFFF000
  RAM (rwx) :  ORIGIN = 0x20002080, LENGTH = 0xDF80
}

SECTIONS
{
  .app 0x0001C000 : { *(.app) _eapp = . ;}
  .uicr 0x1000120C :
  AT( _eapp )
  { _uicr = . ;  *(.uicr);  _euicr = . ;  }
  .fs_data :
  {
    PROVIDE(__start_fs_data = .);
    KEEP(*(.fs_data))
    PROVIDE(__stop_fs_data = .);
  } > RAM
} INSERT AFTER .data;

INCLUDE "nrf5x_common.ld"
