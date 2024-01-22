clear all;clc;
video_file=VideoWriter('test.avi');
video_file.FrameRate=20;
open(video_file);

car_data=stlread('vw_gti_flowalistik_v2.stl');
figure(1); clf;


car_data_1=car_data;
car_data_2=car_data;
car_data_3=car_data;
car_data_4=car_data;
car_data_5=car_data;
car_data_6=car_data;
car_data_7=car_data;
car_data_8=car_data;
car_data_9=car_data;

my_data=car_data;


car_x=car_data.vertices(:,1)';
car_y=car_data.vertices(:,2)';
car_z=car_data.vertices(:,3)';

car = [car_x;car_y;car_z;ones(1,length(car_x))];

car_yaw=90/180*pi;

R_my=[cos(pi) -sin(pi) 0 -500;
    sin(pi) cos(pi) 0 170;
    0 0 1 0;
     0 0 0 1];

R_up_road=[cos(car_yaw) sin(car_yaw) 0 400;
    -sin(car_yaw) cos(car_yaw) 0 0;
    0 0 1 0;
    0 0 0 1];

R_down_road=[cos(car_yaw) -sin(car_yaw) 0 90;
    sin(car_yaw) cos(car_yaw) 0 0;
    0 0 1 0;
    0 0 0 1];

for i=1:1:5
    offset{i}=[0 0 0 0
        0 0 0 400+(i*200)
        0 0 0 0
        0 0 0 0];
end
for i=1:1:5
    yoffset{i}=[0 0 0 0
        0 0 0 i*-200
        0 0 0 0
        0 0 0 0];
end

car_down_1=(R_down_road+offset{1})*car;
car_down_2=(R_down_road+offset{2})*car;
car_down_3=(R_down_road+offset{3})*car;
car_down_4=(R_down_road+offset{4})*car;

car_up_1=(R_up_road+yoffset{1})*car;
car_up_2=(R_up_road+yoffset{2})*car;
car_up_3=(R_up_road+yoffset{3})*car;
car_up_4=(R_up_road+yoffset{4})*car;
car_up_5=(R_up_road+yoffset{5})*car;

car_my=R_my*car;



