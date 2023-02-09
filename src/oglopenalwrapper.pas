{
 OGLOpenALWrapper:
   Wrapper for OpenAL-soft library

   Copyright (c) 2023 by Ilya Medvedkov

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit OGLOpenALWrapper;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, libOpenALsoft_dyn;

type

  TOALVector = packed record
    X, Y, Z : Single;
  end;

  TOALVectorPair = packed record
    At, Up : TOALVector;
  end;

  POALVector = ^TOALVector;

  POALVectorPair = ^TOALVectorPair;

  TOALSourceState = (oalsInvalid, oalsInitial, oalsPlaying, oalsPaused, oalsStopped);
  TOALSourceType = (oalstUndeterimated, oalstStatic, oalstStreaming);
  TOALOffsetType = (oalotSecond, oalotSample, oalotByte);
  TOALFormat = (oalfUnknown, oalfMono8, oalfMono16, oalfStereo8, oalfStereo16);

  { IOALVecObject }

  IOALVecObject = interface(IUnknown)
    ['{7523DD47-4E02-41EE-AD42-58960F8966DE}']

    //OpenAL direct interfaces
    procedure Setf(param: Integer;  value: Single);
    procedure Set3f(param: Integer; value1, value2, value3: Single);
    procedure Setfv(param: Integer; const values: pSingle);
    procedure Seti(param: Integer;  value: Integer);
    procedure Set3i(param: Integer; value1, value2, value3: Integer);
    procedure Setiv(param: Integer; const values: pInteger);
    procedure Getf(param: Integer;  var value: Single);
    procedure Get3f(param: Integer; var value1, value2, value3: Single);
    procedure Getfv(param: Integer; values: pSingle);
    procedure Geti(param: Integer;  var value: Integer);
    procedure Get3i(param: Integer; var value1, value2, value3: Integer);
    procedure Getiv(param: Integer; values: pInteger);

    //High-level abstraction level
    function GetPosition : TOALVector;
    function GetVelocity : TOALVector;
    function GetGain : Single;

    procedure SetPosition(const aValue : TOALVector);
    procedure SetVelocity(const aValue : TOALVector);
    procedure SetGain(aValue : Single);

    property Position : TOALVector read GetPosition write SetPosition;
    property Velocity : TOALVector read GetVelocity write SetVelocity;
    property Gain : Single read GetGain write SetGain;
  end;

  { IOALListener }

  IOALListener = interface(IOALVecObject)
    ['{9EED1156-7E85-4E5B-B7B9-8CE5975FA195}']

    //High-level abstraction level
    function GetOrientation : TOALVectorPair;

    procedure SetOrientation(const aValue : TOALVectorPair);

    property Orientation : TOALVectorPair read GetOrientation write SetOrientation;
  end;

  { IOALBuffer }

  IOALBuffer = interface(IUnknown)
    ['{F4E3EE58-5714-4D33-BA42-2CDDF0A93E64}']
    function Ref : ALuint;

    function Valid : Boolean;
    procedure Done;

    procedure Data(format: TOALFormat;
                           const data: Pointer; size: Integer; freq: Integer);

    function GetFrequency : Integer;
    function GetSize : Integer;
    function GetBits : Integer;
    function GetChannels : Integer;
  end;

  { IOALBuffers }

  IOALBuffers = interface(IUnknown)
    ['{3D67DCA6-1CD9-4DFB-B6B1-A86683E27FBF}']
    function Ref : pALuint;

    function Valid : Boolean;
    procedure Done;

    function Count : Integer;
    function GetBuffer(index : integer) : IOALBuffer;

    function GetSubBuffers(from, cnt : integer) : IOALBuffers;
  end;

  { IOALSource }

  IOALSource = interface(IOALVecObject)
    ['{1177E73A-7EC3-4288-84C6-15F471E1FF90}']
    function Ref : ALuint;

    function Valid : Boolean;
    procedure Done;

    procedure Play;
    procedure Stop;
    procedure Rewind;
    procedure Pause;

    procedure SetBuffer(buffer: IOALBuffer);
    procedure QueueBuffer(buffer: IOALBuffer);
    procedure QueueBuffers(buffers: IOALBuffers);
    function  UnqueueBuffer : IOALBuffer;

    //High-level abstraction level
    function GetDirection : TOALVector;
    function GetInnerAngle : Single;
    function GetOuterAngle : Single;
    function GetOuterGain : Single;
    function GetRelative : Boolean;
    function GetSourceType : TOALSourceType;
    function GetState : TOALSourceState;
    function GetLooping  : Boolean;
    function GetBuffersQueued : Integer;
    function GetBuffersProcessed : Integer;
    function GetMinGain : Single;
    function GetMaxGain : Single;
    function GetReferenceDistance : Single;
    function GetRolloffFactor : Single;
    function GetMaxDistance : Single;
    function GetPitch : Single;
    function GetOffsetFloat(offtype : TOALOffsetType) : Single;
    function GetOffsetInt(offtype : TOALOffsetType) : Integer;

    procedure SetDirection(const aValue : TOALVector);
    procedure SetInnerAngle(aValue : Single);
    procedure SetOuterAngle(aValue : Single);
    procedure SetOuterGain(aValue : Single);
    procedure SetRelative(aValue : Boolean);
    procedure SetLooping(aValue : Boolean);
    procedure SetMinGain(aValue : Single);
    procedure SetMaxGain(aValue : Single);
    procedure SetReferenceDistance(aValue : Single);
    procedure SetRolloffFactor(aValue : Single);
    procedure SetMaxDistance(aValue : Single);
    procedure SetPitch(aValue : Single);
    procedure SetOffset(offtype : TOALOffsetType; aValue : Single);

    property Direction : TOALVector read GetDirection write SetDirection;
    property InnerAngle : Single read GetInnerAngle write SetInnerAngle;
    property OuterAngle : Single read GetOuterAngle write SetOuterAngle;
    property OuterGain : Single read GetOuterGain write SetOuterGain;
    property Relative : Boolean read GetRelative write SetRelative;
    property SourceType : TOALSourceType read GetSourceType;
    property State : TOALSourceState read GetState;
    property Looping  : Boolean read GetLooping write SetLooping;
    property BuffersQueued : Integer read GetBuffersQueued;
    property BuffersProcessed : Integer read GetBuffersProcessed;
    property MinGain : Single read GetMinGain write SetMinGain;
    property MaxGain : Single read GetMaxGain write SetMaxGain;
    property ReferenceDistance : Single read GetReferenceDistance write SetReferenceDistance;
    property RolloffFactor : Single read GetRolloffFactor write SetRolloffFactor;
    property MaxDistance : Single read GetMaxDistance write SetMaxDistance;
    property Pitch : Single read GetPitch write SetPitch;
  end;

  IOALSources = interface(IUnknown)
    ['{FB7907C6-55A4-40FB-A027-04B6A7AA428E}']
    function Ref : pALuint;

    function Valid : Boolean;
    procedure Done;

    procedure Play;
    procedure Stop;
    procedure Rewind;
    procedure Pause;

    function Count : Integer;
    function GetSource(index : Integer) : IOALSource;

    function GetSubSources(from, cnt : Integer) : IOALSources;
  end;

  IOALDevice = interface(IUnknown)
    ['{4D3A178C-D999-4E28-AADF-5DF8F278F089}']
    function Ref : pALCdevice;

    function Valid : Boolean;
    function Close : Boolean;

    function GetError: Integer;
    procedure RaiseError;

    function IsExtensionPresent(const extname: String): Boolean;
    function GetProcAddress(const funcname: String): Pointer;
    function GetEnumValue(const enumname: String): Integer;
    function GetString(param: Integer): String;
    procedure GetIntegerv(param: Integer; size: Integer; values: pInteger);
  end;

  IOALCaptureDevice = interface(IOALDevice)
    ['{1594676E-A308-4680-9746-C8A7DA6A292B}']
    procedure Start;
    procedure Stop;
    function AvalibleSamples : Integer;
    procedure Samples(buffer: pointer; samples: Integer);
  end;

  IOALContext = interface(IUnknown)
    ['{3D2B48C8-D20A-428D-A95D-0A3A88B6A30E}']
    function Ref : pALCcontext;

    function Valid : Boolean;
    procedure Done;

    function GenSources(count : integer) : IOALSources;
    function GenSource : IOALSource;
    function Listener : IOALListener;

    function GetError: Integer;
    procedure RaiseError;
    procedure ClearErrors;

    function GetOutputDevice : IOALDevice;

    function  MakeCurrent : Boolean;
    function  IsCurrent : Boolean;

    procedure Process;
    procedure Suspend;
  end;

  { TOALListener }

  TOALListener = class(TInterfacedObject, IOALListener)
  public
    //OpenAL direct interfaces
    procedure Setf(param: Integer;  value: Single);
    procedure Set3f(param: Integer; value1, value2, value3: Single);
    procedure Setfv(param: Integer; const values: pSingle);
    procedure Seti(param: Integer;  value: Integer);
    procedure Set3i(param: Integer; value1, value2, value3: Integer);
    procedure Setiv(param: Integer; const values: pInteger);
    procedure Getf(param: Integer;  var value: Single);
    procedure Get3f(param: Integer; var value1, value2, value3: Single);
    procedure Getfv(param: Integer; values: pSingle);
    procedure Geti(param: Integer;  var value: Integer);
    procedure Get3i(param: Integer; var value1, value2, value3: Integer);
    procedure Getiv(param: Integer; values: pInteger);

    //High-level abstraction level
    function GetPosition : TOALVector;
    function GetVelocity : TOALVector;
    function GetOrientation : TOALVectorPair;
    function GetGain : Single;

    procedure SetPosition(const aValue : TOALVector);
    procedure SetVelocity(const aValue : TOALVector);
    procedure SetOrientation(const aValue : TOALVectorPair);
    procedure SetGain(aValue : Single);
  end;

  { TOALRefSource }

  TOALRefSource = class(TInterfacedObject, IOALSource)
  private
    FRef : ALuint;
  public
    constructor Create(aRef : ALuint);

    function Ref : ALuint;

    function Valid : Boolean;
    procedure Done;

    procedure Play;
    procedure Stop;
    procedure Rewind;
    procedure Pause;

    procedure SetBuffer(buffer: IOALBuffer);
    procedure QueueBuffer(buffer: IOALBuffer);
    procedure QueueBuffers(buffers: IOALBuffers);
    function  UnqueueBuffer : IOALBuffer;

    //OpenAL direct interfaces
    procedure Setf(param: Integer;  value: Single);
    procedure Set3f(param: Integer; value1, value2, value3: Single);
    procedure Setfv(param: Integer; const values: pSingle);
    procedure Seti(param: Integer;  value: Integer);
    procedure Set3i(param: Integer; value1, value2, value3: Integer);
    procedure Setiv(param: Integer; const values: pInteger);
    procedure Getf(param: Integer;  var value: Single);
    procedure Get3f(param: Integer; var value1, value2, value3: Single);
    procedure Getfv(param: Integer; values: pSingle);
    procedure Geti(param: Integer;  var value: Integer);
    procedure Get3i(param: Integer; var value1, value2, value3: Integer);
    procedure Getiv(param: Integer; values: pInteger);

    //High-level abstraction level
    function GetPosition : TOALVector;
    function GetVelocity : TOALVector;
    function GetGain : Single;

    procedure SetPosition(const aValue : TOALVector);
    procedure SetVelocity(const aValue : TOALVector);
    procedure SetGain(aValue : Single);

    function GetDirection : TOALVector;
    function GetInnerAngle : Single;
    function GetOuterAngle : Single;
    function GetOuterGain : Single;
    function GetRelative : Boolean;
    function GetSourceType : TOALSourceType;
    function GetState : TOALSourceState;
    function GetLooping  : Boolean;
    function GetBuffersQueued : Integer;
    function GetBuffersProcessed : Integer;
    function GetMinGain : Single;
    function GetMaxGain : Single;
    function GetReferenceDistance : Single;
    function GetRolloffFactor : Single;
    function GetMaxDistance : Single;
    function GetPitch : Single;
    function GetOffsetFloat(offtype : TOALOffsetType) : Single;
    function GetOffsetInt(offtype : TOALOffsetType) : Integer;

    procedure SetDirection(const aValue : TOALVector);
    procedure SetInnerAngle(aValue : Single);
    procedure SetOuterAngle(aValue : Single);
    procedure SetOuterGain(aValue : Single);
    procedure SetRelative(aValue : Boolean);
    procedure SetLooping(aValue : Boolean);
    procedure SetMinGain(aValue : Single);
    procedure SetMaxGain(aValue : Single);
    procedure SetReferenceDistance(aValue : Single);
    procedure SetRolloffFactor(aValue : Single);
    procedure SetMaxDistance(aValue : Single);
    procedure SetPitch(aValue : Single);
    procedure SetOffset(offtype : TOALOffsetType; aValue : Single);
  end;

  { TOALUniqSource }

  TOALUniqSource = class(TOALRefSource)
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

  { TOALRefSources }

  TOALRefSources = class(TInterfacedObject, IOALSources)
  private
    FRef : pALuint;
    FCount : Integer;
  public
    constructor Create(aRef : pALuint; aCount : Integer);

    function Ref : pALuint;

    function Valid : Boolean;
    procedure Done; virtual;

    procedure Play;
    procedure Stop;
    procedure Rewind;
    procedure Pause;

    function Count : Integer;
    function GetSource(index : Integer) : IOALSource;

    function GetSubSources(from, cnt : Integer) : IOALSources;
  end;

  { TOALUniqSources }

  TOALUniqSources = class(TOALRefSources)
  public
    constructor Create(aCount : Integer); overload;
    procedure Done; override;
    destructor Destroy; override;
  end;

  { TOALRefDevice }

  TOALRefDevice = class(TInterfacedObject, IOALDevice)
  private
    FRef : pALCdevice;
  public
    constructor Create(aRef : pALCdevice);

    function Ref : pALCdevice;

    function Valid : Boolean;
    function Close : Boolean;

    function GetError: Integer;
    procedure RaiseError;

    function IsExtensionPresent(const extname: String): Boolean;
    function GetProcAddress(const funcname: String): Pointer;
    function GetEnumValue(const enumname: String): Integer;
    function GetString(param: Integer): String;
    procedure GetIntegerv(param: Integer; size: Integer; values: pInteger);
  end;

  { TOALUniqDevice }

  TOALUniqDevice = class(TOALRefDevice)
  public
    constructor Create; overload;
    constructor Create(const devicename: string); overload;
    destructor Destroy; override;
  end;

  { TOALRefCaptureDevice }

  TOALRefCaptureDevice = class(TOALRefDevice, IOALCaptureDevice)
  public
    function Close : Boolean;

    procedure Start;
    procedure Stop;
    function  AvalibleSamples : Integer;
    procedure Samples(buffer: pointer; samples: Integer);
  end;

  { TOALUniqCaptureDevice }

  TOALUniqCaptureDevice = class(TOALRefCaptureDevice)
  public
    constructor Create(const devicename: string;
                                frequency: Cardinal;
                                format: ALCenum;
                                buffersize: ALCsizei); overload;
    constructor Create(frequency: Cardinal;
                                format: ALCenum;
                                buffersize: ALCsizei); overload;
    destructor Destroy; override;
  end;

  { TOALRefContext }

  TOALRefContext = class(TInterfacedObject, IOALContext)
  private
    FRef : pALCcontext;
  public
    constructor Create(cntx : pALCcontext);

    function Ref : pALCcontext;

    function Valid : Boolean;
    procedure Done;

    function GenSources(count : integer) : IOALSources;
    function GenSource : IOALSource;
    function Listener : IOALListener;

    function GetError: Integer;
    procedure RaiseError;
    procedure ClearErrors;

    function GetOutputDevice : IOALDevice;

    function  MakeCurrent : Boolean;
    function  IsCurrent : Boolean;

    procedure Process;
    procedure Suspend;
  end;

  { TOALUniqContext }

  TOALUniqContext = class(TOALRefContext)
  public
    constructor Create(device : IOALDevice; attrs : pALint); overload;
    destructor Destroy; override;
  end;

  { TOALRefBuffer }

  TOALRefBuffer = class(TInterfacedObject, IOALBuffer)
  private
    FRef : ALuint;
  public
    constructor Create(aRef : ALuint);

    function Ref : ALuint;

    function Valid : Boolean;
    procedure Done;

    procedure Data(format: TOALFormat;
                           const data: Pointer; size: Integer; freq: Integer);

    function GetFrequency : Integer;
    function GetSize : Integer;
    function GetBits : Integer;
    function GetChannels : Integer;
  end;

  { TOALUniqBuffer }

  TOALUniqBuffer = class(TOALRefBuffer)
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

  { TOALRefBuffers }

  TOALRefBuffers = class(TInterfacedObject, IOALBuffers)
  private
    FRef : pALuint;
    FCount : Integer;
  public
    constructor Create(aRef : pALuint; aCount : Integer);

    function Ref : pALuint;

    function Valid : Boolean;
    procedure Done; virtual;

    function Count : Integer;
    function GetBuffer(index : integer) : IOALBuffer;

    function GetSubBuffers(from, cnt : integer) : IOALBuffers;
  end;

  { TOALUniqBuffers }

  TOALUniqBuffers = class(TOALRefBuffers)
  public
    constructor Create(acount : Integer); overload;
    procedure Done; override;
    destructor Destroy; override;
  end;

  { TOALAudioData }

  TOALAudioData = class
  private
    FFormat : TOALFormat;
    FFreq : Cardinal;
  protected
    function GetFormat : TOALFormat; virtual;
    function GetFreq : Cardinal; virtual;
    procedure SetFormat(AValue : TOALFormat); virtual;
    procedure SetFreq(AValue : Cardinal); virtual;
  public
    function  SamplesToBytes(smp : Integer) : Int64; virtual;
    function  BytesToSamples(byt : Int64) : Integer; virtual;
    function  BytesToTime(byt : Int64) : Double; virtual;
    function  TimeToSample(tim : Double) : Integer; virtual;

    property Format : TOALFormat read GetFormat write SetFormat;
    property Frequency : Cardinal read GetFreq write SetFreq;
  end;

  { TOALStreamDataSource }

  TOALStreamDataSource = class(TOALAudioData)
  protected
    procedure AfterApplied; virtual;
  public
    constructor Create; virtual;

    function LoadFromFile(const Fn : String) : Boolean; virtual; abstract;
    function LoadFromStream(Str : TStream) : Boolean; virtual; abstract;

    procedure SeekTime(aTime : Double); virtual;
    procedure SeekSample(aSample : Integer); virtual;
    function  TellSamples : Integer; virtual;
    function  TotalSamples : Integer; virtual;

    function ReadChunk(const Buffer : Pointer;
                         Pos : Int64;
                         Sz  : Integer;
                         isloop : Boolean;
                         var fmt : TOALFormat;
                         var freq : Cardinal) : Integer; virtual; abstract;
  end;

  { IOALStreamingHelper }

  IOALStreamingHelper = interface
  ['{F98AE2ED-3B3F-4310-9197-0A0E2B5C3D32}']
  procedure Init(buffers, buffersize  : Integer);
  procedure Done;
  procedure SetDataSrc(AValue : TOALStreamDataSource);
  procedure SetSource(AValue : IOALSource);
  function  GetDataSrc : TOALStreamDataSource;
  function  GetSource : IOALSource;

  procedure Play;
  procedure PlayLoop;
  procedure Rewind;
  procedure Pause;
  procedure Resume;
  procedure Stop;

  procedure SeekTime(aTime : Double);
  procedure SeekSample(aSample : Integer);
  function  PlayedTime : Double;
  function  PlayedSamples : Integer;
  function  DecodedTime : Double;
  function  DecodedSamples : Integer;
  function  TotalTime : Double;
  function  TotalSamples : Integer;

  procedure Proceed;

  property Source : IOALSource read GetSource write SetSource;
  property DataSource : TOALStreamDataSource read GetDataSrc write SetDataSrc;
  end;

  TOALStreamDataSourceClass = class of TOALStreamDataSource;

  { TOALStreamingHelper }

  TOALStreamingHelper = class(TInterfacedObject, IOALStreamingHelper)
  private
    FBuffers : IOALBuffers;
    FSource  : IOALSource;
    FLooping : Boolean;
    FBuffer  : Pointer;
    FMaxSize : Integer;
    FPos     : Int64;
    FUnqSize : Int64;

    FDatasrc : TOALStreamDataSource;
  protected
    procedure Init(buffers, buffersize  : Integer); virtual;
    procedure Done; virtual;
    procedure SetDataSrc(AValue : TOALStreamDataSource); virtual;
    procedure SetSource(AValue : IOALSource); virtual;
    function  GetDataSrc : TOALStreamDataSource; virtual;
    function  GetSource : IOALSource; virtual;
    function  Stream(buf : IOALBuffer) : Boolean; virtual;
    procedure StartPlaying; virtual;
    procedure StopAndRefillAllBuffers; virtual;
    procedure RefillBuffers; virtual;
  public
    constructor Create(buffers, buffersize  : Integer);
    destructor Destroy; override;

    procedure Play; virtual;
    procedure PlayLoop; virtual;
    procedure Rewind; virtual;
    procedure Pause; virtual;
    procedure Resume; virtual;
    procedure Stop; virtual;

    procedure SeekTime(aTime : Double); virtual;
    procedure SeekSample(aSample : Integer); virtual;
    function  PlayedTime : Double; virtual;
    function  PlayedSamples : Integer; virtual;
    function  DecodedTime : Double; virtual;
    function  DecodedSamples : Integer; virtual;
    function  TotalTime : Double; virtual;
    function  TotalSamples : Integer; virtual;

    procedure Proceed; virtual;
  end;

  { TOALPlayer }

  TOALPlayer = class
  private
    FStatus  : TOALSourceState;
    FStrHelper : IOALStreamingHelper;
    FDevice  : IOALDevice;
    FContext : IOALContext;

    FSourceClass : TOALStreamDataSourceClass;

    function GetGain : Single;
    function GetStatus : TOALSourceState;
    procedure DoInit(const devicename : String;
                           buffers, buffersize  : Integer);
    procedure Done;
    procedure SetGain(AValue : Single);
  protected
    procedure InitStreamingHelper(buffers, buffersize : Integer); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Init; overload;
    procedure Init(const devicename : String); overload;
    procedure Init(const devicename : String;
                           buffers, buffersize  : Integer); overload;

    function LoadFromFile(const Fn : String) : Boolean; virtual;
    function LoadFromStream(Str : TStream) : Boolean; virtual;

    procedure Play;
    procedure PlayLoop;
    procedure Rewind;
    procedure Pause;
    procedure Resume;
    procedure Stop;

    procedure SeekTime(aTime : Double);
    procedure SeekSample(aSample : Integer);
    function  PlayedTime : Double;
    function  PlayedSamples : Integer;
    function  DecodedTime : Double;
    function  DecodedSamples : Integer;

    class function DefaultBufferCount : Integer; virtual;
    class function DefaultMaxBufferSize : Integer; virtual;

    property Stream : IOALStreamingHelper read FStrHelper;
    property DataSourceClass : TOALStreamDataSourceClass read FSourceClass write FSourceClass;
    property Status : TOALSourceState read GetStatus;

    property Gain : Single read GetGain write SetGain;
  end;

  { TOALStreamDataRecorder }

  TOALStreamDataRecorder = class(TOALAudioData)
  public
    constructor Create(aFormat : TOALFormat; aFreq : Cardinal); virtual;

    function SaveToFile(const Fn : String) : Boolean; virtual; abstract;
    function SaveToStream(Str : TStream) : Boolean; virtual; abstract;

    procedure StopRecording; virtual; abstract;

    function WriteSamples(const Buffer : Pointer;
                          Count : Integer) : Integer; virtual; abstract;
  end;

  TOALStreamDataRecorderClass = class of TOALStreamDataRecorder;

  TOALCaptureState = (oalcsInvalid, oalcsWaiting, oalcsCapturing);

  { TOALCapture }

  TOALCapture = class
  private
    FStatus  : TOALCaptureState;
    FRecorder : TOALStreamDataRecorder;
    FDevice  : IOALCaptureDevice;
    FBuffer     : Pointer;
    FBufferSize, FBufferSamples : Integer;

    FRecordClass : TOALStreamDataRecorderClass;

    function GetStatus : TOALCaptureState;
    procedure DoInit(const devicename : String;
                           format : TOALFormat;
                           freq   : Cardinal;
                           buffersize  : Integer);
    procedure Done;
    procedure FlushSamples(smp : Integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Init; overload;
    procedure Init(const devicename : String); overload;
    procedure Init(const devicename : String;
                         format : TOALFormat;
                         freq   : Cardinal;
                         buffersize  : Integer); overload;

    function SaveToFile(const Fn : String) : Boolean; virtual;
    function SaveToStream(Str : TStream) : Boolean; virtual;

    procedure Start;
    procedure Proceed;
    procedure Pause;
    procedure Stop;

    class function DefaultFormat : TOALFormat; virtual;
    class function DefaultFrequency : Cardinal; virtual;
    class function DefaultMaxBufferSize : Integer; virtual;

    property Recorder : TOALStreamDataRecorder read FRecorder;
    property DataRecClass : TOALStreamDataRecorderClass read FRecordClass write FRecordClass;
    property Status : TOALCaptureState read GetStatus;
  end;

  { TOpenAL }

  TOpenAL = class
  private
    class function NullNullStrToStringList(s : PChar) : TStringList;
  public
    class function ListOfAllOutputDevices : TStringList;
    class function ListOfAllCapureDevices : TStringList;

    class function CreateContext(device : IOALDevice) : IOALContext;
    class function GenBuffers(count : integer) : IOALBuffers;
    class function GenBuffer : IOALBuffer;
    class function OpenOutputDevice(const devicename: string) : IOALDevice;
    class function OpenDefaultOutputDevice : IOALDevice;
    class function OpenCaptureDevice(const devicename: string;
                                frequency: Cardinal;
                                format: TOALFormat;
                                buffersize: Integer) : IOALCaptureDevice;
    class function OpenDefaultCaptureDevice(frequency: Cardinal;
                                format: TOALFormat;
                                buffersize: Integer) : IOALCaptureDevice;

    class function OALFormat(channels, bitspersample : Integer) : TOALFormat;
    class function OALFormatToSampleSize(fmt : TOALFormat) : Integer;
    class function OALFormatToALenum(fmt : TOALFormat) : ALenum;

    class function Vector(X, Y, Z : Single) : TOALVector;
    class function ZeroVector : TOALVector;
    class function VectorPair(aX, aY, aZ,
                              uX, uY, uZ : Single) : TOALVectorPair;

    class function GetCurrentContext : IOALContext;

    class function OALLibsLoad(const aOALLibs : Array of String) : Boolean;
    class function OALLibsLoadDefault : Boolean;
    class function IsOALLibsLoaded : Boolean;
    class function OALLibsUnLoad : Boolean;
  end;

  { EOpenAL }

  EOpenAL = class(Exception)
  public
    constructor Create(err : ALenum);
  end;

  { EOpenALC }

  EOpenALC = class(Exception)
  public
    constructor Create(err : ALenum);
  end;

  EOALPlayer = class(Exception);

implementation

const
  sALDefaultError = 'OpenAL error %d rised';
  sALCDefaultError = 'OpenALC error %d rised';

  cWrongDevice = 'Wrong device name %s';
  cWrongContext = 'Cant create context';
  cWrongMakeContext = 'Cant make context current';
  cWrongSource = 'Cant generate source';
  cWrongBuffers = 'Cant generate buffers';

  cZeroVector : TOALVector = (X:0; Y:0; Z:0);

{ TOALCapture }

function TOALCapture.GetStatus : TOALCaptureState;
begin
  Result := FStatus;
end;

procedure TOALCapture.DoInit(const devicename : String; format : TOALFormat;
  freq : Cardinal; buffersize : Integer);
begin
  FStatus := oalcsInvalid;
  if length(devicename) = 0 then
      FDevice := TOpenAL.OpenDefaultCaptureDevice(freq, format, buffersize) else
      FDevice := TOpenAL.OpenCaptureDevice(devicename, freq, format, buffersize);
  if FDevice.Valid then
  begin
    FBufferSamples := buffersize;

    if Assigned(FRecordClass) then begin
      FRecorder := FRecordClass.Create(format, freq);
      FBufferSize := FRecorder.SamplesToBytes(buffersize);
      FBuffer := GetMem(FBufferSize);
    end;

    if Assigned(FRecordClass) then
      FStatus := oalcsWaiting;
  end else
    raise EOALPlayer.CreateFmt(cWrongDevice, [devicename]);
end;

procedure TOALCapture.Done;
begin
  FDevice := nil;
  if Assigned(FRecorder) then
  begin
    if FStatus = oalcsCapturing then
      FRecorder.StopRecording;
    FreeAndNil(FRecorder);
  end;
  if Assigned(FBuffer) then
    FreeMemAndNil(FBuffer);
  FStatus := oalcsInvalid;
end;

procedure TOALCapture.FlushSamples(smp : Integer);
begin
  if smp > FBufferSamples then smp := FBufferSamples;
  FDevice.Samples(FBuffer, smp);
  if Assigned(FRecorder) then
     FRecorder.WriteSamples(FBuffer, smp);
end;

constructor TOALCapture.Create;
begin
  inherited Create;
  FStatus := oalcsInvalid;
end;

destructor TOALCapture.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TOALCapture.Init;
begin
  Done;
  DoInit('', DefaultFormat, DefaultFrequency, DefaultMaxBufferSize);
end;

procedure TOALCapture.Init(const devicename : String);
begin
  Done;
  DoInit(devicename, DefaultFormat, DefaultFrequency, DefaultMaxBufferSize);
end;

procedure TOALCapture.Init(const devicename : String; format : TOALFormat;
  freq : Cardinal; buffersize : Integer);
begin
  Done;
  DoInit(devicename, format, freq, buffersize);
end;

function TOALCapture.SaveToFile(const Fn : String) : Boolean;
begin
  if Assigned(FRecorder) then
  begin
    Result := FRecorder.SaveToFile(Fn);
  end else
    Result := false;
end;

function TOALCapture.SaveToStream(Str : TStream) : Boolean;
begin
  if Assigned(FRecorder) then
  begin
    Result := FRecorder.SaveToStream(Str);
  end else
    Result := false;
end;

procedure TOALCapture.Start;
begin
  if Assigned(FDevice) and (FStatus = oalcsWaiting) then
  begin
    FDevice.Start;
    FStatus := oalcsCapturing;
  end;
end;

procedure TOALCapture.Proceed;
var smp : Integer;
begin
  if Assigned(FDevice) and (FStatus = oalcsCapturing) then
  begin
    smp := FDevice.AvalibleSamples;
    if smp > (FBufferSamples div 2) then
      FlushSamples(smp);
  end;
end;

procedure TOALCapture.Pause;
begin
  if Assigned(FDevice) and (FStatus = oalcsCapturing) then
  begin
    FDevice.Stop;
    FStatus := oalcsWaiting;
  end;
end;

procedure TOALCapture.Stop;
var smp : Integer;
begin
  if Assigned(FDevice) and (FStatus = oalcsCapturing) then
  begin
    smp := FDevice.AvalibleSamples;
    if smp > 0 then
      FlushSamples(smp);

    FDevice.Stop;
    Done;
    FStatus := oalcsInvalid;
  end;
end;

class function TOALCapture.DefaultFormat : TOALFormat;
begin
  Result := oalfMono16;
end;

class function TOALCapture.DefaultFrequency : Cardinal;
begin
  Result := 48000;
end;

class function TOALCapture.DefaultMaxBufferSize : Integer;
begin
  Result := DefaultFrequency * 8;
end;

{ TOALStreamDataRecorder }

constructor TOALStreamDataRecorder.Create(aFormat : TOALFormat; aFreq : Cardinal
  );
begin
  FFormat := aFormat;
  FFreq := aFreq;
end;

{ TOALAudioData }

function TOALAudioData.GetFormat : TOALFormat;
begin
  Result := FFormat;
end;

function TOALAudioData.GetFreq : Cardinal;
begin
  Result := FFreq;
end;

procedure TOALAudioData.SetFormat(AValue : TOALFormat);
begin
  FFormat := AValue;
end;

procedure TOALAudioData.SetFreq(AValue : Cardinal);
begin
  FFreq := AValue;
end;

function TOALAudioData.SamplesToBytes(smp : Integer) : Int64;
begin
  case fformat of
    oalfStereo8, oalfMono16 : Result :=  Int64(smp) shl 1;
    oalfStereo16 : Result :=  Int64(smp) shl 2;
  else
    Result := Int64(smp);
  end;
end;

function TOALAudioData.BytesToSamples(byt : Int64) : Integer;
begin
  case fformat of
    oalfStereo8, oalfMono16 : Result :=  byt shr 1;
    oalfStereo16 : Result :=  byt shr 2;
  else
    Result := byt;
  end;
end;

function TOALAudioData.BytesToTime(byt : Int64) : Double;
begin
  Result := Double(BytesToSamples(byt)) / Double(Frequency);
end;

function TOALAudioData.TimeToSample(tim : Double) : Integer;
begin
  Result := Round(tim * Frequency);
end;

{ TOALStreamDataSource }

procedure TOALStreamDataSource.AfterApplied;
begin
  //do nothing
end;

constructor TOALStreamDataSource.Create;
begin
  FFormat := oalfUnknown;
  FFreq := 1; //to avoid divizion by zero
end;

procedure TOALStreamDataSource.SeekTime(aTime : Double);
begin
  SeekSample(TimeToSample(aTime));
end;

procedure TOALStreamDataSource.SeekSample(aSample : Integer);
begin
  //do nothing
end;

function TOALStreamDataSource.TellSamples : Integer;
begin
  Result := 0;
end;

function TOALStreamDataSource.TotalSamples : Integer;
begin
  Result := 0;
end;

{ TOALStreamingHelper }

procedure TOALStreamingHelper.Init(buffers, buffersize : Integer);
begin
  FSource := TOpenAL.GetCurrentContext.GenSource;
  FBuffers := TOpenAL.GenBuffers(buffers);

  FBuffer := GetMem(buffersize);
  FMaxSize := buffersize;
  FPos := 0;
  FUnqSize := 0;

  if FSource.Valid then
  begin
    FSource.Pitch := 1.0;
    FSource.Gain := 1.0;
    FSource.Position := TOpenAL.ZeroVector;
    FSource.Velocity := TOpenAL.ZeroVector;
    FSource.Looping := false;
  end;
end;

procedure TOALStreamingHelper.Done;
begin
  if Assigned(FBuffer) then
    FreeMemAndNil(FBuffer);
  if Assigned(FSource) then
    FSource := nil;
  if Assigned(FBuffers) then
    FBuffers := nil;
  if Assigned(FDatasrc) then
    FreeAndNil(FDatasrc);
end;

procedure TOALStreamingHelper.SetDataSrc(AValue : TOALStreamDataSource);
begin
  if FDatasrc = AValue then Exit;

  if Assigned(FDatasrc) then FreeAndNil(FDatasrc);

  FDatasrc := AValue;
  FUnqSize := 0;
  FPos := 0;
  if Assigned(FDatasrc) then
    FDatasrc.AfterApplied;
end;

procedure TOALStreamingHelper.SetSource(AValue : IOALSource);
begin
  if FSource = AValue then Exit;
  FSource := AValue;
end;

function TOALStreamingHelper.GetDataSrc : TOALStreamDataSource;
begin
  Result := FDatasrc;
end;

function TOALStreamingHelper.GetSource : IOALSource;
begin
  Result := FSource;
end;

function TOALStreamingHelper.Stream(buf : IOALBuffer) : Boolean;
var sz : Integer;
begin
  if Assigned(FDatasrc) then
  begin
    sz := FDatasrc.ReadChunk(FBuffer, FPos, FMaxSize, FLooping, FDatasrc.FFormat, FDatasrc.FFreq);
    if sz > 0 then
    begin
      buf.Data(FDatasrc.Format, FBuffer, sz, FDatasrc.Frequency);
      Inc(FPos, Int64(sz));
      Result := True;
    end else
      Result := False;
  end else
    Result := False;
end;

procedure TOALStreamingHelper.StartPlaying;
begin
  if FSource.BuffersQueued = 0 then
  begin
    FPos := 0;
    RefillBuffers;
  end;
  if FSource.BuffersQueued > 0 then
    FSource.Play;
end;

procedure TOALStreamingHelper.StopAndRefillAllBuffers;
var
  Processed : Integer;
begin
  FSource.Stop;
  Processed := FSource.BuffersProcessed;
  While Processed > 0 do begin
    FSource.UnqueueBuffer;
    Dec(Processed);
  end;
  RefillBuffers;
end;

procedure TOALStreamingHelper.RefillBuffers;
var i, c : integer;
begin
  c := 0;
  for i := 0 to FBuffers.Count-1 do
  begin
    if Stream(FBuffers.GetBuffer(i)) then
      Inc(c)
    else
      Break;
  end;
  if c > 0 then
  begin
    if c < FBuffers.Count then
      FSource.QueueBuffers(FBuffers.GetSubBuffers(0, c)) else
      FSource.QueueBuffers(FBuffers);
  end;
end;

constructor TOALStreamingHelper.Create(buffers, buffersize : Integer);
begin
  inherited Create;
  FDatasrc := nil;
  Init(buffers, buffersize);
end;

destructor TOALStreamingHelper.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TOALStreamingHelper.Play;
begin
  FLooping := false;
  //strange behavior
  //FSource.Looping := false;
  StartPlaying;
end;

procedure TOALStreamingHelper.PlayLoop;
begin
  FLooping := true;
  //strange behavior
  //FSource.Looping := true;
  StartPlaying;
end;

procedure TOALStreamingHelper.Rewind;
begin
  FSource.Rewind;
end;

procedure TOALStreamingHelper.Pause;
begin
  FSource.Pause;
end;

procedure TOALStreamingHelper.Resume;
begin
  FSource.Play;
end;

procedure TOALStreamingHelper.Stop;
begin
  FSource.Stop;
  FSource.SetBuffer(nil);
end;

procedure TOALStreamingHelper.SeekTime(aTime : Double);
var
  aState : TOALSourceState;
begin
  if Assigned(FDatasrc) then
  begin
    aState := FSource.State;
    FDatasrc.SeekTime(aTime);
    FUnqSize := FDatasrc.SamplesToBytes(FDatasrc.TellSamples);
    FPos := FUnqSize;

    if aState = oalsPlaying then
    begin
      StopAndRefillAllBuffers;
      FSource.Play;
    end else
    if aState = oalsPaused then
    begin
      StopAndRefillAllBuffers;
      FSource.Play;
      FSource.Pause;
    end;
  end;
end;

procedure TOALStreamingHelper.SeekSample(aSample : Integer);
var
  aState : TOALSourceState;
begin
  if Assigned(FDatasrc) then
  begin
    aState := FSource.State;
    FDatasrc.SeekSample(aSample);
    FUnqSize := FDatasrc.SamplesToBytes(FDatasrc.TellSamples);
    FPos := FUnqSize;

    if aState = oalsPlaying then
    begin
      StopAndRefillAllBuffers;
      FSource.Play;
    end else
    if aState = oalsPaused then
    begin
      StopAndRefillAllBuffers;
      FSource.Play;
      FSource.Pause;
    end;
  end;
end;

function TOALStreamingHelper.PlayedTime : Double;
begin
  if Assigned(FDatasrc) then
  begin
    Result := FSource.GetOffsetFloat(oalotSecond) + FDatasrc.BytesToTime(FUnqSize);
  end else
    Result := 0;
end;

function TOALStreamingHelper.PlayedSamples : Integer;
begin
  if Assigned(FDatasrc) then
  begin
    Result := FSource.GetOffsetInt(oalotSample) + FDatasrc.BytesToSamples(FUnqSize);
  end else
    Result := 0;
end;

function TOALStreamingHelper.DecodedTime : Double;
begin
  if Assigned(FDatasrc) then
  begin
    Result := FDatasrc.BytesToTime(FPos);
  end else
    Result := 0;
end;

function TOALStreamingHelper.DecodedSamples : Integer;
begin
  if Assigned(FDatasrc) then
  begin
    Result := FDatasrc.BytesToSamples(FPos);
  end else
    Result := 0;
end;

function TOALStreamingHelper.TotalTime : Double;
begin
  if Assigned(FDatasrc) then
  begin
    Result := Double(FDatasrc.TotalSamples) / Double(FDatasrc.Frequency);
  end else
    Result := 0;
end;

function TOALStreamingHelper.TotalSamples : Integer;
begin
  if Assigned(FDatasrc) then
  begin
    Result := FDatasrc.TotalSamples;
  end else
    Result := 0;
end;

procedure TOALStreamingHelper.Proceed;
var
  Processed, i : Integer;
  Buf : IOALBuffer;
begin
  if Assigned(FSource) and FSource.Valid then
  begin
    Processed := FSource.BuffersProcessed;
    if Processed > 0 then repeat
      Buf := FSource.UnqueueBuffer;
      Inc(FUnqSize, Buf.GetSize);
      if Stream(Buf) then
        FSource.QueueBuffer(Buf)
      else
      if FLooping then begin
        //trying to restart datasource and read buffer from start
        FPos := 0;
        if Stream(Buf) then
          FSource.QueueBuffer(Buf);
      end;
      dec(Processed);
    until Processed <= 0;
    if FSource.BuffersQueued > 0 then
    begin
      if FSource.State in [oalsInitial, oalsStopped] then
        FSource.Play;
    end else
      if FLooping then
        FSource.Stop;
  end;
end;

{ TOALPlayer }

constructor TOALPlayer.Create;
begin
  inherited Create;
  FSourceClass := nil;
end;

destructor TOALPlayer.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TOALPlayer.Init;
begin
  Done;
  DoInit('', DefaultBufferCount, DefaultMaxBufferSize);
end;

procedure TOALPlayer.Init(const devicename : String);
begin
  Done;
  DoInit(devicename, DefaultBufferCount, DefaultMaxBufferSize);
end;

procedure TOALPlayer.Init(const devicename : String; buffers,
  buffersize : Integer);
begin
  Done;
  if buffers < 1 then buffers := 1;
  if buffersize < 8192 then buffersize := 8192;
  DoInit(devicename, buffers, buffersize);
end;

function TOALPlayer.LoadFromFile(const Fn : String) : Boolean;
begin
  if Status in [oalsInitial, oalsStopped] then
  begin
    if Assigned(FStrHelper.DataSource) then
       Result := FStrHelper.DataSource.LoadFromFile(Fn) else
       Result := false;
  end else
    Result := false;
end;

function TOALPlayer.LoadFromStream(Str : TStream) : Boolean;
begin
  if Status in [oalsInitial, oalsStopped] then
  begin
    if Assigned(FStrHelper.DataSource) then
       Result := FStrHelper.DataSource.LoadFromStream(Str) else
       Result := false;
  end else
    Result := false;
end;

procedure TOALPlayer.Play;
begin
  if Status in [oalsInitial, oalsPaused, oalsStopped] then
    FStrHelper.Play;
end;

procedure TOALPlayer.PlayLoop;
begin
  if Status in [oalsInitial, oalsPaused, oalsStopped] then
    FStrHelper.PlayLoop;
end;

procedure TOALPlayer.Rewind;
begin
  if Status in [oalsInitial, oalsPaused, oalsStopped] then
    FStrHelper.Rewind;
end;

procedure TOALPlayer.Pause;
begin
  if Status = oalsPlaying then
    FStrHelper.Pause;
end;

procedure TOALPlayer.Resume;
begin
  if Status = oalsPaused then
    FStrHelper.Resume;
end;

procedure TOALPlayer.Stop;
begin
  if Status in [oalsPlaying, oalsPaused] then
    FStrHelper.Stop;
end;

procedure TOALPlayer.SeekTime(aTime : Double);
begin
  FStrHelper.SeekTime(aTime);
end;

procedure TOALPlayer.SeekSample(aSample : Integer);
begin
  FStrHelper.SeekSample(aSample);
end;

function TOALPlayer.PlayedTime : Double;
begin
  Result := FStrHelper.PlayedTime;
end;

function TOALPlayer.PlayedSamples : Integer;
begin
  Result := FStrHelper.PlayedSamples;
end;

function TOALPlayer.DecodedTime : Double;
begin
  Result := FStrHelper.DecodedTime;
end;

function TOALPlayer.DecodedSamples : Integer;
begin
  Result := FStrHelper.DecodedSamples;
end;

procedure TOALPlayer.DoInit(const devicename : String; buffers,
  buffersize : Integer);
var OALListener : IOALListener;
begin
  FStatus := oalsInvalid;
  if length(devicename) = 0 then
      FDevice := TOpenAL.OpenDefaultOutputDevice else
      FDevice := TOpenAL.OpenOutputDevice(devicename);
  if FDevice.Valid then
  begin
    FContext := TOpenAL.CreateContext(FDevice);
    if FContext.Valid then
    begin
      if FContext.MakeCurrent then
      begin
        OALListener := FContext.Listener;
        OALListener.SetPosition(TOpenAL.Vector(0,0,1));
        OALListener.SetVelocity(TOpenAL.ZeroVector);
        OALListener.SetOrientation(TOpenAL.VectorPair(0,0,1,0,1,0));

        InitStreamingHelper(buffers, buffersize);

        FContext.RaiseError;

        FStatus := oalsInitial;
      end else
        raise EOALPlayer.Create(cWrongMakeContext);
    end else
      raise EOALPlayer.Create(cWrongContext);
  end else
    raise EOALPlayer.CreateFmt(cWrongDevice, [devicename]);
end;

function TOALPlayer.GetStatus : TOALSourceState;
begin
  if FStatus = oalsInvalid then
    Result := FStatus else
  begin
    if Assigned(FStrHelper) then
    begin
      FStatus := FStrHelper.Source.State;
      if FStatus = oalsStopped then
        if FStrHelper.Source.BuffersQueued > 0 then
          FStatus := oalsPlaying;
    end else
      FStatus := oalsInvalid;
    Result := FStatus;
  end;
end;

function TOALPlayer.GetGain : Single;
begin
  if Assigned(FStrHelper) then
    Result := FStrHelper.GetSource.GetGain else
    Result := 0;
end;

procedure TOALPlayer.Done;
begin
  if Assigned(FStrHelper) then
    FStrHelper := nil;
  if FStatus <> oalsInvalid then
  begin
    if FContext.Valid then FContext.Done;
    if FDevice.Valid then FDevice.Close;
    FContext := nil;
    FDevice := nil;
  end;
  FStatus := oalsInvalid;
end;

procedure TOALPlayer.SetGain(AValue : Single);
begin
  if Assigned(FStrHelper) then
    FStrHelper.GetSource.SetGain(AValue);
end;

procedure TOALPlayer.InitStreamingHelper(buffers, buffersize : Integer);
begin
  FStrHelper := TOALStreamingHelper.Create(buffers, buffersize) as IOALStreamingHelper;
  if Assigned(FSourceClass) then
    FStrHelper.DataSource := FSourceClass.Create;
end;

class function TOALPlayer.DefaultBufferCount : Integer;
begin
  Result := 2;
end;

class function TOALPlayer.DefaultMaxBufferSize : Integer;
begin
  Result := 81920;
end;

{ EOpenAL }

constructor EOpenAL.Create(err : ALenum);
begin
  inherited CreateFmt(sALDefaultError, [err]);
end;

{ EOpenALC }

constructor EOpenALC.Create(err : ALenum);
begin
  inherited CreateFmt(sALCDefaultError, [err]);
end;

{ TOALRefBuffer }

constructor TOALRefBuffer.Create(aRef : ALuint);
begin
  FRef := aRef;
end;

function TOALRefBuffer.Ref : ALuint;
begin
  Result := FRef;
end;

function TOALRefBuffer.Valid : Boolean;
begin
  Result := FRef <> AL_NONE;
end;

procedure TOALRefBuffer.Done;
begin
  alDeleteBuffers(1, @FRef);
  FRef := AL_NONE;
end;

procedure TOALRefBuffer.Data(format : TOALFormat; const data : Pointer;
  size : Integer; freq : Integer);
var oalfmt : Integer;
begin
  oalfmt := TOpenAL.OALFormatToALenum(format);
  alBufferData(FRef, oalfmt, data, size, freq);
end;

function TOALRefBuffer.GetFrequency : Integer;
begin
  alGetBufferi(FRef, AL_FREQUENCY, @Result);
end;

function TOALRefBuffer.GetSize : Integer;
begin
  alGetBufferi(FRef, AL_SIZE, @Result);
end;

function TOALRefBuffer.GetBits : Integer;
begin
  alGetBufferi(FRef, AL_BITS, @Result);
end;

function TOALRefBuffer.GetChannels : Integer;
begin
  alGetBufferi(FRef, AL_CHANNELS, @Result);
end;

{ TOALUniqBuffers }

constructor TOALUniqBuffers.Create(acount : Integer);
begin
  if aCount > 0 then
  begin
    FRef := GetMem(acount * sizeof(Integer));
    alGenBuffers(acount, FRef);
    FCount := acount;
  end else
  begin
    FRef := nil;
    FCount := 0;
  end;
end;

procedure TOALUniqBuffers.Done;
var r : Pointer;
begin
  if Valid then
  begin
    r := FRef;
    inherited Done;
    Freemem(r);
  end;
end;

destructor TOALUniqBuffers.Destroy;
begin
  if Valid then
    Done;
  inherited Destroy;
end;

{ TOALRefBuffers }

constructor TOALRefBuffers.Create(aRef : pALuint; aCount : Integer);
begin
  FRef := aRef;
  FCount := aCount;
end;

function TOALRefBuffers.Ref : pALuint;
begin
  Result := FRef;
end;

function TOALRefBuffers.Valid : Boolean;
begin
  Result := FRef <> nil;
end;

procedure TOALRefBuffers.Done;
begin
  alDeleteBuffers(FCount, FRef);
  FRef := nil;
  FCount := 0;
end;

function TOALRefBuffers.Count : Integer;
begin
  Result := FCount;
end;

function TOALRefBuffers.GetBuffer(index : integer) : IOALBuffer;
begin
  Result := (TOALRefBuffer.Create(FRef[index]) as IOALBuffer);
end;

function TOALRefBuffers.GetSubBuffers(from, cnt : integer) : IOALBuffers;
begin
  Result := (TOALRefBuffers.Create(@(FRef[from]), cnt) as IOALBuffers);
end;

{ TOALUniqBuffer }

constructor TOALUniqBuffer.Create;
begin
  FRef := AL_NONE;
  alGenBuffers(1, @FRef);
end;

destructor TOALUniqBuffer.Destroy;
begin
  if Valid then Done;
  inherited Destroy;
end;

{ TOALRefCaptureDevice }

function TOALRefCaptureDevice.Close : Boolean;
begin
  Result := alcCaptureCloseDevice(FRef) = ALC_TRUE;
  FRef := nil;
end;

procedure TOALRefCaptureDevice.Start;
begin
  alcCaptureStart(FRef);
end;

procedure TOALRefCaptureDevice.Stop;
begin
  alcCaptureStop(FRef);
end;

function TOALRefCaptureDevice.AvalibleSamples : Integer;
begin
  alcGetIntegerv(FRef, ALC_CAPTURE_SAMPLES, 1, @Result);
end;

procedure TOALRefCaptureDevice.Samples(buffer : pointer; samples : Integer);
begin
  alcCaptureSamples(FRef, buffer, samples);
end;

{ TOALUniqCaptureDevice }

constructor TOALUniqCaptureDevice.Create(const devicename : string;
  frequency : Cardinal; format : ALCenum; buffersize : ALCsizei);
begin
  FRef := alcCaptureOpenDevice(pALCchar(PChar(devicename)), frequency,
                               format, buffersize);
end;

constructor TOALUniqCaptureDevice.Create(frequency : Cardinal;
  format : ALCenum; buffersize : ALCsizei);
begin
  FRef := alcCaptureOpenDevice(nil, frequency, format, buffersize);
end;

destructor TOALUniqCaptureDevice.Destroy;
begin
  if Valid then Close;
  inherited Destroy;
end;

{ TOALRefDevice }

constructor TOALRefDevice.Create(aRef : pALCdevice);
begin
  Fref := aRef;
end;

function TOALRefDevice.Ref : pALCdevice;
begin
  Result := FRef;
end;

function TOALRefDevice.Valid : Boolean;
begin
  Result := FRef <> nil;
end;

function TOALRefDevice.Close : Boolean;
begin
  Result := alcCloseDevice(FRef) = ALC_TRUE;
  FRef := nil;
end;

function TOALRefDevice.GetError : Integer;
begin
  Result := alcGetError(FRef);
end;

procedure TOALRefDevice.RaiseError;
var err : ALCenum;
begin
  err := alcGetError(FRef);
  if err <> ALC_NO_ERROR then
  begin
    raise EOpenALC.Create(err);
  end;
end;

function TOALRefDevice.IsExtensionPresent(const extname : String) : Boolean;
begin
  Result := alcIsExtensionPresent(FRef, pALCchar(pChar(extname))) = ALC_TRUE;
end;

function TOALRefDevice.GetProcAddress(const funcname : String) : Pointer;
begin
  Result := alcGetProcAddress(FRef, pALCchar(pChar(funcname)));
end;

function TOALRefDevice.GetEnumValue(const enumname : String) : Integer;
begin
  Result := alcGetEnumValue(FRef, pALCchar(pChar(enumname)));
end;

function TOALRefDevice.GetString(param : Integer) : String;
begin
  Result := StrPas(PChar(alcGetString(FRef, param)));
end;

procedure TOALRefDevice.GetIntegerv(param : Integer; size : Integer;
  values : pInteger);
begin
  alcGetIntegerv(FRef, param, size, values);
end;

{ TOALUniqDevice }

constructor TOALUniqDevice.Create;
begin
  Fref := alcOpenDevice(nil);
end;

constructor TOALUniqDevice.Create(const devicename : string);
begin
  Fref := alcOpenDevice(pALCchar(PChar(devicename)));
end;

destructor TOALUniqDevice.Destroy;
begin
  if Valid then Close;
  inherited Destroy;
end;

{ TOALListener }

procedure TOALListener.Setf(param : Integer; value : Single);
begin
  alListenerf(param, value);
end;

procedure TOALListener.Set3f(param : Integer; value1, value2, value3 : Single);
begin
  alListener3f(param, value1, value2, value3);
end;

procedure TOALListener.Setfv(param : Integer; const values : pSingle);
begin
  alListenerfv(param, values);
end;

procedure TOALListener.Seti(param : Integer; value : Integer);
begin
  alListeneri(param, value);
end;

procedure TOALListener.Set3i(param : Integer; value1, value2, value3 : Integer);
begin
  alListener3i(param, value1, value2, value3);
end;

procedure TOALListener.Setiv(param : Integer; const values : pInteger);
begin
  alListeneriv(param, values);
end;

procedure TOALListener.Getf(param : Integer; var value : Single);
begin
  alGetListenerf(param, @value);
end;

procedure TOALListener.Get3f(param : Integer; var value1, value2,
  value3 : Single);
begin
  alGetListener3f(param, @value1, @value2, @value3);
end;

procedure TOALListener.Getfv(param : Integer; values : pSingle);
begin
  alGetListenerfv(param, values);
end;

procedure TOALListener.Geti(param : Integer; var value : Integer);
begin
  alGetListeneri(param, @value);
end;

procedure TOALListener.Get3i(param : Integer; var value1, value2,
  value3 : Integer);
begin
  alGetListener3i(param, @value1, @value2, @value3);
end;

procedure TOALListener.Getiv(param : Integer; values : pInteger);
begin
  alGetListeneriv(param, values);
end;

function TOALListener.GetPosition : TOALVector;
begin
  alGetListenerfv(AL_POSITION, @Result);
end;

function TOALListener.GetVelocity : TOALVector;
begin
  alGetListenerfv(AL_VELOCITY, @Result);
end;

function TOALListener.GetOrientation : TOALVectorPair;
begin
  alGetListenerfv(AL_ORIENTATION, @Result);
end;

function TOALListener.GetGain : Single;
begin
  alGetListenerf(AL_GAIN, @Result);
end;

procedure TOALListener.SetPosition(const aValue : TOALVector);
begin
  alListenerfv(AL_POSITION, @aValue);
end;

procedure TOALListener.SetVelocity(const aValue : TOALVector);
begin
  alListenerfv(AL_VELOCITY, @aValue);
end;

procedure TOALListener.SetOrientation(const aValue : TOALVectorPair);
begin
  alListenerfv(AL_ORIENTATION, @aValue);
end;

procedure TOALListener.SetGain(aValue : Single);
begin
  alListenerf(AL_GAIN, aValue);
end;

{ TOALRefContext }

constructor TOALRefContext.Create(cntx : pALCcontext);
begin
  FRef := cntx;
end;

function TOALRefContext.Ref : pALCcontext;
begin
  Result := FRef;
end;

function TOALRefContext.Valid : Boolean;
begin
  Result := FRef <> nil;
end;

procedure TOALRefContext.Done;
begin
  alcDestroyContext(FRef);
  FRef := nil;
end;

function TOALRefContext.GenSources(count : integer) : IOALSources;
begin
  Result := (TOALUniqSources.Create(count) as IOALSources);
end;

function TOALRefContext.GenSource : IOALSource;
begin
  Result := (TOALUniqSource.Create as IOALSource);
end;

function TOALRefContext.Listener : IOALListener;
begin
  Result := (TOALListener.Create as IOALListener);
end;

function TOALRefContext.GetError : Integer;
begin
  Result := alGetError;
end;

procedure TOALRefContext.RaiseError;
var
  err : ALenum;
begin
  err := alGetError;
  if err <> AL_NO_ERROR then
  begin
    raise EOpenAL.Create(err);
  end;
end;

procedure TOALRefContext.ClearErrors;
begin
  while alGetError <> AL_NO_ERROR do ;
end;

function TOALRefContext.GetOutputDevice : IOALDevice;
var dev : pALCdevice;
begin
  dev := alcGetContextsDevice(Fref);
  Result := (TOALRefDevice.Create(dev) as IOALDevice);
end;

function TOALRefContext.MakeCurrent : Boolean;
begin
  Result := alcMakeContextCurrent(FRef) = ALC_TRUE;
end;

function TOALRefContext.IsCurrent : Boolean;
begin
  if Valid then
    Result := alcGetCurrentContext = FRef else
    Result := false;
end;

procedure TOALRefContext.Process;
begin
  alcProcessContext(FRef);
end;

procedure TOALRefContext.Suspend;
begin
  alcSuspendContext(FRef);
end;

{ TOALUniqContext }

constructor TOALUniqContext.Create(device : IOALDevice; attrs : pALint);
begin
  FRef := alcCreateContext(device.Ref, attrs);
end;

destructor TOALUniqContext.Destroy;
begin
  if Valid then Done;
  inherited Destroy;
end;

{ TOALUniqSources }

constructor TOALUniqSources.Create(aCount : Integer);
begin
  if aCount > 0 then
  begin
    FRef := Getmem(aCount * Sizeof(Integer));
    alGenSources(aCount, FRef);
    FCount := aCount;
  end else
  begin
    FCount := 0;
    FRef := nil;
  end;
end;

procedure TOALUniqSources.Done;
var r : Pointer;
begin
  if Valid then
  begin
    r := FRef;
    inherited Done;
    Freemem(r);
  end;
end;

destructor TOALUniqSources.Destroy;
begin
  if Valid then
    Done;

  inherited Destroy;
end;

{ TOALRefSources }

constructor TOALRefSources.Create(aRef : pALuint; aCount : Integer);
begin
  FRef := aRef;
  FCount := aCount;
end;

function TOALRefSources.Ref : pALuint;
begin
  Result := FRef;
end;

function TOALRefSources.Valid : Boolean;
begin
  Result := FRef <> nil;
end;

procedure TOALRefSources.Done;
begin
  alDeleteSources(FCount, FRef);
  FRef := nil;
  FCount := 0;
end;

procedure TOALRefSources.Play;
begin
  alSourcePlayv(FCount, FRef);
end;

procedure TOALRefSources.Stop;
begin
  alSourceStopv(FCount, FRef);
end;

procedure TOALRefSources.Rewind;
begin
  alSourceRewindv(FCount, FRef);
end;

procedure TOALRefSources.Pause;
begin
  alSourcePausev(FCount, FRef);
end;

function TOALRefSources.Count : Integer;
begin
  Result := FCount;
end;

function TOALRefSources.GetSource(index : Integer) : IOALSource;
begin
  Result := (TOALRefSource.Create(FRef[index]) as IOALSource);
end;

function TOALRefSources.GetSubSources(from, cnt : Integer) : IOALSources;
begin
  Result := (TOALRefSources.Create(@(FRef[from]), cnt) as IOALSources);
end;

{ TOALUniqSource }

constructor TOALUniqSource.Create;
begin
  FRef := AL_NONE;
  alGenSources(1, @FRef);
end;

destructor TOALUniqSource.Destroy;
begin
  if Valid then
    Done;
  inherited Destroy;
end;

{ TOpenAL }

class function TOpenAL.NullNullStrToStringList(s : PChar) : TStringList;
var
  d : PChar;
  n : PChar;
  len : Integer;
begin
  if strlen(s) > 0 then
  begin
    Result := TStringList.Create;
    d := s;
    n := s + 1;
    len := 0;
    while (Assigned(d) and (d^ <> #0)) and
          (Assigned(n) and (n^ <> #0)) do
    begin
      Result.Add(StrPas(d));
      len := strlen(d);
      Inc(d, len + 1);
      Inc(n, len + 2);
    end;
  end else
    Result := nil;
end;

class function TOpenAL.ListOfAllOutputDevices : TStringList;
begin
  Result := NullNullStrToStringList(PChar(alcGetString(nil, ALC_DEVICE_SPECIFIER)));
end;

class function TOpenAL.ListOfAllCapureDevices : TStringList;
begin
  Result := NullNullStrToStringList(PChar(alcGetString(nil, ALC_CAPTURE_DEVICE_SPECIFIER)));
end;

class function TOpenAL.CreateContext(device : IOALDevice) : IOALContext;
begin
  Result := (TOALUniqContext.Create(device, nil) as IOALContext);
end;

class function TOpenAL.GenBuffers(count : integer) : IOALBuffers;
begin
  Result := (TOALUniqBuffers.Create(count) as IOALBuffers);
end;

class function TOpenAL.GenBuffer : IOALBuffer;
begin
  Result := (TOALUniqBuffer.Create as IOALBuffer);
end;

class function TOpenAL.OpenOutputDevice(const devicename : string) : IOALDevice;
begin
  Result := (TOALUniqDevice.Create(devicename) as IOALDevice);
end;

class function TOpenAL.OpenDefaultOutputDevice : IOALDevice;
begin
  Result := (TOALUniqDevice.Create() as IOALDevice);
end;

class function TOpenAL.OpenCaptureDevice(const devicename : string;
  frequency : Cardinal; format : TOALFormat; buffersize : Integer
  ) : IOALCaptureDevice;
begin
  Result := (TOALUniqCaptureDevice.Create(devicename,
                                            frequency,
                                            OALFormatToALenum(format),
                                            buffersize) as IOALCaptureDevice);
end;

class function TOpenAL.OpenDefaultCaptureDevice(frequency : Cardinal;
  format : TOALFormat; buffersize : Integer) : IOALCaptureDevice;
begin
  Result := (TOALUniqCaptureDevice.Create(frequency,
                                            OALFormatToALenum(format),
                                            buffersize) as IOALCaptureDevice);
end;

class function TOpenAL.OALFormat(channels, bitspersample : Integer
  ) : TOALFormat;
begin
  if channels = 1 then
  begin
    if bitspersample = 8 then
    begin
      Result := oalfMono8;
    end else
    if bitspersample = 16 then
    begin
      Result := oalfMono16;
    end else
      Result := oalfUnknown;
  end else
  if channels = 2 then
  begin
    if bitspersample = 8 then
    begin
      Result := oalfStereo8;
    end else
    if bitspersample = 16 then
    begin
      Result := oalfStereo16;
    end else
      Result := oalfUnknown;
  end else
    Result := oalfUnknown;
end;

class function TOpenAL.OALFormatToSampleSize(fmt : TOALFormat) : Integer;
begin
  case fmt of
      oalfMono8 : Result := 1;
      oalfMono16 : Result := 2;
      oalfStereo8 : Result := 2;
  else
      Result := 4;
  end;
end;

class function TOpenAL.OALFormatToALenum(fmt : TOALFormat) : ALenum;
begin
  case fmt of
      oalfMono8 : Result := AL_FORMAT_MONO8;
      oalfMono16 : Result := AL_FORMAT_MONO16;
      oalfStereo8 : Result := AL_FORMAT_STEREO8;
  else
      Result := AL_FORMAT_STEREO16;
  end;
end;

class function TOpenAL.Vector(X, Y, Z : Single) : TOALVector;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;

class function TOpenAL.ZeroVector : TOALVector;
begin
  Result := cZeroVector;
end;

class function TOpenAL.VectorPair(aX, aY, aZ, uX, uY, uZ : Single
  ) : TOALVectorPair;
begin
  Result.At := Vector(aX, aY, aZ);
  Result.Up := Vector(uX, uY, uZ);
end;

class function TOpenAL.GetCurrentContext : IOALContext;
var cntx : pALCcontext;
begin
  cntx := alcGetCurrentContext();
  Result := (TOALRefContext.Create(cntx) as IOALContext);
end;

class function TOpenAL.OALLibsLoad(const aOALLibs : array of String) : Boolean;
begin
  Result := InitOpenALsoftInterface(aOALLibs);
end;

class function TOpenAL.OALLibsLoadDefault : Boolean;
begin
  Result := InitOpenALsoftInterface(OpenALsoftDLL);
end;

class function TOpenAL.IsOALLibsLoaded : Boolean;
begin
  Result := IsOpenALsoftloaded;
end;

class function TOpenAL.OALLibsUnLoad : Boolean;
begin
  Result := DestroyOpenALsoftInterface;
end;

{ TOALRefSource }

constructor TOALRefSource.Create(aRef : ALuint);
begin
  FRef := aRef;
end;

function TOALRefSource.Ref : ALuint;
begin
  Result := FRef;
end;

function TOALRefSource.Valid : Boolean;
begin
  Result := FRef <> AL_NONE;
end;

procedure TOALRefSource.Done;
begin
  alDeleteSources(1, @FRef);
  FRef := AL_NONE;
end;

procedure TOALRefSource.Play;
begin
  alSourcePlay(FRef);
end;

procedure TOALRefSource.Stop;
begin
  alSourceStop(FRef);
end;

procedure TOALRefSource.Rewind;
begin
  alSourceRewind(FRef);
end;

procedure TOALRefSource.Pause;
begin
  alSourcePause(FRef);
end;

procedure TOALRefSource.SetBuffer(buffer : IOALBuffer);
begin
  if Assigned(buffer) then
    alSourcei(FRef, AL_BUFFER, buffer.Ref) else
    alSourcei(FRef, AL_BUFFER, AL_NONE);
end;

procedure TOALRefSource.QueueBuffer(buffer : IOALBuffer);
var p : ALUInt;
begin
  p := buffer.Ref;
  alSourceQueueBuffers(FRef, 1, @p);
end;

procedure TOALRefSource.QueueBuffers(buffers : IOALBuffers);
begin
  alSourceQueueBuffers(FRef, buffers.Count, buffers.Ref);
end;

function TOALRefSource.UnqueueBuffer : IOALBuffer;
var aRefs : ALint;
begin
  aRefs := AL_NONE;
  alSourceUnqueueBuffers(FRef, 1, @aRefs);
  Result := (TOALRefBuffer.Create(aRefs) as IOALBuffer);
end;

procedure TOALRefSource.Setf(param : Integer; value : Single);
begin
  alSourcef(FRef, param, value);
end;

procedure TOALRefSource.Set3f(param : Integer; value1, value2, value3 : Single);
begin
  alSource3f(FRef, param, value1, value2, value3);
end;

procedure TOALRefSource.Setfv(param : Integer; const values : pSingle);
begin
  alSourcefv(FRef, param, values);
end;

procedure TOALRefSource.Seti(param : Integer; value : Integer);
begin
  alSourcei(FRef, param, value);
end;

procedure TOALRefSource.Set3i(param : Integer; value1, value2, value3 : Integer
  );
begin
  alSource3i(FRef, param, value1, value2, value3);
end;

procedure TOALRefSource.Setiv(param : Integer; const values : pInteger);
begin
  alSourceiv(FRef, param, values);
end;

procedure TOALRefSource.Getf(param : Integer; var value : Single);
begin
  alGetSourcef(FRef, param, @value);
end;

procedure TOALRefSource.Get3f(param : Integer; var value1, value2,
  value3 : Single);
begin
  alGetSource3f(FRef, param, @value1, @value2, @value3);
end;

procedure TOALRefSource.Getfv(param : Integer; values : pSingle);
begin
  alGetSourcefv(FRef, param, values);
end;

procedure TOALRefSource.Geti(param : Integer; var value : Integer);
begin
  alGetSourcefv(FRef, param, @value);
end;

procedure TOALRefSource.Get3i(param : Integer; var value1, value2,
  value3 : Integer);
begin
  alGetSource3i(FRef, param, @value1, @value2, @value3);
end;

procedure TOALRefSource.Getiv(param : Integer; values : pInteger);
begin
  alGetSourceiv(FRef, param, values);
end;

function TOALRefSource.GetPosition : TOALVector;
begin
  alGetSourcefv(FRef, AL_POSITION, @Result);
end;

function TOALRefSource.GetVelocity : TOALVector;
begin
  alGetSourcefv(FRef, AL_VELOCITY, @Result);
end;

function TOALRefSource.GetGain : Single;
begin
  alGetSourcef(FRef, AL_GAIN, @Result);
end;

procedure TOALRefSource.SetPosition(const aValue : TOALVector);
begin
  alSourcefv(FRef, AL_POSITION, @aValue);
end;

procedure TOALRefSource.SetVelocity(const aValue : TOALVector);
begin
  alSourcefv(FRef, AL_VELOCITY, @aValue);
end;

procedure TOALRefSource.SetGain(aValue : Single);
begin
  alSourcef(FRef, AL_GAIN, aValue);
end;

function TOALRefSource.GetDirection : TOALVector;
begin
  alGetSourcefv(FRef, AL_DIRECTION, @Result);
end;

function TOALRefSource.GetInnerAngle : Single;
begin
  alGetSourcef(FRef, AL_CONE_INNER_ANGLE, @Result);
end;

function TOALRefSource.GetOuterAngle : Single;
begin
  alGetSourcef(FRef, AL_CONE_OUTER_ANGLE, @Result);
end;

function TOALRefSource.GetOuterGain : Single;
begin
  alGetSourcefv(FRef, AL_CONE_OUTER_GAIN, @Result);
end;

function TOALRefSource.GetRelative : Boolean;
var v : Integer;
begin
  alGetSourcei(FRef, AL_SOURCE_RELATIVE, @v);
  Result := v = AL_TRUE;
end;

function TOALRefSource.GetSourceType : TOALSourceType;
var v : Integer;
begin
  alGetSourcei(FRef, AL_SOURCE_TYPE, @v);

  case v of
    AL_STATIC : Result := oalstStatic;
    AL_STREAMING : Result := oalstStreaming;
  else
    Result := oalstUndeterimated;
  end;
end;

function TOALRefSource.GetState : TOALSourceState;
var v : Integer;
begin
  alGetSourcei(FRef, AL_SOURCE_STATE, @v);

  case v of
    AL_INITIAL : Result := oalsInitial;
    AL_PLAYING : Result := oalsPlaying;
    AL_PAUSED :  Result := oalsPaused;
    AL_STOPPED : Result := oalsStopped;
  else
    Result := oalsInvalid;
  end;
end;

function TOALRefSource.GetLooping : Boolean;
var v : Integer;
begin
  alGetSourcei(FRef, AL_LOOPING, @v);
  Result := v = AL_TRUE;
end;

function TOALRefSource.GetBuffersQueued : Integer;
begin
  alGetSourcei(FRef, AL_BUFFERS_QUEUED, @Result);
end;

function TOALRefSource.GetBuffersProcessed : Integer;
begin
  alGetSourcei(FRef, AL_BUFFERS_PROCESSED, @Result);
end;

function TOALRefSource.GetMinGain : Single;
begin
  alGetSourcef(FRef, AL_MIN_GAIN, @Result);
end;

function TOALRefSource.GetMaxGain : Single;
begin
  alGetSourcef(FRef, AL_MAX_GAIN, @Result);
end;

function TOALRefSource.GetReferenceDistance : Single;
begin
  alGetSourcef(FRef, AL_REFERENCE_DISTANCE, @Result);
end;

function TOALRefSource.GetRolloffFactor : Single;
begin
  alGetSourcef(FRef, AL_ROLLOFF_FACTOR, @Result);
end;

function TOALRefSource.GetMaxDistance : Single;
begin
  alGetSourcef(FRef, AL_MAX_DISTANCE, @Result);
end;

function TOALRefSource.GetPitch : Single;
begin
  alGetSourcef(FRef, AL_PITCH, @Result);
end;

function TOALRefSource.GetOffsetFloat(offtype : TOALOffsetType) : Single;
var loc : Integer;
begin
  case offtype of
    oalotSecond : loc := AL_SEC_OFFSET;
    oalotSample : loc := AL_SAMPLE_OFFSET;
  else
    loc := AL_BYTE_OFFSET;
  end;

  alGetSourcef(FRef, loc, @Result);
end;

function TOALRefSource.GetOffsetInt(offtype : TOALOffsetType) : Integer;
var loc : Integer;
begin
  case offtype of
    oalotSecond : loc := AL_SEC_OFFSET;
    oalotSample : loc := AL_SAMPLE_OFFSET;
  else
    loc := AL_BYTE_OFFSET;
  end;

  alGetSourcei(FRef, loc, @Result);
end;

procedure TOALRefSource.SetDirection(const aValue : TOALVector);
begin
  alSourcefv(FRef, AL_DIRECTION, @aValue);
end;

procedure TOALRefSource.SetInnerAngle(aValue : Single);
begin
  alSourcef(FRef, AL_CONE_INNER_ANGLE, aValue);
end;

procedure TOALRefSource.SetOuterAngle(aValue : Single);
begin
  alSourcef(FRef, AL_CONE_OUTER_ANGLE, aValue);
end;

procedure TOALRefSource.SetOuterGain(aValue : Single);
begin
  alSourcef(FRef, AL_CONE_OUTER_GAIN, aValue);
end;

procedure TOALRefSource.SetRelative(aValue : Boolean);
begin
  alSourcei(FRef, AL_SOURCE_RELATIVE, Integer(aValue));
end;

procedure TOALRefSource.SetLooping(aValue : Boolean);
begin
  alSourcei(FRef, AL_LOOPING, Integer(aValue));
end;

procedure TOALRefSource.SetMinGain(aValue : Single);
begin
  alSourcef(FRef, AL_MIN_GAIN, aValue);
end;

procedure TOALRefSource.SetMaxGain(aValue : Single);
begin
  alSourcef(FRef, AL_MAX_GAIN, aValue);
end;

procedure TOALRefSource.SetReferenceDistance(aValue : Single);
begin
  alSourcef(FRef, AL_REFERENCE_DISTANCE, aValue);
end;

procedure TOALRefSource.SetRolloffFactor(aValue : Single);
begin
  alSourcef(FRef, AL_ROLLOFF_FACTOR, aValue);
end;

procedure TOALRefSource.SetMaxDistance(aValue : Single);
begin
  alSourcef(FRef, AL_MAX_DISTANCE, aValue);
end;

procedure TOALRefSource.SetPitch(aValue : Single);
begin
  alSourcef(FRef, AL_PITCH, aValue);
end;

procedure TOALRefSource.SetOffset(offtype : TOALOffsetType; aValue : Single);
var loc : Integer;
begin
  case offtype of
    oalotSecond : loc := AL_SEC_OFFSET;
    oalotSample : loc := AL_SAMPLE_OFFSET;
  else
    loc := AL_BYTE_OFFSET;
  end;

  alSourcef(FRef, loc, aValue);
end;

end.

