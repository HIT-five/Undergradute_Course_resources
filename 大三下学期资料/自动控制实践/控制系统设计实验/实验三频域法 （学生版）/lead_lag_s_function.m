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
  %--------ʵ��B������˵��----------%
  % prev_uΪ��һ������������prev_yΪ��һ�����������kΪ���棬t1Ϊ����ʱ�䳣����t2Ϊ��ĸʱ�䳣��
  %��������ʽ���£�
  % Y       t1*s + 1
  %--- = k*---------
  % U       t2*s + 1
  %ѡ��ʵ��B��ͬѧֻ��Ҫ��д�������Ĵ��뼴�ɣ�����������ͳһͨ��ʵ��ϵͳ����������
  %����ʹ��˫���Ա任�������ֱ任
  %ѧ��������д���ֿ�ʼ
  y = 0;
  y = (k*(2*t1+Ts)*u+k*(Ts-2*t1)*prev_u-(Ts-2*t2)*prev_y)/(2*t2+Ts);
  


%ѧ��������д���ֽ���
  block.Dwork(1).Data(i) = u;
  block.Dwork(2).Data(i) = y; %���ð�����ķ�������ǲ������еķ���
  
%endfunction
