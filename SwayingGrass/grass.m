clear; clc

num_data=30;
x=zeros(3,num_data);
x(3,:)=linspace(0,3,num_data); %잔디의 높이

f=0.2; %주파수
dt=0.1; %시간간격
t=0:dt:30; %시간
num_grass=25; %잔디의 개수

r=20;
vel_conv=8;%시간에 따른 감소 변화

psi2 = (40/180*pi)*(sin(2*pi*f*t)); %사인파 생성

figure(1); clf
C=imread('grass.jpg');
image(C);
hold on

cdata = flipdim( imread('grass.jpg'), 1 );
cdatar = flipdim( cdata, 2 );

ccdata = flipdim( imread('grasss.png'), 1 );

% % back
surface([11 -3; 11 -3], [-3 -3;-3 -3 ], [0 0; 8 8], ...
    'FaceColor', 'texturemap', 'CData', cdatar );

% right
surface([-3 -3; -3 -3], [-3 11; -3 11], [0 0; 8 8], ...
    'FaceColor', 'texturemap', 'CData', cdata );
view(3);

surface([11 11; -3 -3], [-3 11; -3 11], [0 0; 0 0], ...
     'FaceColor', 'texturemap', 'CData', ccdata );

%25개의 잔디를 생성, 5x5형식으로 2칸씩 떨어져있음
for mm=1:num_grass
    ax{mm}=plot3(x(1,:),x(1,:),x(1,:),'-r','LineWidth',4);
    x_cor(mm)=rem((mm-1),5)*2;
    y_cor(mm)=fix((mm-1)/5)*2;
    ax_wind=plot(0,0,'-b','LineWidth',2); %바람
    ax_wind2=plot(0,0,'-g','LineWidth',2);
end

box on; grid on;
xlim([-3 11]); ylim([-3 11]); zlim([0 8]);
xlabel('x');ylabel('y');zlabel('z'); 

view(30,40);
for pp=[0 30 45 80] %pp로 바람의 방향 조절
    t_vector=dt*ones(num_grass,1);  %각 잔디마다 시간을 담아놀 그릇 생성
    t2_vector=dt*ones(num_grass,1);

    wind_x_c=[];
    wind_y_c=[];

    wind_x2_c=[];
    wind_y2_c=[];

    wind_direction=pp/180*pi; %바람의 방향
    wind2_direction=(pp+10)/180*pi; %바람의 방향


    wind_x=t*5-2;
    wind_y=tan(wind_direction)*wind_x;

    wind_x2=t*5-2;
    wind_y2=tan(wind_direction)*wind_x2;

    xy_dist_old=ones(num_grass,1)*10;
    xy_dist_old2=ones(num_grass,1)*10;
   for j=1:length(t)
        %for  j=1:100
        wind_x=t(j)*2-5;
        wind_y=tan(wind_direction)*wind_x;
        
        wind_x2=t(j)*2-5;
        wind_y2=tan(wind2_direction)*wind_x2;
        %바람의 현재위치와 잔디의 위치간의 거리차에 대한 기울기가 +로변화하면 잔디가 움직임
        for mm=1:num_grass %잔디만큼 반복
            psi(mm)=psi2(round(t_vector(mm)/dt));
            xy_dist_new(mm)=sqrt((x_cor(mm)-wind_x)^2+(y_cor(mm)-wind_y)^2);
            xy_dist_new2(mm)=sqrt((x_cor(mm)-wind_x2)^2+(y_cor(mm)-wind_y2)^2);
            if  xy_dist_new(mm) < xy_dist_old(mm)
                
                t_vector(mm)=dt;  %각 잔디마다 움직이기 시작하는 시간을 다르게 한다
            end

            if  xy_dist_new2(mm) < xy_dist_old2(mm) 
                t2_vector(mm)=dt;  %각 잔디마다 움직이기 시작하는 시간을 다르게 한다
                
            end
        end

        xy_dist_old=xy_dist_new;
        xy_dist_old2=xy_dist_new2;
        for i = 1:size(x,2)
            %바람에 대한 yaw
            weight_a=(exp((i-num_data)/r));
            Rz1=[cos(wind_direction) -sin(wind_direction) 0;
                sin(wind_direction) cos(wind_direction) 0;
                0 0 1];
            Rz2=[cos((wind2_direction-wind_direction)/2)  -sin((wind2_direction-wind_direction)/2) 0;
                sin((wind2_direction-wind_direction)/2) cos((wind2_direction-wind_direction)/2) 0;
                0 0 1];
            %흔들림 대한 roll
            for mm=1:num_grass
                weight_b{mm}=exp(-t_vector(mm)/(vel_conv*1));
                Rx{mm}=[cos(weight_b{mm}*weight_a *psi(mm)) 0 sin(weight_b{mm}*weight_a*psi(mm));
                    0 1 0;
                    -sin(weight_b{mm}*weight_a*psi(mm)) 0 cos(weight_b{mm}*weight_a*psi(mm))];
                y{mm}(:,i)=Rz1*Rz2*Rx{mm}*x(:,i);
            end
        end
        %바람 궤적
        wind_x_c=[wind_x_c wind_x];
        wind_y_c=[wind_y_c wind_y];
        wind_x2_c=[wind_x2_c wind_x2];
        wind_y2_c=[wind_y2_c wind_y2];

        %그림업데이트
        for mm = 1:num_grass
            ax{mm}.XData=y{mm}(1,:)+x_cor(mm);
            ax{mm}.YData=y{mm}(2,:)+y_cor(mm);
            ax{mm}.ZData=y{mm}(3,:);
            ax_wind.XData=wind_x_c;
            ax_wind.YData=wind_y_c;
            ax_wind2.XData=wind_x2_c;
            ax_wind2.YData=wind_y2_c;
            refresh
            t_vector(mm)=t_vector(mm)+dt;
            t2_vector(mm)=t2_vector(mm)+dt;
            drawnow limitrate
        end
        
    end
end