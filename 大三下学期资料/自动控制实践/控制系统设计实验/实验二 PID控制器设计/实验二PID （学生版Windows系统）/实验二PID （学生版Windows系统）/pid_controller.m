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
%��ʵ��Ҫ��ѧ��������дλ��ʽPID����������������Ϊ0.002s
%��Ϊѧ��������  ����������Kp��Ki��Kd   
%               �Ĵ���register1��register2 ��������Ϊȫ�ֱ�����������C���ԵļĴ���Ч����
%               ��ǰʱ�����e��������������Ŀ�����u
%ѧ��ֻ���д��ر���֮��Ĺ�ϵ���ɣ����������ԸĶ������������³����������������Ը�
function Output(block)      
  global register1;  %�������Ļ�����
  global register2;  %��������ǰһʱ�����
  Kp = block.DialogPrm(1).Data;
  Ki = block.DialogPrm(2).Data;
  Kd = block.DialogPrm(3).Data;
  e = block.InputPort(1).Data;
  T = 0.002;
  d = (e-register2)/T;
  register2 = e;
  register1 = register1 + e * T;
  u = Kp*e + Ki * register1 + Kd*d;
%ѧ��������д���֣���ʼ��





%ѧ��������д���֣���ֹ��
  block.OutputPort(1).Data = u;
  
%endfunction