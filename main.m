%return;
tic();
zMain_End=false;
%% SYS %%
global PAR;
if isempty(PAR)
    PAR.MAP_X=8000; %6
    PAR.MAP_Y=6000; %4
    PAR.KICK_DIST=120;
end
%����������
global Pause;
if isempty(Pause)
    Pause=0;
end
if (Pause)
    return;
end
%% Data
%�� SSL
global Balls;
global Blues;
global Yellows;
%��� BT
global Rules;
if isempty(Rules)
    Rules=zeros(4,7);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%-------------------------�������� �������--------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ����� ������� ����������. 
% B=[Balls(1,2),Balls(1,3)]; 
% X=Yellows(11,2:4);
% [Left,Right,Kick]=GoSlide(X(1:2),X(3),B,pi/6);
% Rule(5,Left,Right,Kick,0,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ������� ����������
% B=Balls(2:3);
% X=Yellows(10,2:4); %�������� �����
% G=[-2000,2000]; %������
% ST=[-1500,-1500]; %����� ��������
% if  ((Balls(1)==0)||(abs(B(1))>2800)||(abs(B(2))>2700)||((B(2))>000))
%     [Left,Right]=GoToPoint(X(1:2),X(3),ST,pi/2-pi/2*sign(B(1)));
%    Kick=0;
% else 
%     %[Left,Right,Kick]=GOcircle6(X(1:2),X(3),B,angV(G-B));
%     [Left,Right,Kick]=GOSlide(X(1:2),X(3),B,angV(G-B));
%     %[Left,Right,Kick]=GOeiler(X(1:2),X(3),B,angV(G-B));%angV(G-B));
% end
% Rule(2,Left,Right,-Kick,0,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TrackAvoidance (����������) ���������� �������
% B=[Balls(1,2),Balls(1,3)]; 
% X=Blues(3,2:4);
% Opponent=Yellows(Yellows(:,1)>0,2:3);
% Opponent2=[Blues(Blues(:,1)>0,2:3);Opponent];
% G=[-3500,0];%[-PAR.MAP_X/2,0000]; %������
% if (norm(B-X(1:2))<700 && isSectorClear(X(1:2),B,angV(G-B),Opponent,100))
%     [Left,Right,Kick]=GOSlide(X(1:2),X(3),B,angV(G-B));       
% else
%     Kick=0;
%     [Left,Right]=TrackAvoidance(X(1:2),X(3),B,angV(G-B),2,Opponent);
% end
% if ~isSectorClear(X(1:2),X(1:2)+300*[cos(X(3)),sin(X(3))],Opponent2);
%     V=(Left+Right)/2;
%     Left=Left-V;
%     Right=Right-V;
% end
% Rule(6,Left,Right,Kick,0,0);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TrackAvoidance (����������)
B=Balls(2:3);       %����
X=Yellows(4,2:4);   %�������� ����� (4�� ����� �����)
G=[0,0];            %������
ST=[-1500,1200];    %����� ��������
Opponent=Blues(Blues(:,1)>0,2:3);                 %��������� (��� �����)
Opponent2=[Yellows(Yellows(:,1)>0,2:3);Opponent]; %����������� (��� ������)
if  ((Balls(1)==0)||(abs(B(1))>PAR.MAP_X/2-300)||(abs(B(2))>PAR.MAP_Y/2-300)) %���� ���� �� � ������������� ����
    if (norm(ST-X(1:2))>300) %���� ���������� �� ����� �������� ������ 300
        [Left,Right]=TrackAvoidance(X(1:2),X(3),ST,angV(B-ST),12,Opponent,0,0); %������� ����������� � ���� � ST
    else
        Left=0; Right=0;        %������������.
    end
    Kick=0;
else
    if (norm(B-X(1:2))<700 && isSectorClear(X(1:2),B,angV(G-B),Opponent,100)) %���� �� ������ � ���� � ������ ��� ������ ��������
        [Left,Right,Kick]=GOSlide(X(1:2),X(3),B,angV(G-B));       %����� �� ����
    else
        Kick=0;
        [Left,Right]=TrackAvoidance(X(1:2),X(3),B,angV(G-B),2,Opponent);  %������� ����������� � ���� � B
    end
end
[Left,Right]=ReactAvoidance(Left,Right,X(1:2),X(3),Opponent2); %���������� ����� ����������� (�� ��������� � �����).
Rule(4,Left,Right,-Kick,0,0); %���������� �� 4��� ������.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��������.
if (Balls(1)==0)
    Left=0;Right=0;Kick=0;
else
    B=[Balls(1,2),Balls(1,3)]; 
    X=Yellows(10,2:4);
    G=[-2800,0]; %������� �����
    [Left,Right,Kick]=GoalKeeper(X(1:2),X(3),B,G);
end
Rule(1,Left,Right,-Kick,0,0);
%% ��������.
if (Balls(1)==0)
    Left=0;Right=0;Kick=0;
else
    B=[Balls(1,2),Balls(1,3)]; 
    X=Blues(10,2:4);
    G=[2800,-00]; %������� �����
    [Left,Right,Kick]=GoalKeeper(X(1:2),X(3),B,G);
end
Rule(2,Left,Right,-Kick,0,0);
%% MAP
MAP
%iso_MAP
%RP_map
%%
zMain_End=true;
%fprintf('End of MAIN\n');