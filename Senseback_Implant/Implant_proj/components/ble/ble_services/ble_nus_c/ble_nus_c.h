/*
 * Copyright (c) 2012 Nordic Semiconductor. All Rights Reserved.
 *
 * The information contained herein is confidential property of Nordic Semiconductor. The use,
 * copying, transfer or disclosure of such information is prohibited except by express written
 * agreement with Nordic Semiconductor.
 *
 */

/**@file
 *
 * @defgroup ble_sdk_srv_nus_c   Nordic UART Service Client
 * @{
 * @ingroup  ble_sdk_srv
 * @brief    Nordic UART Service Client module.
 *
 * @details  This module contains the APIs and types exposed by the Nordic UART Service Client
 *           module. These APIs and types can be used by the application to perform discovery of
 *           the Nordic UART Service at the peer and interact with it.
 *
 * @note     The application must propagate BLE stack events to this module by calling
 *           ble_nus_c_on_ble_evt().
 *
 */


#ifndef BLE_NUS_C_H__
#define BLE_NUS_C_H__

#include <stdint.h>
#include <stdbool.h>
#include "ble.h"
#include "ble_gatt.h"
#include "ble_db_discovery.h"

#define NUS_BASE_UUID                  {{0x9E, 0xCA, 0xDC, 0x24, 0x0E, 0xE5, 0xA9, 0xE0, 0x93, 0xF3, 0xA3, 0xB5, 0x00, 0x00, 0x40, 0x6E}} /**< Used vendor specific UUID. */
#define BLE_UUID_NUS_SERVICE           0x0001                      /**< The UUID of the Nordic UART Service. */
#define BLE_UUID_NUS_TX_CHARACTERISTIC 0x0002                      /**< The UUID of the TX Characteristic. */
#define BLE_UUID_NUS_RX_CHARACTERISTIC 0x0003                      /**< The UUID of the RX Characteristic. */

#define BLE_NUS_MAX_DATA_LEN           (GATT_MTU_SIZE_DEFAULT - 3) /**< Maximum length of data (in bytes) that can be transmitted to the peer by the Nordic UART service module. */


/**@brief NUS Client event type. */
typedef enum 
{
    BLE_NUS_C_EVT_DISCOVERY_COMPLETE = 1, /**< Event indicating that the NUS service and its characteristics was found. */
    BLE_NUS_C_EVT_NUS_RX_EVT,             /**< Event indicating that the central has received something from a peer. */
    BLE_NUS_C_EVT_DISCONNECTED            /**< Event indicating that the NUS server has disconnected. */
} ble_nus_c_evt_type_t;


/**@brief Handles on the connected peer device needed to interact with it. 
*/
typedef struct {
    uint16_t                nus_rx_handle;      /**< Handle of the NUS RX characteristic as provided by a discovery. */
    uint16_t                nus_rx_cccd_handle; /**< Handle of the CCCD of the NUS RX characteristic as provided by a discovery. */
    uint16_t                nus_tx_handle;      /**< Handle of the NUS TX characteristic as provided by a discovery. */
} ble_nus_c_handles_t;


/**@brief Structure containing the NUS event data received from the peer. */
typedef struct {
    ble_nus_c_evt_type_t evt_type;
    uint16_t             conn_handle; 
    uint8_t            * p_data;
    uint8_t              data_len;
    ble_nus_c_handles_t  handles;     /**< Handles on which the Nordic Uart service characteristics was discovered on the peer device. This will be filled if the evt_type is @ref BLE_NUS_C_EVT_DISCOVERY_COMPLETE.*/
} ble_nus_c_evt_t;


// Forward declaration of the ble_nus_t type.
typedef struct ble_nus_c_s ble_nus_c_t;

/**@brief   Event handler type.
 *
 * @details This is the type of the event handler that should be provided by the application
 *          of this module to receive events.
 */
typedef void (* ble_nus_c_evt_handler_t)(ble_nus_c_t * p_ble_nus_c, const ble_nus_c_evt_t * p_evt);


/**@brief NUS Client structure.
 */
struct ble_nus_c_s
{
    uint8_t                 uuid_type;          /**< UUID type. */
    uint16_t                conn_handle;        /**< Handle of the current connection. Set with @ref ble_nus_c_handles_assign when connected. */
    ble_nus_c_handles_t     handles;            /**< Handles on the connected peer device needed to interact with it. */
    ble_nus_c_evt_handler_t evt_handler;        /**< Application event handler to be called when there is an event related to the NUS. */
};

