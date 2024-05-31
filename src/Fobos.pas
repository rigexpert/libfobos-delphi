//==============================================================================
//      _          ___               ______          ____
//    _| |_       / _ \              \  ___)   /\   |  _ \
//   /     \ ___ | |_) ) ___   ____   \ \     /  \  | |_) )
//  ( (| |) ) _ \|  _ < / _ \ /  ._)   > >   / /\ \ |  __/
//   \_   _( (_) ) |_) | (_) | () )   / /__ / /__\ \| |
//     |_|  \___/|  __/ \___/ \__/   /_____)________\_|
//               | |
//               |_|
//==============================================================================
//  Fobos SDR
//  API wrapper
//  2024.04.11.17.06.33 - remastered
//  2024.05.30.12.39.55 - sync mode support (lib v2.2.2)
//==============================================================================
unit Fobos;

interface
{$MINENUMSIZE 4}
uses Classes, SysUtils;

const DllName = 'fobos.dll';

type
  TDoubleArray = array[0..MaxInt div (SizeOf(Double)) - 1] of Double;
  PDoubleArray = ^TDoubleArray;
  fobos_rx_cb_t = function(buffer: Pointer; size: Cardinal; ctx: Pointer): Integer; cdecl;

function fobos_rx_get_api_info(lib_version: PAnsiChar; drv_version: PAnsiChar): Integer; cdecl; external DllName;

function fobos_rx_get_device_count(): Integer; cdecl; external DllName;

function fobos_rx_list_devices(serials: PAnsiChar): Integer; cdecl; external DllName;

function fobos_rx_open(var device: Pointer; index: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_close(device: Pointer): Integer; cdecl;external DllName;

function fobos_rx_get_board_info(device: Pointer; hw_revision: PAnsiChar; fw_version: PAnsiChar; manufacturer: PAnsiChar; product: PAnsiChar; serial: PAnsiChar): Integer; cdecl;external DllName;

function fobos_rx_set_frequency(device: Pointer; value: Double; actual: PDouble): Integer; cdecl;external DllName;

function fobos_rx_set_direct_sampling(device: Pointer; enabled: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_set_lna_gain(device: Pointer; value: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_set_vga_gain(device: Pointer; value: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_get_samplerates(device: Pointer; values: PDoubleArray; var count: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_set_samplerate(device: Pointer; value: Double; actual: PDouble): Integer; cdecl;external DllName;

function fobos_rx_set_lpf(device: Pointer; value: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_set_user_gpo(device: Pointer; value: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_set_clk_source(device: Pointer; value: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_read_async(device: Pointer; callback: fobos_rx_cb_t; ctx: Pointer; buff_count: Cardinal; buff_length: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_cancel_async(device: Pointer): Integer; cdecl;external DllName;

function fobos_max2830_set_frequency(device: Pointer; freq: Double; actual: PDouble): Integer; cdecl;external DllName;

function fobos_rffc507x_set_lo_frequency(device: Pointer; lo_freq_mhz: Integer; actual_hz: PInt64): Integer; cdecl;external DllName;

function fobos_rx_start_sync(device: Pointer; buf_length: Cardinal): Integer; cdecl;external DllName;

function fobos_rx_read_sync(device: Pointer; buf: Pointer; actual_buf_length: PCardinal): Integer; cdecl;external DllName;

function fobos_rx_stop_sync(device: Pointer): Integer; cdecl;external DllName;

function fobos_rx_test(device: Pointer; test: Integer; value: Integer): Integer; cdecl;external DllName;
//==============================================================================
implementation
//==============================================================================

//==============================================================================
end.
