(******************************************************************************)
(*                             libOpenALsoft_dyn                              *)
(*                  free pascal wrapper around OpenAL library                 *)
(*                      https://github.com/kcat/openal-soft                   *)
(*                            https://www.openal.org                          *)
(*                                                                            *)
(* Copyright (c) 2023 Ilya Medvedkov                                          *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the  GNU Lesser General Public License  as published by *)
(* the Free Software Foundation; either version 3 of the License (LGPL v3).   *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.                                          *)
(* See the GNU Lesser General Public License for more details.                *)
(*                                                                            *)
(* A copy of the GNU Lesser General Public License is available on the World  *)
(* Wide Web at <https://www.gnu.org/licenses/lgpl-3.0.html>.                  *)
(*                                                                            *)
(******************************************************************************)

unit libOpenALsoft_dyn;

{$mode objfpc}{$H+}

{$packrecords c}

interface

uses dynlibs, SysUtils, ctypes;

const
{$if defined(UNIX) and not defined(darwin)}
  OpenALsoftDLL: Array [0..0] of string = ('libopenal.so');
{$ELSE}
{$ifdef WINDOWS}
  OpenALsoftDLL: Array [0..0] of string = ('soft_oal.dll');
{$endif}
{$endif}

type
  { 8-bit boolean  }
  ALboolean = cchar;
  ALCboolean = cchar;
  { character  }
  ALchar = cchar;
  ALCchar = cchar;  
  { signed 32-bit 2's complement integer  }
  ALint = cint;
  ALCint = cint;
  { unsigned 32-bit integer  }
  ALuint = cuint;
  ALCuint = cuint;  
  { signed 16-bit 2's complement integer  }
  ALshort = cshort;
  ALCshort = cshort;
  { unsigned 16-bit integer  }
  ALushort = cushort;
  ALCushort = cushort;
  { signed 8-bit 2's complement integer  }
  ALbyte = cchar;
  ALCbyte = cchar;
  { unsigned 8-bit integer  }
  ALubyte = cuchar;
  ALCubyte = cuchar;  
  { non-negative 32-bit binary integer size  }
  ALsizei = cint;
  ALCsizei = cint;
  { enumerated 32-bit value  }
  ALenum = cint;
  ALCenum = cint;
  { 32-bit IEEE754 floating-point  }
  ALfloat = cfloat;
  ALCfloat = cfloat;
  { 64-bit IEEE754 floating-point  }
  ALdouble = cdouble;
  ALCdouble = cdouble;
  { void type (for opaque pointers only)  }
  //ALvoid = pointer;
  //ALCvoid = pointer;

  pALboolean = ^ALboolean;
  pALCchar = ^ALCchar;
  pALCcontext = pointer;
  pALCdevice = pointer;
  pALchar = ^ALchar;
  pALCint = ^ALCint;
  pALdouble = ^ALdouble;
  pALfloat = ^ALfloat;
  pALint = ^ALint;
  pALuint = ^ALuint;
  
  pALCvoid = pointer;
  pALvoid = pointer;

const
  AL_INVALID = -1;
  AL_NO_ERROR = 0;  
  ALC_INVALID = 0;

  { Supported ALC version?  }
  ALC_VERSION_0_1 = 1;

  { Boolean False.  }
  ALC_FALSE = 0;
  
  { Boolean True.  }
  ALC_TRUE = 1;
  
  { Context attribute: <int> Hz.  }
  ALC_FREQUENCY = $1007;
  
  { Context attribute: <int> Hz.  }
  ALC_REFRESH = $1008;
  
  { Context attribute: AL_TRUE or AL_FALSE synchronous context?  }
  ALC_SYNC = $1009;
  
  { Context attribute: <int> requested Mono (3D) Sources.  }
  ALC_MONO_SOURCES = $1010;
  
  { Context attribute: <int> requested Stereo Sources.  }
  ALC_STEREO_SOURCES = $1011;
  
  { No error.  }
  ALC_NO_ERROR = 0;
  
  { Invalid device handle.  }
  ALC_INVALID_DEVICE = $A001;
  
  { Invalid context handle.  }
  ALC_INVALID_CONTEXT = $A002;
  
  { Invalid enum parameter passed to an ALC call.  }
  ALC_INVALID_ENUM = $A003;
  
  { Invalid value parameter passed to an ALC call.  }
  ALC_INVALID_VALUE = $A004;
  
  { Out of memory.  }
  ALC_OUT_OF_MEMORY = $A005;
  
  
  { Runtime ALC major version.  }
  ALC_MAJOR_VERSION = $1000;
  { Runtime ALC minor version.  }
  ALC_MINOR_VERSION = $1001;
  
  { Context attribute list size.  }
  ALC_ATTRIBUTES_SIZE = $1002;
  { Context attribute list properties.  }
  ALC_ALL_ATTRIBUTES = $1003;
  
  { String for the default device specifier.  }
  ALC_DEFAULT_DEVICE_SPECIFIER = $1004;
  {** 
   * String for the given device's specifier.
   *
   * If device handle is NULL, it is instead a null-char separated list of
   * strings of known device specifiers (list ends with an empty string).
    *}
  ALC_DEVICE_SPECIFIER = $1005;
  { String for space-separated list of ALC extensions.  }
  ALC_EXTENSIONS = $1006;


  { Capture extension  }
  ALC_EXT_CAPTURE = 1;
  {** 
   * String for the given capture device's specifier.
   *
   * If device handle is NULL, it is instead a null-char separated list of
   * strings of known capture device specifiers (list ends with an empty string).
    *}
  ALC_CAPTURE_DEVICE_SPECIFIER = $310;
  { String for the default capture device specifier.  }
  ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER = $311;
  { Number of sample frames available for capture.  }
  ALC_CAPTURE_SAMPLES = $312;
  
  
  { Enumerate All extension  }
  ALC_ENUMERATE_ALL_EXT = 1;
  { String for the default extended device specifier.  }
  ALC_DEFAULT_ALL_DEVICES_SPECIFIER = $1012;
  {** 
   * String for the given extended device's specifier.
   *
   * If device handle is NULL, it is instead a null-char separated list of
   * strings of known extended device specifiers (list ends with an empty string).
    *}
  ALC_ALL_DEVICES_SPECIFIER = $1013;

  {** Invalid name paramater passed to AL call. *}
  AL_INVALID_NAME = $A001;

  {** Invalid enum parameter passed to AL call. *}
  AL_INVALID_ENUM = $A002;

  {** Invalid value parameter passed to AL call. *}
  AL_INVALID_VALUE = $A003;

  {** Illegal AL call. *}
  AL_INVALID_OPERATION = $A004;

  {** Not enough memory. *}
  AL_OUT_OF_MEMORY = $A005;
  AL_ILLEGAL_ENUM    = AL_INVALID_ENUM;
  AL_ILLEGAL_COMMAND = AL_INVALID_OPERATION;

  {  "no distance model" or "no buffer"  }
  AL_NONE = 0;
  
  {  Boolean False.  }
  AL_FALSE = 0;
  
  {  Boolean True.  }
  AL_TRUE = 1;


  {**
   * Relative source.
   * Type:    ALboolean
   * Range:   [AL_TRUE, AL_FALSE]
   * Default: AL_FALSE
   *
   * Specifies if the Source has relative coordinates.
   *}
  AL_SOURCE_RELATIVE = $202;
  
  
  {**
   * Inner cone angle, in degrees.
   * Type:    ALint, ALfloat
   * Range:   [0 - 360]
   * Default: 360
   *
   * The angle covered by the inner cone, where the source will not attenuate.
   *}
  AL_CONE_INNER_ANGLE = $1001;
  
  {**
   * Outer cone angle, in degrees.
   * Range:   [0 - 360]
   * Default: 360
   *
   * The angle covered by the outer cone, where the source will be fully
   * attenuated.
   *}
  AL_CONE_OUTER_ANGLE = $1002;
  
  {**
   * Source pitch.
   * Type:    ALfloat
   * Range:   [0.5 - 2.0]
   * Default: 1.0
   *
   * A multiplier for the frequency (sample rate) of the source's buffer.
   *}
  AL_PITCH = $1003;
  
  {**
   * Source or listener position.
   * Type:    ALfloat[3], ALint[3]
   * Default: (0, 0, 0)
   *
   * The source or listener location in three dimensional space.
   *
   * OpenAL, like OpenGL, uses a right handed coordinate system, where in a
   * frontal default view X (thumb) points right, Y points up (index finger), and
   * Z points towards the viewer/camera (middle finger).
   *
   * To switch from a left handed coordinate system, flip the sign on the Z
   * coordinate.
   *}
  AL_POSITION = $1004;
  
  {**
   * Source direction.
   * Type:    ALfloat[3], ALint[3]
   * Default: (0, 0, 0)
   *
   * Specifies the current direction in local space.
   * A zero-length vector specifies an omni-directional source (cone is ignored).
   *}
  AL_DIRECTION = $1005;
  
  {**
   * Source or listener velocity.
   * Type:    ALfloat[3], ALint[3]
   * Default: (0, 0, 0)
   *
   * Specifies the current velocity in local space.
   *}
  AL_VELOCITY = $1006;
  
  {** 
   * Source looping.
   * Type:    ALboolean
   * Range:   [AL_TRUE, AL_FALSE]
   * Default: AL_FALSE
   *
   * Specifies whether source is looping.
    *}
  AL_LOOPING = $1007;
  
  {** 
   * Source buffer.
   * Type:  ALuint
   * Range: any valid Buffer.
   *
   * Specifies the buffer to provide sound samples.
    *}
  AL_BUFFER = $1009;
  
  {** 
   * Source or listener gain.
   * Type:  ALfloat
   * Range: [0.0 - ]
   *
   * A value of 1.0 means unattenuated. Each division by 2 equals an attenuation
   * of about -6dB. Each multiplicaton by 2 equals an amplification of about
   * +6dB.
   *
   * A value of 0.0 is meaningless with respect to a logarithmic scale; it is
   * silent.
    *}
  AL_GAIN = $100A;
  
  {** 
   * Minimum source gain.
   * Type:  ALfloat
   * Range: [0.0 - 1.0]
   *
   * The minimum gain allowed for a source, after distance and cone attenation is
   * applied (if applicable).
    *}
  AL_MIN_GAIN = $100D;
  
  {** 
   * Maximum source gain.
   * Type:  ALfloat
   * Range: [0.0 - 1.0]
   *
   * The maximum gain allowed for a source, after distance and cone attenation is
   * applied (if applicable).
    *}
  AL_MAX_GAIN = $100E;
  
  {** 
   * Listener orientation.
   * Type: ALfloat[6]
   * Default: (0.0, 0.0, -1.0, 0.0, 1.0, 0.0)
   *
   * Effectively two three dimensional vectors. The first vector is the front (or
   * "at") and the second is the top (or "up").
   *
   * Both vectors are in local space.
    *}
  AL_ORIENTATION = $100F;
  
  {** 
   * Source state (query only).
   * Type:  ALint
   * Range: [AL_INITIAL, AL_PLAYING, AL_PAUSED, AL_STOPPED]
    *}
  AL_SOURCE_STATE = $1010;
  
  {  Source state values.  }
  AL_INITIAL = $1011;
  AL_PLAYING = $1012;
  AL_PAUSED = $1013;
  AL_STOPPED = $1014;
  
  {** 
   * Source Buffer Queue size (query only).
   * Type: ALint
   *
   * The number of buffers queued using alSourceQueueBuffers, minus the buffers
   * removed with alSourceUnqueueBuffers.
    *}
  AL_BUFFERS_QUEUED = $1015;
  
  {** 
   * Source Buffer Queue processed count (query only).
   * Type: ALint
   *
   * The number of queued buffers that have been fully processed, and can be
   * removed with alSourceUnqueueBuffers.
   *
   * Looping sources will never fully process buffers because they will be set to
   * play again for when the source loops.
    *}
  AL_BUFFERS_PROCESSED = $1016;
  
  {** 
   * Source reference distance.
   * Type:    ALfloat
   * Range:   [0.0 - ]
   * Default: 1.0
   *
   * The distance in units that no attenuation occurs.
   *
   * At 0.0, no distance attenuation ever occurs on non-linear attenuation models.
    *}
  AL_REFERENCE_DISTANCE = $1020;
  
  {** 
   * Source rolloff factor.
   * Type:    ALfloat
   * Range:   [0.0 - ]
   * Default: 1.0
   *
   * Multiplier to exaggerate or diminish distance attenuation.
   *
   * At 0.0, no distance attenuation ever occurs.
    *}
  AL_ROLLOFF_FACTOR = $1021;
  
  {** 
   * Outer cone gain.
   * Type:    ALfloat
   * Range:   [0.0 - 1.0]
   * Default: 0.0
   *
   * The gain attenuation applied when the listener is outside of the source's
   * outer cone.
    *}
  AL_CONE_OUTER_GAIN = $1022;
  
  {** 
   * Source maximum distance.
   * Type:    ALfloat
   * Range:   [0.0 - ]
   * Default: FLT_MAX
   *
   * The distance above which the source is not attenuated any further with a
   * clamped distance model, or where attenuation reaches 0.0 gain for linear
   * distance models with a default rolloff factor.
    *}
  AL_MAX_DISTANCE = $1023;
  
  {  Source buffer position, in seconds  }
  AL_SEC_OFFSET = $1024;
  {  Source buffer position, in sample frames  }
  AL_SAMPLE_OFFSET = $1025;
  {  Source buffer position, in bytes  }
  AL_BYTE_OFFSET = $1026;
  
  {** 
   * Source type (query only).
   * Type:  ALint
   * Range: [AL_STATIC, AL_STREAMING, AL_UNDETERMINED]
   *
   * A Source is Static if a Buffer has been attached using AL_BUFFER.
   *
   * A Source is Streaming if one or more Buffers have been attached using
   * alSourceQueueBuffers.
   *
   * A Source is Undetermined when it has the NULL buffer attached using
   * AL_BUFFER.
    *}
  AL_SOURCE_TYPE = $1027;
  
  {  Source type values.  }
  AL_STATIC = $1028;
  AL_STREAMING = $1029;
  AL_UNDETERMINED = $1030;
  
  {  Unsigned 8-bit mono buffer format.  }
  AL_FORMAT_MONO8 = $1100;
  {  Signed 16-bit mono buffer format.  }
  AL_FORMAT_MONO16 = $1101;
  {  Unsigned 8-bit stereo buffer format.  }
  AL_FORMAT_STEREO8 = $1102;
  {  Signed 16-bit stereo buffer format.  }
  AL_FORMAT_STEREO16 = $1103;
  
  {  Buffer frequency (query only).  }
  AL_FREQUENCY = $2001;
  {  Buffer bits per sample (query only).  }
  AL_BITS = $2002;
  {  Buffer channel count (query only).  }
  AL_CHANNELS = $2003;
  {  Buffer data size (query only).  }
  AL_SIZE = $2004;
  
  {  Buffer state. Not for public use.  }
  AL_UNUSED = $2010;
  AL_PENDING = $2011;
  AL_PROCESSED = $2012;
  
  
  {  Context string: Vendor ID.  }
  AL_VENDOR = $B001;
  {  Context string: Version.  }
  AL_VERSION = $B002;
  {  Context string: Renderer ID.  }
  AL_RENDERER = $B003;
  {  Context string: Space-separated extension list.  }
  AL_EXTENSIONS = $B004;
  
  
  {** 
   * Doppler scale.
   * Type:    ALfloat
   * Range:   [0.0 - ]
   * Default: 1.0
   *
   * Scale for source and listener velocities.
    *}
  AL_DOPPLER_FACTOR = $C000;
  
  {** 
   * Doppler velocity (deprecated).
   *
   * A multiplier applied to the Speed of Sound.
    *}
  AL_DOPPLER_VELOCITY = $C001;
  
  {** 
   * Speed of Sound, in units per second.
   * Type:    ALfloat
   * Range:   [0.0001 - ]
   * Default: 343.3
   *
   * The speed at which sound waves are assumed to travel, when calculating the
   * doppler effect.
    *}
  AL_SPEED_OF_SOUND = $C003;
  
  {** 
   * Distance attenuation model.
   * Type:    ALint
   * Range:   [AL_NONE, AL_INVERSE_DISTANCE, AL_INVERSE_DISTANCE_CLAMPED,
   *           AL_LINEAR_DISTANCE, AL_LINEAR_DISTANCE_CLAMPED,
   *           AL_EXPONENT_DISTANCE, AL_EXPONENT_DISTANCE_CLAMPED]
   * Default: AL_INVERSE_DISTANCE_CLAMPED
   *
   * The model by which sources attenuate with distance.
   *
   * None     - No distance attenuation.
   * Inverse  - Doubling the distance halves the source gain.
   * Linear   - Linear gain scaling between the reference and max distances.
   * Exponent - Exponential gain dropoff.
   *
   * Clamped variations work like the non-clamped counterparts, except the
   * distance calculated is clamped between the reference and max distances.
    *}
  AL_DISTANCE_MODEL = $D000;
  
  {  Distance model values.  }
  AL_INVERSE_DISTANCE = $D001;
  AL_INVERSE_DISTANCE_CLAMPED = $D002;
  AL_LINEAR_DISTANCE = $D003;
  AL_LINEAR_DISTANCE_CLAMPED = $D004;
  AL_EXPONENT_DISTANCE = $D005;
  AL_EXPONENT_DISTANCE_CLAMPED = $D006;


procedure alDopplerVelocity(value: ALfloat);
procedure alSpeedOfSound(value: ALfloat);
procedure alDistanceModel(distanceModel: ALenum);
procedure alEnable(capability: ALenum);
procedure alDisable(capability: ALenum);
function alIsEnabled(capability: ALenum): ALboolean;
function alGetString(param: ALenum): pALchar;
procedure alGetBooleanv(param: ALenum; values: pALboolean);
procedure alGetIntegerv(param: ALenum; values: pALint);
procedure alGetFloatv(param: ALenum; values: pALfloat);
procedure alGetDoublev(param: ALenum; values: pALdouble);
function alGetBoolean(param: ALenum): ALboolean;
function alGetInteger(param: ALenum): ALint;
function alGetFloat(param: ALenum): ALfloat;
function alGetDouble(param: ALenum): ALdouble;
function alGetError(): ALenum;
function alIsExtensionPresent(const extname: pALchar): ALboolean;
function alGetProcAddress(const fname: pALchar): pointer;
function alGetEnumValue(const ename: pALchar): ALenum;
procedure alListenerf(param: ALenum; value: ALfloat);
procedure alListener3f(param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat);
procedure alListenerfv(param: ALenum; const values: pALfloat);
procedure alListeneri(param: ALenum; value: ALint);
procedure alListener3i(param: ALenum; value1: ALint; value2: ALint; value3: ALint);
procedure alListeneriv(param: ALenum; const values: pALint);
procedure alGetListenerf(param: ALenum; value: pALfloat);
procedure alGetListener3f(param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat);
procedure alGetListenerfv(param: ALenum; values: pALfloat);
procedure alGetListeneri(param: ALenum; value: pALint);
procedure alGetListener3i(param: ALenum; value1: pALint; value2: pALint; value3: pALint);
procedure alGetListeneriv(param: ALenum; values: pALint);
procedure alGenSources(n: ALsizei; sources: pALuint);
procedure alDeleteSources(n: ALsizei; const sources: pALuint);
function alIsSource(source: ALuint): ALboolean;
procedure alSourcef(source: ALuint; param: ALenum; value: ALfloat);
procedure alSource3f(source: ALuint; param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat);
procedure alSourcefv(source: ALuint; param: ALenum; const values: pALfloat);
procedure alSourcei(source: ALuint; param: ALenum; value: ALint);
procedure alSource3i(source: ALuint; param: ALenum; value1: ALint; value2: ALint; value3: ALint);
procedure alSourceiv(source: ALuint; param: ALenum; const values: pALint);
procedure alGetSourcef(source: ALuint; param: ALenum; value: pALfloat);
procedure alGetSource3f(source: ALuint; param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat);
procedure alGetSourcefv(source: ALuint; param: ALenum; values: pALfloat);
procedure alGetSourcei(source: ALuint; param: ALenum; value: pALint);
procedure alGetSource3i(source: ALuint; param: ALenum; value1: pALint; value2: pALint; value3: pALint);
procedure alGetSourceiv(source: ALuint; param: ALenum; values: pALint);
procedure alSourcePlayv(n: ALsizei; const sources: pALuint);
procedure alSourceStopv(n: ALsizei; const sources: pALuint);
procedure alSourceRewindv(n: ALsizei; const sources: pALuint);
procedure alSourcePausev(n: ALsizei; const sources: pALuint);
procedure alSourcePlay(source: ALuint);
procedure alSourceStop(source: ALuint);
procedure alSourceRewind(source: ALuint);
procedure alSourcePause(source: ALuint);
procedure alSourceQueueBuffers(source: ALuint; nb: ALsizei; const buffers: pALuint);
procedure alSourceUnqueueBuffers(source: ALuint; nb: ALsizei; buffers: pALuint);
procedure alGenBuffers(n: ALsizei; buffers: pALuint);
procedure alDeleteBuffers(n: ALsizei; const buffers: pALuint);
function alIsBuffer(buffer: ALuint): ALboolean;
procedure alBufferData(buffer: ALuint; format: ALenum; const data: pALvoid; size: ALsizei; freq: ALsizei);
procedure alBufferf(buffer: ALuint; param: ALenum; value: ALfloat);
procedure alBuffer3f(buffer: ALuint; param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat);
procedure alBufferfv(buffer: ALuint; param: ALenum; const values: pALfloat);
procedure alBufferi(buffer: ALuint; param: ALenum; value: ALint);
procedure alBuffer3i(buffer: ALuint; param: ALenum; value1: ALint; value2: ALint; value3: ALint);
procedure alBufferiv(buffer: ALuint; param: ALenum; const values: pALint);
procedure alGetBufferf(buffer: ALuint; param: ALenum; value: pALfloat);
procedure alGetBuffer3f(buffer: ALuint; param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat);
procedure alGetBufferfv(buffer: ALuint; param: ALenum; values: pALfloat);
procedure alGetBufferi(buffer: ALuint; param: ALenum; value: pALint);
procedure alGetBuffer3i(buffer: ALuint; param: ALenum; value1: pALint; value2: pALint; value3: pALint);
procedure alGetBufferiv(buffer: ALuint; param: ALenum; values: pALint);
function alcCreateContext(device: pALCdevice; const attrlist: pALCint): pALCcontext;
function alcMakeContextCurrent(context: pALCcontext): ALCboolean;
procedure alcProcessContext(context: pALCcontext);
procedure alcSuspendContext(context: pALCcontext);
procedure alcDestroyContext(context: pALCcontext);
function alcGetCurrentContext(): pALCcontext;
function alcGetContextsDevice(context: pALCcontext): pALCdevice;
function alcOpenDevice(const devicename: pALCchar): pALCdevice;
function alcCloseDevice(device: pALCdevice): ALCboolean;
function alcGetError(device: pALCdevice): ALCenum;
function alcIsExtensionPresent(device: pALCdevice; const extname: pALCchar): ALCboolean;
function alcGetProcAddress(device: pALCdevice; const funcname: pALCchar): pALCvoid;
function alcGetEnumValue(device: pALCdevice; const enumname: pALCchar): ALCenum;
function alcGetString(device: pALCdevice; param: ALCenum): pALCchar;
procedure alcGetIntegerv(device: pALCdevice; param: ALCenum; size: ALCsizei; values: pALCint);
function alcCaptureOpenDevice(const devicename: pALCchar; frequency: ALCuint; format: ALCenum; buffersize: ALCsizei): pALCdevice;
function alcCaptureCloseDevice(device: pALCdevice): ALCboolean;
procedure alcCaptureStart(device: pALCdevice);
procedure alcCaptureStop(device: pALCdevice);
procedure alcCaptureSamples(device: pALCdevice; buffer: pALCvoid; samples: ALCsizei);

function IsOpenALsoftloaded: boolean; 
function InitOpenALsoftInterface(const aLibs : Array of String): boolean; overload; 
function DestroyOpenALsoftInterface: boolean; 

implementation

var
  OpenALsoftloaded: boolean = False;
  OpenALsoftLib: Array of HModule;
resourcestring
  SFailedToLoadOpenALsoft = 'Failed to load OpenALsoft library';

type

  p_alDopplerVelocity = procedure(value: ALfloat); cdecl;
  p_alSpeedOfSound = procedure(value: ALfloat); cdecl;
  p_alDistanceModel = procedure(distanceModel: ALenum); cdecl;
  p_alEnable = procedure(capability: ALenum); cdecl;
  p_alDisable = procedure(capability: ALenum); cdecl;
  p_alIsEnabled = function(capability: ALenum): ALboolean; cdecl;
  p_alGetString = function(param: ALenum): pALchar; cdecl;
  p_alGetBooleanv = procedure(param: ALenum; values: pALboolean); cdecl;
  p_alGetIntegerv = procedure(param: ALenum; values: pALint); cdecl;
  p_alGetFloatv = procedure(param: ALenum; values: pALfloat); cdecl;
  p_alGetDoublev = procedure(param: ALenum; values: pALdouble); cdecl;
  p_alGetBoolean = function(param: ALenum): ALboolean; cdecl;
  p_alGetInteger = function(param: ALenum): ALint; cdecl;
  p_alGetFloat = function(param: ALenum): ALfloat; cdecl;
  p_alGetDouble = function(param: ALenum): ALdouble; cdecl;
  p_alGetError = function(): ALenum; cdecl;
  p_alIsExtensionPresent = function(const extname: pALchar): ALboolean; cdecl;
  p_alGetProcAddress = function(const fname: pALchar): pointer; cdecl;
  p_alGetEnumValue = function(const ename: pALchar): ALenum; cdecl;
  p_alListenerf = procedure(param: ALenum; value: ALfloat); cdecl;
  p_alListener3f = procedure(param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat); cdecl;
  p_alListenerfv = procedure(param: ALenum; const values: pALfloat); cdecl;
  p_alListeneri = procedure(param: ALenum; value: ALint); cdecl;
  p_alListener3i = procedure(param: ALenum; value1: ALint; value2: ALint; value3: ALint); cdecl;
  p_alListeneriv = procedure(param: ALenum; const values: pALint); cdecl;
  p_alGetListenerf = procedure(param: ALenum; value: pALfloat); cdecl;
  p_alGetListener3f = procedure(param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat); cdecl;
  p_alGetListenerfv = procedure(param: ALenum; values: pALfloat); cdecl;
  p_alGetListeneri = procedure(param: ALenum; value: pALint); cdecl;
  p_alGetListener3i = procedure(param: ALenum; value1: pALint; value2: pALint; value3: pALint); cdecl;
  p_alGetListeneriv = procedure(param: ALenum; values: pALint); cdecl;
  p_alGenSources = procedure(n: ALsizei; sources: pALuint); cdecl;
  p_alDeleteSources = procedure(n: ALsizei; const sources: pALuint); cdecl;
  p_alIsSource = function(source: ALuint): ALboolean; cdecl;
  p_alSourcef = procedure(source: ALuint; param: ALenum; value: ALfloat); cdecl;
  p_alSource3f = procedure(source: ALuint; param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat); cdecl;
  p_alSourcefv = procedure(source: ALuint; param: ALenum; const values: pALfloat); cdecl;
  p_alSourcei = procedure(source: ALuint; param: ALenum; value: ALint); cdecl;
  p_alSource3i = procedure(source: ALuint; param: ALenum; value1: ALint; value2: ALint; value3: ALint); cdecl;
  p_alSourceiv = procedure(source: ALuint; param: ALenum; const values: pALint); cdecl;
  p_alGetSourcef = procedure(source: ALuint; param: ALenum; value: pALfloat); cdecl;
  p_alGetSource3f = procedure(source: ALuint; param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat); cdecl;
  p_alGetSourcefv = procedure(source: ALuint; param: ALenum; values: pALfloat); cdecl;
  p_alGetSourcei = procedure(source: ALuint; param: ALenum; value: pALint); cdecl;
  p_alGetSource3i = procedure(source: ALuint; param: ALenum; value1: pALint; value2: pALint; value3: pALint); cdecl;
  p_alGetSourceiv = procedure(source: ALuint; param: ALenum; values: pALint); cdecl;
  p_alSourcePlayv = procedure(n: ALsizei; const sources: pALuint); cdecl;
  p_alSourceStopv = procedure(n: ALsizei; const sources: pALuint); cdecl;
  p_alSourceRewindv = procedure(n: ALsizei; const sources: pALuint); cdecl;
  p_alSourcePausev = procedure(n: ALsizei; const sources: pALuint); cdecl;
  p_alSourcePlay = procedure(source: ALuint); cdecl;
  p_alSourceStop = procedure(source: ALuint); cdecl;
  p_alSourceRewind = procedure(source: ALuint); cdecl;
  p_alSourcePause = procedure(source: ALuint); cdecl;
  p_alSourceQueueBuffers = procedure(source: ALuint; nb: ALsizei; const buffers: pALuint); cdecl;
  p_alSourceUnqueueBuffers = procedure(source: ALuint; nb: ALsizei; buffers: pALuint); cdecl;
  p_alGenBuffers = procedure(n: ALsizei; buffers: pALuint); cdecl;
  p_alDeleteBuffers = procedure(n: ALsizei; const buffers: pALuint); cdecl;
  p_alIsBuffer = function(buffer: ALuint): ALboolean; cdecl;
  p_alBufferData = procedure(buffer: ALuint; format: ALenum; const data: pALvoid; size: ALsizei; freq: ALsizei); cdecl;
  p_alBufferf = procedure(buffer: ALuint; param: ALenum; value: ALfloat); cdecl;
  p_alBuffer3f = procedure(buffer: ALuint; param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat); cdecl;
  p_alBufferfv = procedure(buffer: ALuint; param: ALenum; const values: pALfloat); cdecl;
  p_alBufferi = procedure(buffer: ALuint; param: ALenum; value: ALint); cdecl;
  p_alBuffer3i = procedure(buffer: ALuint; param: ALenum; value1: ALint; value2: ALint; value3: ALint); cdecl;
  p_alBufferiv = procedure(buffer: ALuint; param: ALenum; const values: pALint); cdecl;
  p_alGetBufferf = procedure(buffer: ALuint; param: ALenum; value: pALfloat); cdecl;
  p_alGetBuffer3f = procedure(buffer: ALuint; param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat); cdecl;
  p_alGetBufferfv = procedure(buffer: ALuint; param: ALenum; values: pALfloat); cdecl;
  p_alGetBufferi = procedure(buffer: ALuint; param: ALenum; value: pALint); cdecl;
  p_alGetBuffer3i = procedure(buffer: ALuint; param: ALenum; value1: pALint; value2: pALint; value3: pALint); cdecl;
  p_alGetBufferiv = procedure(buffer: ALuint; param: ALenum; values: pALint); cdecl;
  p_alcCreateContext = function(device: pALCdevice; const attrlist: pALCint): pALCcontext; cdecl;
  p_alcMakeContextCurrent = function(context: pALCcontext): ALCboolean; cdecl;
  p_alcProcessContext = procedure(context: pALCcontext); cdecl;
  p_alcSuspendContext = procedure(context: pALCcontext); cdecl;
  p_alcDestroyContext = procedure(context: pALCcontext); cdecl;
  p_alcGetCurrentContext = function(): pALCcontext; cdecl;
  p_alcGetContextsDevice = function(context: pALCcontext): pALCdevice; cdecl;
  p_alcOpenDevice = function(const devicename: pALCchar): pALCdevice; cdecl;
  p_alcCloseDevice = function(device: pALCdevice): ALCboolean; cdecl;
  p_alcGetError = function(device: pALCdevice): ALCenum; cdecl;
  p_alcIsExtensionPresent = function(device: pALCdevice; const extname: pALCchar): ALCboolean; cdecl;
  p_alcGetProcAddress = function(device: pALCdevice; const funcname: pALCchar): pALCvoid; cdecl;
  p_alcGetEnumValue = function(device: pALCdevice; const enumname: pALCchar): ALCenum; cdecl;
  p_alcGetString = function(device: pALCdevice; param: ALCenum): pALCchar; cdecl;
  p_alcGetIntegerv = procedure(device: pALCdevice; param: ALCenum; size: ALCsizei; values: pALCint); cdecl;
  p_alcCaptureOpenDevice = function(const devicename: pALCchar; frequency: ALCuint; format: ALCenum; buffersize: ALCsizei): pALCdevice; cdecl;
  p_alcCaptureCloseDevice = function(device: pALCdevice): ALCboolean; cdecl;
  p_alcCaptureStart = procedure(device: pALCdevice); cdecl;
  p_alcCaptureStop = procedure(device: pALCdevice); cdecl;
  p_alcCaptureSamples = procedure(device: pALCdevice; buffer: pALCvoid; samples: ALCsizei); cdecl;

var

  _alDopplerVelocity: p_alDopplerVelocity = nil;
  _alSpeedOfSound: p_alSpeedOfSound = nil;
  _alDistanceModel: p_alDistanceModel = nil;
  _alEnable: p_alEnable = nil;
  _alDisable: p_alDisable = nil;
  _alIsEnabled: p_alIsEnabled = nil;
  _alGetString: p_alGetString = nil;
  _alGetBooleanv: p_alGetBooleanv = nil;
  _alGetIntegerv: p_alGetIntegerv = nil;
  _alGetFloatv: p_alGetFloatv = nil;
  _alGetDoublev: p_alGetDoublev = nil;
  _alGetBoolean: p_alGetBoolean = nil;
  _alGetInteger: p_alGetInteger = nil;
  _alGetFloat: p_alGetFloat = nil;
  _alGetDouble: p_alGetDouble = nil;
  _alGetError: p_alGetError = nil;
  _alIsExtensionPresent: p_alIsExtensionPresent = nil;
  _alGetProcAddress: p_alGetProcAddress = nil;
  _alGetEnumValue: p_alGetEnumValue = nil;
  _alListenerf: p_alListenerf = nil;
  _alListener3f: p_alListener3f = nil;
  _alListenerfv: p_alListenerfv = nil;
  _alListeneri: p_alListeneri = nil;
  _alListener3i: p_alListener3i = nil;
  _alListeneriv: p_alListeneriv = nil;
  _alGetListenerf: p_alGetListenerf = nil;
  _alGetListener3f: p_alGetListener3f = nil;
  _alGetListenerfv: p_alGetListenerfv = nil;
  _alGetListeneri: p_alGetListeneri = nil;
  _alGetListener3i: p_alGetListener3i = nil;
  _alGetListeneriv: p_alGetListeneriv = nil;
  _alGenSources: p_alGenSources = nil;
  _alDeleteSources: p_alDeleteSources = nil;
  _alIsSource: p_alIsSource = nil;
  _alSourcef: p_alSourcef = nil;
  _alSource3f: p_alSource3f = nil;
  _alSourcefv: p_alSourcefv = nil;
  _alSourcei: p_alSourcei = nil;
  _alSource3i: p_alSource3i = nil;
  _alSourceiv: p_alSourceiv = nil;
  _alGetSourcef: p_alGetSourcef = nil;
  _alGetSource3f: p_alGetSource3f = nil;
  _alGetSourcefv: p_alGetSourcefv = nil;
  _alGetSourcei: p_alGetSourcei = nil;
  _alGetSource3i: p_alGetSource3i = nil;
  _alGetSourceiv: p_alGetSourceiv = nil;
  _alSourcePlayv: p_alSourcePlayv = nil;
  _alSourceStopv: p_alSourceStopv = nil;
  _alSourceRewindv: p_alSourceRewindv = nil;
  _alSourcePausev: p_alSourcePausev = nil;
  _alSourcePlay: p_alSourcePlay = nil;
  _alSourceStop: p_alSourceStop = nil;
  _alSourceRewind: p_alSourceRewind = nil;
  _alSourcePause: p_alSourcePause = nil;
  _alSourceQueueBuffers: p_alSourceQueueBuffers = nil;
  _alSourceUnqueueBuffers: p_alSourceUnqueueBuffers = nil;
  _alGenBuffers: p_alGenBuffers = nil;
  _alDeleteBuffers: p_alDeleteBuffers = nil;
  _alIsBuffer: p_alIsBuffer = nil;
  _alBufferData: p_alBufferData = nil;
  _alBufferf: p_alBufferf = nil;
  _alBuffer3f: p_alBuffer3f = nil;
  _alBufferfv: p_alBufferfv = nil;
  _alBufferi: p_alBufferi = nil;
  _alBuffer3i: p_alBuffer3i = nil;
  _alBufferiv: p_alBufferiv = nil;
  _alGetBufferf: p_alGetBufferf = nil;
  _alGetBuffer3f: p_alGetBuffer3f = nil;
  _alGetBufferfv: p_alGetBufferfv = nil;
  _alGetBufferi: p_alGetBufferi = nil;
  _alGetBuffer3i: p_alGetBuffer3i = nil;
  _alGetBufferiv: p_alGetBufferiv = nil;
  _alcCreateContext: p_alcCreateContext = nil;
  _alcMakeContextCurrent: p_alcMakeContextCurrent = nil;
  _alcProcessContext: p_alcProcessContext = nil;
  _alcSuspendContext: p_alcSuspendContext = nil;
  _alcDestroyContext: p_alcDestroyContext = nil;
  _alcGetCurrentContext: p_alcGetCurrentContext = nil;
  _alcGetContextsDevice: p_alcGetContextsDevice = nil;
  _alcOpenDevice: p_alcOpenDevice = nil;
  _alcCloseDevice: p_alcCloseDevice = nil;
  _alcGetError: p_alcGetError = nil;
  _alcIsExtensionPresent: p_alcIsExtensionPresent = nil;
  _alcGetProcAddress: p_alcGetProcAddress = nil;
  _alcGetEnumValue: p_alcGetEnumValue = nil;
  _alcGetString: p_alcGetString = nil;
  _alcGetIntegerv: p_alcGetIntegerv = nil;
  _alcCaptureOpenDevice: p_alcCaptureOpenDevice = nil;
  _alcCaptureCloseDevice: p_alcCaptureCloseDevice = nil;
  _alcCaptureStart: p_alcCaptureStart = nil;
  _alcCaptureStop: p_alcCaptureStop = nil;
  _alcCaptureSamples: p_alcCaptureSamples = nil;

{$IFNDEF WINDOWS}
{ Try to load all library versions until you find or run out }
procedure LoadLibUnix(const aLibs : Array of String);
var i : integer;
begin
  for i := 0 to High(aLibs) do
  begin
    OpenALsoftLib[i] := LoadLibrary(aLibs[i]);
  end;
end;

{$ELSE WINDOWS}
procedure LoadLibsWin(const aLibs : Array of String);
var i : integer;
begin
  for i := 0 to High(aLibs) do
  begin
    OpenALsoftLib[i] := LoadLibrary(aLibs[i]);
  end;
end;

{$ENDIF WINDOWS}

function IsOpenALsoftloaded: boolean;
begin
  Result := OpenALsoftloaded;
end;

procedure UnloadLibraries;
var i : integer;
begin
  OpenALsoftloaded := False;
  for i := 0 to High(OpenALsoftLib) do
  if OpenALsoftLib[i] <> NilHandle then
  begin
    FreeLibrary(OpenALsoftLib[i]);
    OpenALsoftLib[i] := NilHandle;
  end;
end;

function LoadLibraries(const aLibs : Array of String): boolean;
var i : integer;
begin
  SetLength(OpenALsoftLib, Length(aLibs));
  Result := False;
  {$IFDEF WINDOWS}
  LoadLibsWin(aLibs);
  {$ELSE}
  LoadLibUnix(aLibs);
  {$ENDIF}
  for i := 0 to High(aLibs) do
  if OpenALsoftLib[i] <> NilHandle then
     Result := true;
end;

function GetProcAddr(const module: Array of HModule; const ProcName: string): Pointer;
var i : integer;
begin
  for i := Low(module) to High(module) do 
  if module[i] <> NilHandle then 
  begin
    Result := GetProcAddress(module[i], PChar(ProcName));
    if Assigned(Result) then Exit;
  end;
end;

procedure LoadOpenALsoftEntryPoints;
begin
  _alDopplerVelocity := p_alDopplerVelocity(GetProcAddr(OpenALsoftLib, 'alDopplerVelocity'));
  _alSpeedOfSound := p_alSpeedOfSound(GetProcAddr(OpenALsoftLib, 'alSpeedOfSound'));
  _alDistanceModel := p_alDistanceModel(GetProcAddr(OpenALsoftLib, 'alDistanceModel'));
  _alEnable := p_alEnable(GetProcAddr(OpenALsoftLib, 'alEnable'));
  _alDisable := p_alDisable(GetProcAddr(OpenALsoftLib, 'alDisable'));
  _alIsEnabled := p_alIsEnabled(GetProcAddr(OpenALsoftLib, 'alIsEnabled'));
  _alGetString := p_alGetString(GetProcAddr(OpenALsoftLib, 'alGetString'));
  _alGetBooleanv := p_alGetBooleanv(GetProcAddr(OpenALsoftLib, 'alGetBooleanv'));
  _alGetIntegerv := p_alGetIntegerv(GetProcAddr(OpenALsoftLib, 'alGetIntegerv'));
  _alGetFloatv := p_alGetFloatv(GetProcAddr(OpenALsoftLib, 'alGetFloatv'));
  _alGetDoublev := p_alGetDoublev(GetProcAddr(OpenALsoftLib, 'alGetDoublev'));
  _alGetBoolean := p_alGetBoolean(GetProcAddr(OpenALsoftLib, 'alGetBoolean'));
  _alGetInteger := p_alGetInteger(GetProcAddr(OpenALsoftLib, 'alGetInteger'));
  _alGetFloat := p_alGetFloat(GetProcAddr(OpenALsoftLib, 'alGetFloat'));
  _alGetDouble := p_alGetDouble(GetProcAddr(OpenALsoftLib, 'alGetDouble'));
  _alGetError := p_alGetError(GetProcAddr(OpenALsoftLib, 'alGetError'));
  _alIsExtensionPresent := p_alIsExtensionPresent(GetProcAddr(OpenALsoftLib, 'alIsExtensionPresent'));
  _alGetProcAddress := p_alGetProcAddress(GetProcAddr(OpenALsoftLib, 'alGetProcAddress'));
  _alGetEnumValue := p_alGetEnumValue(GetProcAddr(OpenALsoftLib, 'alGetEnumValue'));
  _alListenerf := p_alListenerf(GetProcAddr(OpenALsoftLib, 'alListenerf'));
  _alListener3f := p_alListener3f(GetProcAddr(OpenALsoftLib, 'alListener3f'));
  _alListenerfv := p_alListenerfv(GetProcAddr(OpenALsoftLib, 'alListenerfv'));
  _alListeneri := p_alListeneri(GetProcAddr(OpenALsoftLib, 'alListeneri'));
  _alListener3i := p_alListener3i(GetProcAddr(OpenALsoftLib, 'alListener3i'));
  _alListeneriv := p_alListeneriv(GetProcAddr(OpenALsoftLib, 'alListeneriv'));
  _alGetListenerf := p_alGetListenerf(GetProcAddr(OpenALsoftLib, 'alGetListenerf'));
  _alGetListener3f := p_alGetListener3f(GetProcAddr(OpenALsoftLib, 'alGetListener3f'));
  _alGetListenerfv := p_alGetListenerfv(GetProcAddr(OpenALsoftLib, 'alGetListenerfv'));
  _alGetListeneri := p_alGetListeneri(GetProcAddr(OpenALsoftLib, 'alGetListeneri'));
  _alGetListener3i := p_alGetListener3i(GetProcAddr(OpenALsoftLib, 'alGetListener3i'));
  _alGetListeneriv := p_alGetListeneriv(GetProcAddr(OpenALsoftLib, 'alGetListeneriv'));
  _alGenSources := p_alGenSources(GetProcAddr(OpenALsoftLib, 'alGenSources'));
  _alDeleteSources := p_alDeleteSources(GetProcAddr(OpenALsoftLib, 'alDeleteSources'));
  _alIsSource := p_alIsSource(GetProcAddr(OpenALsoftLib, 'alIsSource'));
  _alSourcef := p_alSourcef(GetProcAddr(OpenALsoftLib, 'alSourcef'));
  _alSource3f := p_alSource3f(GetProcAddr(OpenALsoftLib, 'alSource3f'));
  _alSourcefv := p_alSourcefv(GetProcAddr(OpenALsoftLib, 'alSourcefv'));
  _alSourcei := p_alSourcei(GetProcAddr(OpenALsoftLib, 'alSourcei'));
  _alSource3i := p_alSource3i(GetProcAddr(OpenALsoftLib, 'alSource3i'));
  _alSourceiv := p_alSourceiv(GetProcAddr(OpenALsoftLib, 'alSourceiv'));
  _alGetSourcef := p_alGetSourcef(GetProcAddr(OpenALsoftLib, 'alGetSourcef'));
  _alGetSource3f := p_alGetSource3f(GetProcAddr(OpenALsoftLib, 'alGetSource3f'));
  _alGetSourcefv := p_alGetSourcefv(GetProcAddr(OpenALsoftLib, 'alGetSourcefv'));
  _alGetSourcei := p_alGetSourcei(GetProcAddr(OpenALsoftLib, 'alGetSourcei'));
  _alGetSource3i := p_alGetSource3i(GetProcAddr(OpenALsoftLib, 'alGetSource3i'));
  _alGetSourceiv := p_alGetSourceiv(GetProcAddr(OpenALsoftLib, 'alGetSourceiv'));
  _alSourcePlayv := p_alSourcePlayv(GetProcAddr(OpenALsoftLib, 'alSourcePlayv'));
  _alSourceStopv := p_alSourceStopv(GetProcAddr(OpenALsoftLib, 'alSourceStopv'));
  _alSourceRewindv := p_alSourceRewindv(GetProcAddr(OpenALsoftLib, 'alSourceRewindv'));
  _alSourcePausev := p_alSourcePausev(GetProcAddr(OpenALsoftLib, 'alSourcePausev'));
  _alSourcePlay := p_alSourcePlay(GetProcAddr(OpenALsoftLib, 'alSourcePlay'));
  _alSourceStop := p_alSourceStop(GetProcAddr(OpenALsoftLib, 'alSourceStop'));
  _alSourceRewind := p_alSourceRewind(GetProcAddr(OpenALsoftLib, 'alSourceRewind'));
  _alSourcePause := p_alSourcePause(GetProcAddr(OpenALsoftLib, 'alSourcePause'));
  _alSourceQueueBuffers := p_alSourceQueueBuffers(GetProcAddr(OpenALsoftLib, 'alSourceQueueBuffers'));
  _alSourceUnqueueBuffers := p_alSourceUnqueueBuffers(GetProcAddr(OpenALsoftLib, 'alSourceUnqueueBuffers'));
  _alGenBuffers := p_alGenBuffers(GetProcAddr(OpenALsoftLib, 'alGenBuffers'));
  _alDeleteBuffers := p_alDeleteBuffers(GetProcAddr(OpenALsoftLib, 'alDeleteBuffers'));
  _alIsBuffer := p_alIsBuffer(GetProcAddr(OpenALsoftLib, 'alIsBuffer'));
  _alBufferData := p_alBufferData(GetProcAddr(OpenALsoftLib, 'alBufferData'));
  _alBufferf := p_alBufferf(GetProcAddr(OpenALsoftLib, 'alBufferf'));
  _alBuffer3f := p_alBuffer3f(GetProcAddr(OpenALsoftLib, 'alBuffer3f'));
  _alBufferfv := p_alBufferfv(GetProcAddr(OpenALsoftLib, 'alBufferfv'));
  _alBufferi := p_alBufferi(GetProcAddr(OpenALsoftLib, 'alBufferi'));
  _alBuffer3i := p_alBuffer3i(GetProcAddr(OpenALsoftLib, 'alBuffer3i'));
  _alBufferiv := p_alBufferiv(GetProcAddr(OpenALsoftLib, 'alBufferiv'));
  _alGetBufferf := p_alGetBufferf(GetProcAddr(OpenALsoftLib, 'alGetBufferf'));
  _alGetBuffer3f := p_alGetBuffer3f(GetProcAddr(OpenALsoftLib, 'alGetBuffer3f'));
  _alGetBufferfv := p_alGetBufferfv(GetProcAddr(OpenALsoftLib, 'alGetBufferfv'));
  _alGetBufferi := p_alGetBufferi(GetProcAddr(OpenALsoftLib, 'alGetBufferi'));
  _alGetBuffer3i := p_alGetBuffer3i(GetProcAddr(OpenALsoftLib, 'alGetBuffer3i'));
  _alGetBufferiv := p_alGetBufferiv(GetProcAddr(OpenALsoftLib, 'alGetBufferiv'));
  _alcCreateContext := p_alcCreateContext(GetProcAddr(OpenALsoftLib, 'alcCreateContext'));
  _alcMakeContextCurrent := p_alcMakeContextCurrent(GetProcAddr(OpenALsoftLib, 'alcMakeContextCurrent'));
  _alcProcessContext := p_alcProcessContext(GetProcAddr(OpenALsoftLib, 'alcProcessContext'));
  _alcSuspendContext := p_alcSuspendContext(GetProcAddr(OpenALsoftLib, 'alcSuspendContext'));
  _alcDestroyContext := p_alcDestroyContext(GetProcAddr(OpenALsoftLib, 'alcDestroyContext'));
  _alcGetCurrentContext := p_alcGetCurrentContext(GetProcAddr(OpenALsoftLib, 'alcGetCurrentContext'));
  _alcGetContextsDevice := p_alcGetContextsDevice(GetProcAddr(OpenALsoftLib, 'alcGetContextsDevice'));
  _alcOpenDevice := p_alcOpenDevice(GetProcAddr(OpenALsoftLib, 'alcOpenDevice'));
  _alcCloseDevice := p_alcCloseDevice(GetProcAddr(OpenALsoftLib, 'alcCloseDevice'));
  _alcGetError := p_alcGetError(GetProcAddr(OpenALsoftLib, 'alcGetError'));
  _alcIsExtensionPresent := p_alcIsExtensionPresent(GetProcAddr(OpenALsoftLib, 'alcIsExtensionPresent'));
  _alcGetProcAddress := p_alcGetProcAddress(GetProcAddr(OpenALsoftLib, 'alcGetProcAddress'));
  _alcGetEnumValue := p_alcGetEnumValue(GetProcAddr(OpenALsoftLib, 'alcGetEnumValue'));
  _alcGetString := p_alcGetString(GetProcAddr(OpenALsoftLib, 'alcGetString'));
  _alcGetIntegerv := p_alcGetIntegerv(GetProcAddr(OpenALsoftLib, 'alcGetIntegerv'));
  _alcCaptureOpenDevice := p_alcCaptureOpenDevice(GetProcAddr(OpenALsoftLib, 'alcCaptureOpenDevice'));
  _alcCaptureCloseDevice := p_alcCaptureCloseDevice(GetProcAddr(OpenALsoftLib, 'alcCaptureCloseDevice'));
  _alcCaptureStart := p_alcCaptureStart(GetProcAddr(OpenALsoftLib, 'alcCaptureStart'));
  _alcCaptureStop := p_alcCaptureStop(GetProcAddr(OpenALsoftLib, 'alcCaptureStop'));
  _alcCaptureSamples := p_alcCaptureSamples(GetProcAddr(OpenALsoftLib, 'alcCaptureSamples'));
end;

procedure ClearOpenALsoftEntryPoints;
begin
  _alDopplerVelocity := nil;
  _alSpeedOfSound := nil;
  _alDistanceModel := nil;
  _alEnable := nil;
  _alDisable := nil;
  _alIsEnabled := nil;
  _alGetString := nil;
  _alGetBooleanv := nil;
  _alGetIntegerv := nil;
  _alGetFloatv := nil;
  _alGetDoublev := nil;
  _alGetBoolean := nil;
  _alGetInteger := nil;
  _alGetFloat := nil;
  _alGetDouble := nil;
  _alGetError := nil;
  _alIsExtensionPresent := nil;
  _alGetProcAddress := nil;
  _alGetEnumValue := nil;
  _alListenerf := nil;
  _alListener3f := nil;
  _alListenerfv := nil;
  _alListeneri := nil;
  _alListener3i := nil;
  _alListeneriv := nil;
  _alGetListenerf := nil;
  _alGetListener3f := nil;
  _alGetListenerfv := nil;
  _alGetListeneri := nil;
  _alGetListener3i := nil;
  _alGetListeneriv := nil;
  _alGenSources := nil;
  _alDeleteSources := nil;
  _alIsSource := nil;
  _alSourcef := nil;
  _alSource3f := nil;
  _alSourcefv := nil;
  _alSourcei := nil;
  _alSource3i := nil;
  _alSourceiv := nil;
  _alGetSourcef := nil;
  _alGetSource3f := nil;
  _alGetSourcefv := nil;
  _alGetSourcei := nil;
  _alGetSource3i := nil;
  _alGetSourceiv := nil;
  _alSourcePlayv := nil;
  _alSourceStopv := nil;
  _alSourceRewindv := nil;
  _alSourcePausev := nil;
  _alSourcePlay := nil;
  _alSourceStop := nil;
  _alSourceRewind := nil;
  _alSourcePause := nil;
  _alSourceQueueBuffers := nil;
  _alSourceUnqueueBuffers := nil;
  _alGenBuffers := nil;
  _alDeleteBuffers := nil;
  _alIsBuffer := nil;
  _alBufferData := nil;
  _alBufferf := nil;
  _alBuffer3f := nil;
  _alBufferfv := nil;
  _alBufferi := nil;
  _alBuffer3i := nil;
  _alBufferiv := nil;
  _alGetBufferf := nil;
  _alGetBuffer3f := nil;
  _alGetBufferfv := nil;
  _alGetBufferi := nil;
  _alGetBuffer3i := nil;
  _alGetBufferiv := nil;
  _alcCreateContext := nil;
  _alcMakeContextCurrent := nil;
  _alcProcessContext := nil;
  _alcSuspendContext := nil;
  _alcDestroyContext := nil;
  _alcGetCurrentContext := nil;
  _alcGetContextsDevice := nil;
  _alcOpenDevice := nil;
  _alcCloseDevice := nil;
  _alcGetError := nil;
  _alcIsExtensionPresent := nil;
  _alcGetProcAddress := nil;
  _alcGetEnumValue := nil;
  _alcGetString := nil;
  _alcGetIntegerv := nil;
  _alcCaptureOpenDevice := nil;
  _alcCaptureCloseDevice := nil;
  _alcCaptureStart := nil;
  _alcCaptureStop := nil;
  _alcCaptureSamples := nil;
end;

function InitOpenALsoftInterface(const aLibs : array of String): boolean;
begin
  Result := IsOpenALsoftloaded;
  if Result then
    exit;
  Result := LoadLibraries(aLibs);
  if not Result then
  begin
    UnloadLibraries;
    Exit;
  end;
  LoadOpenALsoftEntryPoints;
  OpenALsoftloaded := True;
  Result := True;
end;

function DestroyOpenALsoftInterface: boolean;
begin
  Result := not IsOpenALsoftloaded;
  if Result then
    exit;
  ClearOpenALsoftEntryPoints;
  UnloadLibraries;
  Result := True;
end;


procedure alDopplerVelocity(value: ALfloat);
begin
  if Assigned(_alDopplerVelocity) then
    _alDopplerVelocity(value);
end;

procedure alSpeedOfSound(value: ALfloat);
begin
  if Assigned(_alSpeedOfSound) then
    _alSpeedOfSound(value);
end;

procedure alDistanceModel(distanceModel: ALenum);
begin
  if Assigned(_alDistanceModel) then
    _alDistanceModel(distanceModel);
end;

procedure alEnable(capability: ALenum);
begin
  if Assigned(_alEnable) then
    _alEnable(capability);
end;

procedure alDisable(capability: ALenum);
begin
  if Assigned(_alDisable) then
    _alDisable(capability);
end;

function alIsEnabled(capability: ALenum): ALboolean;
begin
  if Assigned(_alIsEnabled) then
    Result := _alIsEnabled(capability)
  else
    Result := 0;
end;

function alGetString(param: ALenum): pALchar;
begin
  if Assigned(_alGetString) then
    Result := _alGetString(param)
  else
    Result := nil;
end;

procedure alGetBooleanv(param: ALenum; values: pALboolean);
begin
  if Assigned(_alGetBooleanv) then
    _alGetBooleanv(param, values);
end;

procedure alGetIntegerv(param: ALenum; values: pALint);
begin
  if Assigned(_alGetIntegerv) then
    _alGetIntegerv(param, values);
end;

procedure alGetFloatv(param: ALenum; values: pALfloat);
begin
  if Assigned(_alGetFloatv) then
    _alGetFloatv(param, values);
end;

procedure alGetDoublev(param: ALenum; values: pALdouble);
begin
  if Assigned(_alGetDoublev) then
    _alGetDoublev(param, values);
end;

function alGetBoolean(param: ALenum): ALboolean;
begin
  if Assigned(_alGetBoolean) then
    Result := _alGetBoolean(param)
  else
    Result := 0;
end;

function alGetInteger(param: ALenum): ALint;
begin
  if Assigned(_alGetInteger) then
    Result := _alGetInteger(param)
  else
    Result := 0;
end;

function alGetFloat(param: ALenum): ALfloat;
begin
  if Assigned(_alGetFloat) then
    Result := _alGetFloat(param)
  else
    Result := 0.0;
end;

function alGetDouble(param: ALenum): ALdouble;
begin
  if Assigned(_alGetDouble) then
    Result := _alGetDouble(param)
  else
    Result := 0.0;
end;

function alGetError(): ALenum;
begin
  if Assigned(_alGetError) then
    Result := _alGetError()
  else
    Result := 0;
end;

function alIsExtensionPresent(const extname: pALchar): ALboolean;
begin
  if Assigned(_alIsExtensionPresent) then
    Result := _alIsExtensionPresent(extname)
  else
    Result := 0;
end;

function alGetProcAddress(const fname: pALchar): pointer;
begin
  if Assigned(_alGetProcAddress) then
    Result := _alGetProcAddress(fname)
  else
    Result := nil;
end;

function alGetEnumValue(const ename: pALchar): ALenum;
begin
  if Assigned(_alGetEnumValue) then
    Result := _alGetEnumValue(ename)
  else
    Result := 0;
end;

procedure alListenerf(param: ALenum; value: ALfloat);
begin
  if Assigned(_alListenerf) then
    _alListenerf(param, value);
end;

procedure alListener3f(param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat);
begin
  if Assigned(_alListener3f) then
    _alListener3f(param, value1, value2, value3);
end;

procedure alListenerfv(param: ALenum; const values: pALfloat);
begin
  if Assigned(_alListenerfv) then
    _alListenerfv(param, values);
end;

procedure alListeneri(param: ALenum; value: ALint);
begin
  if Assigned(_alListeneri) then
    _alListeneri(param, value);
end;

procedure alListener3i(param: ALenum; value1: ALint; value2: ALint; value3: ALint);
begin
  if Assigned(_alListener3i) then
    _alListener3i(param, value1, value2, value3);
end;

procedure alListeneriv(param: ALenum; const values: pALint);
begin
  if Assigned(_alListeneriv) then
    _alListeneriv(param, values);
end;

procedure alGetListenerf(param: ALenum; value: pALfloat);
begin
  if Assigned(_alGetListenerf) then
    _alGetListenerf(param, value);
end;

procedure alGetListener3f(param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat);
begin
  if Assigned(_alGetListener3f) then
    _alGetListener3f(param, value1, value2, value3);
end;

procedure alGetListenerfv(param: ALenum; values: pALfloat);
begin
  if Assigned(_alGetListenerfv) then
    _alGetListenerfv(param, values);
end;

procedure alGetListeneri(param: ALenum; value: pALint);
begin
  if Assigned(_alGetListeneri) then
    _alGetListeneri(param, value);
end;

procedure alGetListener3i(param: ALenum; value1: pALint; value2: pALint; value3: pALint);
begin
  if Assigned(_alGetListener3i) then
    _alGetListener3i(param, value1, value2, value3);
end;

procedure alGetListeneriv(param: ALenum; values: pALint);
begin
  if Assigned(_alGetListeneriv) then
    _alGetListeneriv(param, values);
end;

procedure alGenSources(n: ALsizei; sources: pALuint);
begin
  if Assigned(_alGenSources) then
    _alGenSources(n, sources);
end;

procedure alDeleteSources(n: ALsizei; const sources: pALuint);
begin
  if Assigned(_alDeleteSources) then
    _alDeleteSources(n, sources);
end;

function alIsSource(source: ALuint): ALboolean;
begin
  if Assigned(_alIsSource) then
    Result := _alIsSource(source)
  else
    Result := 0;
end;

procedure alSourcef(source: ALuint; param: ALenum; value: ALfloat);
begin
  if Assigned(_alSourcef) then
    _alSourcef(source, param, value);
end;

procedure alSource3f(source: ALuint; param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat);
begin
  if Assigned(_alSource3f) then
    _alSource3f(source, param, value1, value2, value3);
end;

procedure alSourcefv(source: ALuint; param: ALenum; const values: pALfloat);
begin
  if Assigned(_alSourcefv) then
    _alSourcefv(source, param, values);
end;

procedure alSourcei(source: ALuint; param: ALenum; value: ALint);
begin
  if Assigned(_alSourcei) then
    _alSourcei(source, param, value);
end;

procedure alSource3i(source: ALuint; param: ALenum; value1: ALint; value2: ALint; value3: ALint);
begin
  if Assigned(_alSource3i) then
    _alSource3i(source, param, value1, value2, value3);
end;

procedure alSourceiv(source: ALuint; param: ALenum; const values: pALint);
begin
  if Assigned(_alSourceiv) then
    _alSourceiv(source, param, values);
end;

procedure alGetSourcef(source: ALuint; param: ALenum; value: pALfloat);
begin
  if Assigned(_alGetSourcef) then
    _alGetSourcef(source, param, value);
end;

procedure alGetSource3f(source: ALuint; param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat);
begin
  if Assigned(_alGetSource3f) then
    _alGetSource3f(source, param, value1, value2, value3);
end;

procedure alGetSourcefv(source: ALuint; param: ALenum; values: pALfloat);
begin
  if Assigned(_alGetSourcefv) then
    _alGetSourcefv(source, param, values);
end;

procedure alGetSourcei(source: ALuint; param: ALenum; value: pALint);
begin
  if Assigned(_alGetSourcei) then
    _alGetSourcei(source, param, value);
end;

procedure alGetSource3i(source: ALuint; param: ALenum; value1: pALint; value2: pALint; value3: pALint);
begin
  if Assigned(_alGetSource3i) then
    _alGetSource3i(source, param, value1, value2, value3);
end;

procedure alGetSourceiv(source: ALuint; param: ALenum; values: pALint);
begin
  if Assigned(_alGetSourceiv) then
    _alGetSourceiv(source, param, values);
end;

procedure alSourcePlayv(n: ALsizei; const sources: pALuint);
begin
  if Assigned(_alSourcePlayv) then
    _alSourcePlayv(n, sources);
end;

procedure alSourceStopv(n: ALsizei; const sources: pALuint);
begin
  if Assigned(_alSourceStopv) then
    _alSourceStopv(n, sources);
end;

procedure alSourceRewindv(n: ALsizei; const sources: pALuint);
begin
  if Assigned(_alSourceRewindv) then
    _alSourceRewindv(n, sources);
end;

procedure alSourcePausev(n: ALsizei; const sources: pALuint);
begin
  if Assigned(_alSourcePausev) then
    _alSourcePausev(n, sources);
end;

procedure alSourcePlay(source: ALuint);
begin
  if Assigned(_alSourcePlay) then
    _alSourcePlay(source);
end;

procedure alSourceStop(source: ALuint);
begin
  if Assigned(_alSourceStop) then
    _alSourceStop(source);
end;

procedure alSourceRewind(source: ALuint);
begin
  if Assigned(_alSourceRewind) then
    _alSourceRewind(source);
end;

procedure alSourcePause(source: ALuint);
begin
  if Assigned(_alSourcePause) then
    _alSourcePause(source);
end;

procedure alSourceQueueBuffers(source: ALuint; nb: ALsizei; const buffers: pALuint);
begin
  if Assigned(_alSourceQueueBuffers) then
    _alSourceQueueBuffers(source, nb, buffers);
end;

procedure alSourceUnqueueBuffers(source: ALuint; nb: ALsizei; buffers: pALuint);
begin
  if Assigned(_alSourceUnqueueBuffers) then
    _alSourceUnqueueBuffers(source, nb, buffers);
end;

procedure alGenBuffers(n: ALsizei; buffers: pALuint);
begin
  if Assigned(_alGenBuffers) then
    _alGenBuffers(n, buffers);
end;

procedure alDeleteBuffers(n: ALsizei; const buffers: pALuint);
begin
  if Assigned(_alDeleteBuffers) then
    _alDeleteBuffers(n, buffers);
end;

function alIsBuffer(buffer: ALuint): ALboolean;
begin
  if Assigned(_alIsBuffer) then
    Result := _alIsBuffer(buffer)
  else
    Result := 0;
end;

procedure alBufferData(buffer: ALuint; format: ALenum; const data: pALvoid; size: ALsizei; freq: ALsizei);
begin
  if Assigned(_alBufferData) then
    _alBufferData(buffer, format, data, size, freq);
end;

procedure alBufferf(buffer: ALuint; param: ALenum; value: ALfloat);
begin
  if Assigned(_alBufferf) then
    _alBufferf(buffer, param, value);
end;

procedure alBuffer3f(buffer: ALuint; param: ALenum; value1: ALfloat; value2: ALfloat; value3: ALfloat);
begin
  if Assigned(_alBuffer3f) then
    _alBuffer3f(buffer, param, value1, value2, value3);
end;

procedure alBufferfv(buffer: ALuint; param: ALenum; const values: pALfloat);
begin
  if Assigned(_alBufferfv) then
    _alBufferfv(buffer, param, values);
end;

procedure alBufferi(buffer: ALuint; param: ALenum; value: ALint);
begin
  if Assigned(_alBufferi) then
    _alBufferi(buffer, param, value);
end;

procedure alBuffer3i(buffer: ALuint; param: ALenum; value1: ALint; value2: ALint; value3: ALint);
begin
  if Assigned(_alBuffer3i) then
    _alBuffer3i(buffer, param, value1, value2, value3);
end;

procedure alBufferiv(buffer: ALuint; param: ALenum; const values: pALint);
begin
  if Assigned(_alBufferiv) then
    _alBufferiv(buffer, param, values);
end;

procedure alGetBufferf(buffer: ALuint; param: ALenum; value: pALfloat);
begin
  if Assigned(_alGetBufferf) then
    _alGetBufferf(buffer, param, value);
end;

procedure alGetBuffer3f(buffer: ALuint; param: ALenum; value1: pALfloat; value2: pALfloat; value3: pALfloat);
begin
  if Assigned(_alGetBuffer3f) then
    _alGetBuffer3f(buffer, param, value1, value2, value3);
end;

procedure alGetBufferfv(buffer: ALuint; param: ALenum; values: pALfloat);
begin
  if Assigned(_alGetBufferfv) then
    _alGetBufferfv(buffer, param, values);
end;

procedure alGetBufferi(buffer: ALuint; param: ALenum; value: pALint);
begin
  if Assigned(_alGetBufferi) then
    _alGetBufferi(buffer, param, value);
end;

procedure alGetBuffer3i(buffer: ALuint; param: ALenum; value1: pALint; value2: pALint; value3: pALint);
begin
  if Assigned(_alGetBuffer3i) then
    _alGetBuffer3i(buffer, param, value1, value2, value3);
end;

procedure alGetBufferiv(buffer: ALuint; param: ALenum; values: pALint);
begin
  if Assigned(_alGetBufferiv) then
    _alGetBufferiv(buffer, param, values);
end;

function alcCreateContext(device: pALCdevice; const attrlist: pALCint): pALCcontext;
begin
  if Assigned(_alcCreateContext) then
    Result := _alcCreateContext(device, attrlist)
  else
    Result := nil;
end;

function alcMakeContextCurrent(context: pALCcontext): ALCboolean;
begin
  if Assigned(_alcMakeContextCurrent) then
    Result := _alcMakeContextCurrent(context)
  else
    Result := 0;
end;

procedure alcProcessContext(context: pALCcontext);
begin
  if Assigned(_alcProcessContext) then
    _alcProcessContext(context);
end;

procedure alcSuspendContext(context: pALCcontext);
begin
  if Assigned(_alcSuspendContext) then
    _alcSuspendContext(context);
end;

procedure alcDestroyContext(context: pALCcontext);
begin
  if Assigned(_alcDestroyContext) then
    _alcDestroyContext(context);
end;

function alcGetCurrentContext(): pALCcontext;
begin
  if Assigned(_alcGetCurrentContext) then
    Result := _alcGetCurrentContext()
  else
    Result := nil;
end;

function alcGetContextsDevice(context: pALCcontext): pALCdevice;
begin
  if Assigned(_alcGetContextsDevice) then
    Result := _alcGetContextsDevice(context)
  else
    Result := nil;
end;

function alcOpenDevice(const devicename: pALCchar): pALCdevice;
begin
  if Assigned(_alcOpenDevice) then
    Result := _alcOpenDevice(devicename)
  else
    Result := nil;
end;

function alcCloseDevice(device: pALCdevice): ALCboolean;
begin
  if Assigned(_alcCloseDevice) then
    Result := _alcCloseDevice(device)
  else
    Result := 0;
end;

function alcGetError(device: pALCdevice): ALCenum;
begin
  if Assigned(_alcGetError) then
    Result := _alcGetError(device)
  else
    Result := 0;
end;

function alcIsExtensionPresent(device: pALCdevice; const extname: pALCchar): ALCboolean;
begin
  if Assigned(_alcIsExtensionPresent) then
    Result := _alcIsExtensionPresent(device, extname)
  else
    Result := 0;
end;

function alcGetProcAddress(device: pALCdevice; const funcname: pALCchar): pALCvoid;
begin
  if Assigned(_alcGetProcAddress) then
    Result := _alcGetProcAddress(device, funcname)
  else
    Result := nil;
end;

function alcGetEnumValue(device: pALCdevice; const enumname: pALCchar): ALCenum;
begin
  if Assigned(_alcGetEnumValue) then
    Result := _alcGetEnumValue(device, enumname)
  else
    Result := 0;
end;

function alcGetString(device: pALCdevice; param: ALCenum): pALCchar;
begin
  if Assigned(_alcGetString) then
    Result := _alcGetString(device, param)
  else
    Result := nil;
end;

procedure alcGetIntegerv(device: pALCdevice; param: ALCenum; size: ALCsizei; values: pALCint);
begin
  if Assigned(_alcGetIntegerv) then
    _alcGetIntegerv(device, param, size, values);
end;

function alcCaptureOpenDevice(const devicename: pALCchar; frequency: ALCuint; format: ALCenum; buffersize: ALCsizei): pALCdevice;
begin
  if Assigned(_alcCaptureOpenDevice) then
    Result := _alcCaptureOpenDevice(devicename, frequency, format, buffersize)
  else
    Result := nil;
end;

function alcCaptureCloseDevice(device: pALCdevice): ALCboolean;
begin
  if Assigned(_alcCaptureCloseDevice) then
    Result := _alcCaptureCloseDevice(device)
  else
    Result := 0;
end;

procedure alcCaptureStart(device: pALCdevice);
begin
  if Assigned(_alcCaptureStart) then
    _alcCaptureStart(device);
end;

procedure alcCaptureStop(device: pALCdevice);
begin
  if Assigned(_alcCaptureStop) then
    _alcCaptureStop(device);
end;

procedure alcCaptureSamples(device: pALCdevice; buffer: pALCvoid; samples: ALCsizei);
begin
  if Assigned(_alcCaptureSamples) then
    _alcCaptureSamples(device, buffer, samples);
end;

end.
