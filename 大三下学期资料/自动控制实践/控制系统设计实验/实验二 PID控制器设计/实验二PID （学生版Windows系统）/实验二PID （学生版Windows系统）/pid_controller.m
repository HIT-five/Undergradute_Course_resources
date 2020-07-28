function pid_controller(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)

  block.NumDialogPrms  = 3;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
  %% Set block sample rate
  block.SampleTimes = [0.002 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs', @Output);  
  
  %% Global Variables
  global register1;
  global register2;
  register1 = 0;
  register2 = 0;
  
%endfunction
%本实验要求学生自主编写位置式PID控制器，控制周期为0.002s
%已为学生声明好  控制器参数Kp、Ki、Kd   
%               寄存器register1和register2 （这两项为全局变量，类似于C语言的寄存器效果）
%               当前时刻误差e，控制器计算出的控制量u
%学生只需编写相关变量之间的关系即可，若有因擅自改动其他参数导致程序出错的情况，后果自负
function Output(block)      
  global register1;  %控制器的积分项
  global register2;  %控制器的前一时刻误差
  Kp = block.DialogPrm(1).Data;
  Ki = block.DialogPrm(2).Data;
  Kd = block.DialogPrm(3).Data;
  e = block.InputPort(1).Data;
  T = 0.002;
  d = (e-register2)/T;
  register2 = e;
  register1 = register1 + e * T;
  u = Kp*e + Ki * register1 + Kd*d;
%学生自主编写部分（起始）





%学生自主编写部分（终止）
  block.OutputPort(1).Data = u;
  
%endfunction