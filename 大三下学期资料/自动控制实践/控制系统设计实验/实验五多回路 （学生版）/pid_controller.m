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
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);
  block.RegBlockMethod('Outputs', @Output);  
  
  
%endfunction

function DoPostPropSetup(block)

  %% Setup Dwork
  block.NumDworks = 2;
  block.Dwork(1).Name = 'integral'; 
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;
  
  block.Dwork(2).Name = 'prev_e'; 
  block.Dwork(2).Dimensions      = 1;
  block.Dwork(2).DatatypeID      = 0;
  block.Dwork(2).Complexity      = 'Real';
  block.Dwork(2).UsedAsDiscState = true;

%endfunction

function InitConditions(block)

  %% Initialize Dwork
  block.Dwork(1).Data = 0;
  block.Dwork(2).Data = 0;
  
%endfunction
  
function Output(block)
  integral = block.Dwork(1).Data;
  prev_e = block.Dwork(2).Data;
  Kp = block.DialogPrm(1).Data;
  Ki = block.DialogPrm(2).Data;
  Kd = block.DialogPrm(3).Data;
  e = block.InputPort(1).Data;
  %实验B只需要编写一次PID控制器即可，相关变量都已声明好，只需编写控制器结构即可
  %e为误差，u为PID计算出的控制量
  %学生编写部分开始
  T = 0.002;
  d = (e-prev_e)/T;
  integral = integral+e*T;
 % prev_e = e;
  u=Kp*e+Ki*integral+Kd*d;
  %学生编写部分结束
  block.OutputPort(1).Data = u;
  block.Dwork(1).Data = integral;
  block.Dwork(2).Data = e;
  
%endfunction