## Flash writing notes
##### datasheet
  http://infocenter.nordicsemi.com/pdf/nRF52832_PS_v1.0.pdf

#### NVMC — Non-volatile memory controller

#### Difference between fstorage and pstorage?
  http://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.softdevices52%2Fdita%2Fsoftdevices%2Fs130%2Fs130api.html
  fstorage is newer and will allw the soft device to handle the write & erase requests between radio commands easier. It splits up large writes and erases automatically.

#### Memory allocation
  512KB flash memory available.

#### Compatability and upgrading?
  current implant code uses flashwriting.c file to deal with the fpga updating.
  Consider changing this to use the fstorage.c code or using this for updating the implant code?
#### Connecting to PC
  https://dornerworks.com/blog/woes-multiple-bluetooth-connections  
  Multiple connection bluetooth problematic.  
  Polling is too slow considering the length of the connection time.  
  8-9 second connection time. Signals would take between 8-18 seconds to start sending a signal.  
  *Timer thread that polls for a PC connection less regularly*
  - walkthrough with an app https://thingtype.com/blog/dfu-ota-updating-an-nrf52-application-over-the-air/

#### ESB bootloader?
  http://infocenter.nordicsemi.com/index.jsp  
  Experimental ANT Bootloader/DFU requires S212 or S332  
  https://devzone.nordicsemi.com/f/nordic-q-a/10460/installing-esb-when-using-bootloader  
  https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.sdk52.v0.9.2%2Fbledfu_bootloader_introduction.html

  https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.sdk52.v0.9.1%2Fbledfu_memory_banks.html
#### Plan (read through bootloader code to check before testing)
1. Change over the current UART communication for a serial interface before jumping into the rest of it. Might as well test everything using the correct interface.
  * https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.sdk52.v0.9.2%2Fbledfu_bootloader_introduction.html  
  * in config/rx_pca10040/nrf_drv_config.h
    * Enabled SAADC line 388
    * Enabled timer 1 line 59
  * Implement these three functions in the main for the controller
  ```C
  saadc_sampling_event_init();
  saadc_init();                   //done
  saadc_sampling_event_enable();
  ```
  * WORKING BUT IT ALREADY WORKED ??!!!1?!?! discard all of the previous notes


* Set up bootloader based off the example on the implant board  
  * **bootloader.c** uses pstorage !fstorage throughout. Consider replacing the relevant function calls with equivalent fstorage code.  

    ```C
    static void bootloader_settings_save(bootloader_settings_t * p_settings)
    {
        uint32_t err_code = pstorage_clear(&m_bootsettings_handle, sizeof(bootloader_settings_t));
        APP_ERROR_CHECK(err_code);

        err_code = pstorage_store(&m_bootsettings_handle,
                                  (uint8_t *)p_settings,
                                  sizeof(bootloader_settings_t),
                                  0);
        APP_ERROR_CHECK(err_code);
    }
    ```

  * Will have to check trade offs for speed and file size and actual compatibility.
  * Use dual-bank bootloader to preserve current image before the new image is validated
  * set up the comms for the bootloader initiation between the boards.  

* Set up a python/matlab interface for writing the new application image to the controller in flash memory. (possibly validate the image here but don't put it on the controller?)
  * Not possible it seems with the given **bootloader.c** file (line 99). Seems to only validate as it updates the application. Either way this can be sent back as confirmation and then back to the user

    ```C
    bool bootloader_app_is_valid(uint32_t app_addr)
    {
        const bootloader_settings_t * p_bootloader_settings;

        // There exists an application in CODE region 1.
        if (*((uint32_t *)app_addr) == EMPTY_FLASH_MASK)
        {
            return false;
        }

        bool success = false;

        bootloader_util_settings_get(&p_bootloader_settings);

        // The application in CODE region 1 is flagged as valid during update.
        if (p_bootloader_settings->bank_0 == BANK_VALID_APP)
        {
            uint16_t image_crc = 0;

            // A stored crc value of 0 indicates that CRC checking is not used.
            if (p_bootloader_settings->bank_0_crc != 0)
            {
                image_crc = crc16_compute((uint8_t *)DFU_BANK_0_REGION_START,
                                          p_bootloader_settings->bank_0_size,
                                          NULL);
            }

            success = (image_crc == p_bootloader_settings->bank_0_crc);
        }

        return success;
    }
    ```
    * added reset functionality
    ```C
    case 0x20: { //system reset
      // errcode = sd_nvic_SystemReset();
      NVIC_SystemReset();
      break;
    }
    ```

* Use ESB to send a command to the implant about receiving a new image. Adding tags for the fpga or the implant application.
* Use bitbang/fstorage equivelant to send to *DfuTarg* address on the implant. The target address might change. May need calibration when setting up depending on the storage used by the bootloader/softdevice/FPGA image/application image in flash.


#### pstorage -> fstorage conversion
Not directly transferable... Will have to do some messing around possibly using the debugger to gather a more in depth understanding.


#### 11/5 - 18/5 TASKS
* **Establish how to view memory allocation**
  * https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.sdk52.v0.9.1%2Fbledfu_memory_banks.html
  http://infocenter.nordicsemi.com/pdf/S132_SDS_v2.0.pdf  
  ```C
  //dfu_types.h
  #define CODE_REGION_1_START                 SD_SIZE_GET(MBR_SIZE)  
  #define SOFTDEVICE_REGION_START             MBR_SIZE               
  #define DFU_BANK_0_REGION_START         CODE_REGION_1_START                                             /**< Bank 0 region start. */
  #define DFU_BANK_1_REGION_START         (DFU_BANK_0_REGION_START + DFU_IMAGE_MAX_SIZE_BANKED)
  //nrf_mbr.h
  /** @brief The size that must be reserved for the MBR when a softdevice is written to flash.
  This is the offset where the first byte of the softdevice hex file is written.*/
  #define MBR_SIZE                (0x1000)
  ```
  * data is not visible in the map file?! size of soft device is supposed to be 128KB once on the board so there is no space for dual bank upload on the implant chip.
  * space is available on the senseback controller for the implant code as well so maybe it could be validated on there before being sent?

* **Get a hex file sending and receiving through ESB**
  * Using debug return over ESB to Establish success or failure when adding new lines of code for file

* **Store the file in memory then read it and send back**
  * Pstorage init works
  * INCBIN doesn't use any calls to pstorage so the block number does not have to take the FPGA image file into account. that is all stored in a variable within the INCBIN code. :)
  https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.sdk5.v11.0.0%2Fbledfu_memory.html
  * algorithm for minimising the space used when adding an app using space available, space required by new app, number of code pages, size of each page and max page size. is it required??
