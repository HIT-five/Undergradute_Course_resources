function DOB_s_function(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  
  block.NumDialogPrms  = 4;
  %% Register number of input and output ports
  block.NumInputPorts  = 2;
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

  %% Setup Dwork
  block.NumDworks = 5;
  block.Dwork(1).Name = 'Q_prev_u'; 
  block.Dwork(1).Dimensions      = 3;
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;
  
  block.Dwork(2).Name = 'Q_prev_y'; 
  block.Dwork(2).Dimensions      = 3;
  block.Dwork(2).DatatypeID      = 0;
  block.Dwork(2).Complexity      = 'Real';
  block.Dwork(2).UsedAsDiscState = true;
  
  block.Dwork(3).Name = 'Ginv_prev_u'; 
  block.Dwork(3).Dimensions      = 3;
  block.Dwork(3).DatatypeID      = 0;
  block.Dwork(3).Complexity      = 'Real';
  block.Dwork(3).UsedAsDiscState = true;
  
  block.Dwork(4).Name = 'Ginv_prev_y'; 
  block.Dwork(4).Dimensions      = 3;
  block.Dwork(4).DatatypeID      = 0;
  block.Dwork(4).Complexity      = 'Real';
  block.Dwork(4).UsedAsDiscState = true;
  
  block.Dwork(5).Name = 'DOB_prev_y'; 
  block.Dwork(5).Dimensions      = 1;
  block.Dwork(5).DatatypeID      = 0;
  block.Dwork(5).Complexity      = 'Real';
  block.Dwork(5).UsedAsDiscState = true;
%endfunction

function InitConditions(block)

  %% Initialize Dwork
  block.Dwork(1).Data = zeros(1, 3);
  block.Dwork(2).Data = zeros(1, 3);
  block.Dwork(3).Data = zeros(1, 3);
  block.Dwork(4).Data = zeros(1, 3);
  block.Dwork(5).Data = 0;
  
%endfunction

function Output(block)
  u = block.InputPort(1).Data;
  y1 = Q(block);
  y2 = Ginv(block);
  %���Ź۲�����ӵ㣬y1�ǵ�ͨ�˲����������y2��ģ����������u�ǿ�����������Ŀ�����
  %ѧ����д���ֿ�ʼ
  y=u-(y2-y1);

  
  %ѧ����д���ֽ���
  block.Dwork(5).Data = y;
  block.OutputPort(1).Data = y;
  
%endfunction

function y = Q(block)
  tau = block.DialogPrm(4).Data;
  Ts = 0.002;
  for i = 1:3
    if i == 1
      u = block.Dwork(5).Data;
    else
      u = block.Dwork(2).Data(i - 1);
    end
    prev_u = block.Dwork(1).Data(i);
    prev_y = block.Dwork(2).Data(i);
    %���Ź۲����ĵ�ͨ�˲�����ֻ��Ҫ��дһ�����Ի��ڣ�һ���˲��������ɣ������˲�������ʽ�Ѱ�ͬѧ�����
    %uΪ��ͨ�˲������룬yΪ�����tauΪ�˲�����ʱ�䳣����pre_uΪǰһ�������룬pre_yΪǰһ�������
    %ѧ����д���ֿ�ʼ
    
    y=(Ts*prev_u+Ts*u-(Ts-2*tau)*prev_y)/(Ts+2*tau);

    %ѧ����д���ֽ���
    block.Dwork(1).Data(i) = u;
    block.Dwork(2).Data(i) = y;
  end
  
%endfunction

function y = Ginv(block)
  K = block.DialogPrm(1).Data;
  tau1 = block.DialogPrm(2).Data;
  tau2 = block.DialogPrm(3).Data;
  tau = block.DialogPrm(4).Data;
  Ts = 0.002;
  
  u = block.InputPort(2).Data;
  prev_u = block.Dwork(3).Data(1);
  prev_y = block.Dwork(4).Data(1);
  %���Ź۲�����ģ�ͽ����沿��
  %�����̽ṹ���Բ��յ�ͨ�˲���������⣬���ﲻ������Ľ��ͣ��������ڷֱ��д����
  %KΪ��Ӧ�������е�K0��tau1��Ӧ�������е�T1��tau2��Ӧ�������е�T2��tau��Ϊ��ͨ�˲�����ʱ�䳣��
  %uΪ��ǰ���룬yΪ��ǰ�����pre_uΪǰһ�������룬pre_yΪǰһ�������
  %ѧ����д���ֿ�ʼ1
  y=((2*u-2*prev_u)*K-(Ts-2*tau)*prev_y)/(Ts+2*tau);

  %ѧ����д���ֽ���1
  block.Dwork(3).Data(1) = u;
  block.Dwork(4).Data(1) = y;
  
  u = block.Dwork(4).Data(1);
  prev_u = block.Dwork(3).Data(2);
  prev_y = block.Dwork(4).Data(2);
  %ѧ����д���ֿ�ʼ2
  y=(u*(tau1*2+Ts)+prev_u*(Ts-tau1*2)-prev_y*(Ts-2*tau))/(Ts+2*tau);

  %ѧ����д���ֽ���
  block.Dwork(3).Data(2) = u;
  block.Dwork(4).Data(2) = y;
  
  u = block.Dwork(4).Data(2);
  prev_u = block.Dwork(3).Data(3);
  prev_y = block.Dwork(4).Data(3);
  %ѧ����д���ֿ�ʼ3
  y=(u*(tau2*2+Ts)+prev_u*(Ts-tau2*2)-prev_y*(Ts-2*tau))/(Ts+2*tau);

  %ѧ����д���ֽ���3
  block.Dwork(3).Data(3) = u;
  block.Dwork(4).Data(3) = y;
  
%endfunction