for n=0:1:300
    clf;
    R_go_right=[1 0 0 0;
        0 1 0 -10;
        0 0 1 0;
        0 0 0 1];

    R_go_left=[1 0 0 0;
        0 1 0 10;
        0 0 1 0;
        0 0 0 1];

    R_my_straight=[1 0 0 7;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

    R_my_straight2=[1 0 0 0;
        0 1 0 -14;
        0 0 1 0;
        0 0 0 1];


    mycar_yaw=3/180*pi;

    R_my_turn=[cos(mycar_yaw) sin(mycar_yaw) 0 -3;
    -sin(mycar_yaw) cos(mycar_yaw) 0 -2;
    0 0 1 0;
    0 0 0 1];


    car_down_1=R_go_right*car_down_1;
    car_down_2=R_go_right*car_down_2;
    car_down_3=R_go_right*car_down_3;
    car_down_4=R_go_right*car_down_4;

    car_up_1=R_go_left*car_up_1;
    car_up_2=R_go_left*car_up_2;
    car_up_3=R_go_left*car_up_3;
    car_up_4=R_go_left*car_up_4;
    car_up_5=R_go_left*car_up_5;

    if(n<80)
    car_my=R_my_straight*car_my;
    end

    if(n>=160) && (n<=189)
        car_my=R_my_turn*car_my;
    end

    if(n>=189)
        car_my=R_my_straight2*car_my;
    end
    car_data_1.vertices = car_down_1([1:3],:)';
    car_data_2.vertices = car_down_2([1:3],:)';
    car_data_3.vertices = car_down_3([1:3],:)';
    car_data_4.vertices = car_down_4([1:3],:)';

    car_data_5.vertices=car_up_1([1:3],:)';
    car_data_6.vertices=car_up_2([1:3],:)';
    car_data_7.vertices=car_up_3([1:3],:)';
    car_data_8.vertices=car_up_4([1:3],:)';
    car_data_9.vertices=car_up_5([1:3],:)';

    my_data.vertices=car_my([1:3],:)';

    subplot(2,2,1);

    axis equal; hold on;


    
    patch(car_data_1,'FaceColor','r','EdgeColor','b');
    patch(car_data_2,'FaceColor','r','EdgeColor','r');
    patch(car_data_3,'FaceColor','r','EdgeColor','r');
    patch(car_data_4,'FaceColor','r','EdgeColor','b');
    patch(car_data_5,'FaceColor','r','EdgeColor','r');
    patch(car_data_6,'FaceColor','r','EdgeColor','r');
    patch(car_data_7,'FaceColor','r','EdgeColor','b');
    patch(car_data_8,'FaceColor','r','EdgeColor','r');
    patch(car_data_9,'FaceColor','r','EdgeColor','r');

    patch(my_data,'FaceColor','y','EdgeColor','y');

    axis([-500 500 -500 500 0 50]);
    xlabel('x')
    x=[300 300];
    y=[-2000 600];
    x2=[-500 0];
    y2=[300 300];

    rectangle('Position',[-1000,-1000,2000,2000],'FaceColor',[0.5 0.5 0.5])

    rectangle('Position',[-700 -1000 800 1200],'FaceColor',[0 1 0],'Curvature',[0.5])
    rectangle('Position',[-700 400 800 300],'FaceColor',[0 1 0],'Curvature',[0.5 ])
    line(x,y,'Color','y','LineStyle','-','LineWidth',2)
    line(x+100,y,'Color','w','LineStyle','--','LineWidth',2)
    line(x-100,y,'Color','w','LineStyle','--','LineWidth',2)
    line(x2,y2,'Color','w','LineStyle','-','LineWidth',2)
    xlabel('x');ylabel('y');zlabel('z');
    view([-60 -60 30]);

    subplot(2,2,2);

    axis equal; hold on;
    
    patch(car_data_1,'FaceColor','k','EdgeColor','k');
    patch(car_data_2,'FaceColor','k','EdgeColor','k');
    patch(car_data_3,'FaceColor','k','EdgeColor','k');
    patch(car_data_4,'FaceColor','k','EdgeColor','k');
    patch(car_data_5,'FaceColor','k','EdgeColor','k');
    patch(car_data_6,'FaceColor','k','EdgeColor','k');
    patch(car_data_7,'FaceColor','k','EdgeColor','k');
    patch(car_data_8,'FaceColor','k','EdgeColor','k');
    patch(car_data_9,'FaceColor','k','EdgeColor','k');

    patch(my_data,'FaceColor','y','EdgeColor','y');

    if(n<80)
    axis([-700+(n*4) 100+(n*4) -300 600 0 50]);
    view(-90,40);
    end

    if(n>=80)&&(n<160)
        axis([-380 420 -300 600 0 50]);
        view(-90,40);
    end

    if(n>=160) && (n<=189)
        axis([-380 420 -300 600 0 50]);
        view(70-n,40);
    end


    if(n>=190)
        axis([-380 420 -300-((n-190)*17) 600-((n-190)*17) 0 50]);
        view(-120,40);
    end


    xlabel('x')
    x=[300 300];
    y=[-3000 600];
    x2=[-500 0];
    y2=[300 300];

    rectangle('Position',[-5000,-5000,300000,300000],'FaceColor',[0.5 0.5 0.5])

    rectangle('Position',[-700 -8000 800 8200],'FaceColor',[0.9 0.9 0.9],'Curvature',[0.5])
    rectangle('Position',[-700 400 800 300],'FaceColor',[0.9 0.9 0.9],'Curvature',[0.5 ])
    line(x,y,'Color','y','LineStyle','-','LineWidth',2)
    line(x+100,y,'Color','w','LineStyle','--','LineWidth',2)
    line(x-100,y,'Color','w','LineStyle','--','LineWidth',2)
    line(x2,y2,'Color','w','LineStyle','-','LineWidth',2)
    xlabel('x');ylabel('y');zlabel('z');
    


    subplot(2,2,3);

     hold on;

    patch(car_data_1,'FaceColor','b','EdgeColor','b');
    patch(car_data_2,'FaceColor','r','EdgeColor','r');
    patch(car_data_3,'FaceColor','r','EdgeColor','r');
    patch(car_data_4,'FaceColor','b','EdgeColor','b');
    patch(car_data_5,'FaceColor','r','EdgeColor','r');
    patch(car_data_6,'FaceColor','r','EdgeColor','r');
    patch(car_data_7,'FaceColor','b','EdgeColor','b');
    patch(car_data_8,'FaceColor','r','EdgeColor','r');
    patch(car_data_9,'FaceColor','r','EdgeColor','r');

    patch(my_data,'FaceColor','y','EdgeColor','y');

    if(n<80)
    axis([-500+(n*6) 100+(n*6) -300 600 0 100]);
    view(-90,5);
    end

    if(n>=80)&&(n<160)
        axis([-20 580 -300 600 0 100]);
        view(-90,5);
    end

    if(n>=160) && (n<=189)
        axis([-20 580 -300-((n-159)*30) 600-((n-159)*30) 0 100]);
        view((70-n)-((n-159)*2),5);
    end


    if(n>=190)
        axis([-20 580 -900-((n-190)*17) 0-((n-190)*17) 0 100]);
        view(-180,5);
    end


    xlabel('x')
    x=[300 300];
    y=[-3000 600];
    x2=[-500 0];
    y2=[300 300];

    rectangle('Position',[-5000,-5000,300000,300000],'FaceColor',[0.5 0.5 0.5])

    rectangle('Position',[-700 -8000 800 8200],'FaceColor',[0 1 0],'Curvature',[0.5])
    rectangle('Position',[-700 400 800 300],'FaceColor',[0 1 0],'Curvature',[0.5 ])
    line(x,y,'Color','y','LineStyle','-','LineWidth',2)
    line(x+100,y,'Color','w','LineStyle','--','LineWidth',2)
    line(x-100,y,'Color','w','LineStyle','--','LineWidth',2)
    line(x2,y2,'Color','w','LineStyle','-','LineWidth',2)
    xlabel('x');ylabel('y');zlabel('z');
    


    frame=getframe(gcf);
    writeVideo(video_file,frame);






    pause(0.000001);
end

close(video_file);