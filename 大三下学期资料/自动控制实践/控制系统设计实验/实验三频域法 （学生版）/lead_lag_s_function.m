function lead_lag_s_function(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  
  block.NumDialogPrms  = 1;
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
  %% Set block sample time to inherited
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
  N = 7;
  %% Setup Dwork
  block.NumDworks = 2;
  block.Dwork(1).Name = 'prev_u'; 
  block.Dwork(1).Dimensions      = N;
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;
  
  block.Dwork(2).Name = 'prev_y'; 
  block.Dwork(2).Dimensions      = N;
  block.Dwork(2).DatatypeID      = 0;
  block.Dwork(2).Complexity      = 'Real';
  block.Dwork(2).UsedAsDiscState = true;
%endfunction

function InitConditions(block)

  %% Initialize Dwork
  block.Dwork(1).Data = zeros(1, block.Dwork(1).Dimensions);
  block.Dwork(2).Data = zeros(1, block.Dwork(2).Dimensions);
  
%endfunction

function Output(block)
  N = block.Dwork(1).Dimensions;
  for i = 1:N
    lead_lag(block, i);
  end
  block.OutputPort(1).Data = block.Dwork(2).Data(end);
  
%endfunction


function lead_lag(block, i)
  if i == 1
    u = block.InputPort(1).Data;
  else
    u = block.Dwork(2).Data(i - 1);
  end
  Ts = 0.002;
  prev_u = block.Dwork(1).Data(i);
  prev_y = block.Dwork(2).Data(i);
  k = block.DialogPrm(1).Data(i, 1);
  t1 = block.DialogPrm(1).Data(i, 2);
  t2 = block.DialogPrm(1).Data(i, 3);
  %--------实验B控制器说明----------%
  % prev_u为上一步的输入量，prev_y为上一步的输出量，k为增益，t1为分子时间常数，t2为分母时间常数
  %控制器形式如下：
  % Y       t1*s + 1
  %--- = k*---------
  % U       t2*s + 1
  %选择实验B的同学只需要编写控制器的代码即可，控制器参数统一通过实验系统界面进行设计
  %建议使用双线性变换或后向积分变换
  %学生自主编写部分开始
  y = 0;
  y = (k*(2*t1+Ts)*u+k*(Ts-2*t1)*prev_u-(Ts-2*t2)*prev_y)/(2*t2+Ts);
  


%学生自主编写部分结束
  block.Dwork(1).Data(i) = u;
  block.Dwork(2).Data(i) = y; %采用按次序的仿真而不是并列运行的仿真
  
%endfunction