/**@brief NUS Client initialization structure.
 */
typedef struct {
    ble_nus_c_evt_handler_t evt_handler;
} ble_nus_c_init_t;


/**@brief     Function for initializing the Nordic UART client module.
 *
 * @details   This function registers with the Database Discovery module
 *            for the NUS. Doing so will make the Database Discovery
 *            module look for the presence of a NUS instance at the peer when a
 *            discovery is started.
 *
 * @param[in] p_ble_nus_c      Pointer to the NUS client structure.
 * @param[in] p_ble_nus_c_init Pointer to the NUS initialization structure containing the
 *                             initialization information.
 *
 * @retval    NRF_SUCCESS If the module was initialized successfully. Otherwise, an error 
 *                        code is returned. This function
 *                        propagates the error code returned by the Database Discovery module API
 *                        @ref ble_db_discovery_evt_register.
 */
uint32_t ble_nus_c_init(ble_nus_c_t * p_ble_nus_c, ble_nus_c_init_t * p_ble_nus_c_init);


/**@brief Function for handling events from the database discovery module.
 *
 * @details This function will handle an event from the database discovery module, and determine
 *          if it relates to the discovery of NUS at the peer. If so, it will
 *          call the application's event handler indicating that NUS has been
 *          discovered at the peer. It also populates the event with the service related
 *          information before providing it to the application.
 *
 * @param[in] p_ble_nus_c Pointer to the NUS client structure.
 * @param[in] p_evt       Pointer to the event received from the database discovery module.
 */
 void ble_nus_c_on_db_disc_evt(ble_nus_c_t * p_ble_nus_c, ble_db_discovery_evt_t * p_evt);
 
 
/**@brief     Function for handling BLE events from the SoftDevice.
 *
 * @details   This function handles the BLE events received from the SoftDevice. If a BLE
 *            event is relevant to the NUS module, it is used to update
 *            internal variables and, if necessary, send events to the application.
 *
 * @param[in] p_ble_nus_c Pointer to the NUS client structure.
 * @param[in] p_ble_evt   Pointer to the BLE event.
 */
void ble_nus_c_on_ble_evt(ble_nus_c_t * p_ble_nus_c, const ble_evt_t * p_ble_evt);

/**@brief   Function for requesting the peer to start sending notification of RX characteristic.
 *
 * @details This function enables notifications of the NUS RX characteristic at the peer
 *          by writing to the CCCD of the NUS RX characteristic.
 *
 * @param   p_ble_nus_c Pointer to the NUS client structure.
 *
 * @retval  NRF_SUCCESS If the SoftDevice has been requested to write to the CCCD of the peer.
 *                      Otherwise, an error code is returned. This function propagates the error  
 *                      code returned by the SoftDevice API @ref sd_ble_gattc_write.
 */
uint32_t ble_nus_c_rx_notif_enable(ble_nus_c_t * p_ble_nus_c);

/**@brief Function for sending a string to the server.
 *
 * @details This function writes the TX characteristic of the server.
 *
 * @param[in] p_ble_nus_c Pointer to the NUS client structure.
 * @param[in] p_string    String to be sent.
 * @param[in] length      Length of the string.
 *
 * @retval NRF_SUCCESS If the string was sent successfully. Otherwise, an error code is returned.
 */
uint32_t ble_nus_c_string_send(ble_nus_c_t * p_ble_nus_c, uint8_t * p_string, uint16_t length);


/**@brief Function for assigning handles to a this instance of nus_c.
 *
 * @details Call this function when a link has been established with a peer to
 *          associate this link to this instance of the module. This makes it 
 *          possible to handle several link and associate each link to a particular
 *          instance of this module. The connection handle and attribute handles will be
 *          provided from the discovery event @ref BLE_NUS_C_EVT_DISCOVERY_COMPLETE.
 *
 * @param[in] p_ble_nus_c    Pointer to the NUS client structure instance to associate with these
 *                           handles.
 * @param[in] conn_handle    Connection handle to associated with the given NUS Instance.
 * @param[in] p_peer_handles Attribute handles on the NUS server that you want this NUS client to
 *                           interact with.
 *
 * @retval    NRF_SUCCESS    If the operation was successful.
 * @retval    NRF_ERROR_NULL If a p_nus was a NULL pointer.
 */
uint32_t ble_nus_c_handles_assign(ble_nus_c_t * p_ble_nus_c, const uint16_t conn_handle, const ble_nus_c_handles_t * p_peer_handles);


#endif // BLE_NUS_C_H__

/** @} */
