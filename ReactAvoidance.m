%[Left,Right] = ReactAvoidance(Left,Right,X,Xang,Opponent)
%rul = ReactAvoidance(rul,X,Xang,Opponent)
% ���������� ���������� �����������
% ������ ��� V>=0
function [Left,Right] = ReactAvoidance(Left,Right,X,Xang,Opponent)
RobotsizeX2=200;
len0=200;
    rul=[];
    agent=[];
if (nargin==2)
    agent=Left;
    Opponent=Right;
    rul=agent.rul;
    X=agent.z;
    Xang=agent.ang;
    Left=rul.left;
    Right=rul.right;
end
if (nargin==3)
    rul=Left;
    agent=Right;
    Opponent=X;
    X=agent.z;
    Xang=agent.ang;
    Left=rul.left;
    Right=rul.right;
end
if isstruct(Left)
    rul=Left;
        Opponent=Xang;
        Xang=X;
        X=Right;
    Left=rul.left;
    Right=rul.left;
end
if isstruct(X)
    agent=X;
    Opponent=Xang;
    Xang=agent.ang;
    X=agent.z;
end
if size(Opponent,2)==4
    Opponent=Opponent(Opponent(:,1)>0,2:3);
end    
%% Pars
Ubreal=(Right-Left)/200;
Vreal=(Right+Left)/200;
length=len0+Vreal*200;
%% Alg
dang=0;
re=isSectorClear(X,X+length*[cos(Xang),sin(Xang)],Opponent,Xang,RobotsizeX2,0);
cor=[];
while (dang<pi && re==0)
    if (dang==0)
        dang=pi/360;
    else
        dang=-dang-sign(dang)*(pi/180);
    end
    [re,cor]=isSectorClear(X,X+length*[cos(Xang+dang),sin(Xang+dang)],Opponent,Xang+dang,RobotsizeX2,0);    
end

Vreal=Vreal+max(0,abs(Ubreal)-0.8);
if (dang~=0)
    Ubneed=(dang/pi);
    if (Ubneed>=0)
        Ub=max(Ubneed,Ubreal);
    else
        Ub=min(Ubneed,Ubreal);
    end
else
    Ub=Ubreal;
end
Vneed=1-abs(Ub);
if ~isempty(cor)
    Vneed=min(Vneed,(norm(cor-X)-200)/len0);
end
V=min(Vneed,Vreal);
%% ������� � �������
Left=100*(V-Ub);
Right=100*(V+Ub);
%% graph
% global map_test_react;
% if (get(0,'CurrentFigure')==100)
% if isempty(map_test_react) || ~ishandle(map_test_react)
%     map_test_react=plot(X(1)+length*[0,cos(Xang+dang)],X(2)+length*[0,sin(Xang+dang)],'R');
% else
%     set(map_test_react,'xdata',X(1)+length*[0,cos(Xang+dang)],'ydata',X(2)+length*[0,sin(Xang+dang)]);     
% end
% end
  
if ~isempty(rul)  
    rul=Crul(Left,Right,rul.kick,0,0);
    Left=rul;
    Right=[];
end
end

