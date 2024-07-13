clear; clc;

[x,y,z]=sphere(19); %x,y,z 구만들기
x_p=reshape(x,1,[]); %1*400 사이즈의 행벡터
y_p=reshape(y,1,[]);
z_p=reshape(z,1,[]);
po_mat=[x_p;y_p;z_p;ones(size(x_p))]; %1*400의 사이즈로 단위벡터를 만들고 다 이어붙임

p_si_1=3; p_si_2=1; p_si_3=2; %planet size

po_mat1=po_mat(1:3,:)*p_si_1; %1~3행을 뽑아 사이즈 곱
po_mat2=po_mat(1:3,:)*p_si_2;
po_mat3=po_mat(1:3,:)*p_si_3;
po_mat1(4,:)=1; %4행은 1로 채움
po_mat2(4,:)=1;
po_mat3(4,:)=1;

figure(1); clf;
c1=5*ones(size(z)); %나중에 색배열로 쓰임
c2=2.5*ones(size(z));
c3=3*ones(size(z));
psi=0;
ob_sum1=[]; ob_sum2=[]; ob_sum3=[];
sx=-30; %태양의 시작 위치
for psi=-360:1:360*50
%planet1_sun
    %rotation
    sx=sx+0.1; %태양의 x좌표
    Rz=[cosd(psi) -sind(psi) 0 0;sind(psi) cosd(psi) 0 0;0 0 1 0;0 0 0 1]; %psi값만큼 yaw
    Rx=[cosd(10) 0 sind(10) 0; 0 1 0 0;-sind(10) 0 cosd(10) 0 ; 0 0 0 1];  %psi 값만큼 pitch
    %transition
    tran_sun=[sx;0;0;0]; %이것을 따라서 태양은 움직인다
    ob_sum1=[ob_sum1;tran_sun']; %태양의 이동궤적

    T=[1 0 0 tran_sun(1);0 1 0 tran_sun(2);0 0 1 tran_sun(3);0 0 0 1];
    y_po_mat1=T*Rx*Rz*po_mat1;
    x_re1=reshape(y_po_mat1(1,:),20,20); %이걸 토대로 원을 만든다
    y_re1=reshape(y_po_mat1(2,:),20,20);
    z_re1=reshape(y_po_mat1(3,:),20,20);
%planet2
    %revolution
    orbit_p2=[5*cosd(2*psi);5*sind(2*psi);0;1]; %5만큼 태양주위를 공전하게 곱
    Rx=[cosd(-10) 0 sind(-10) 0;0 1 0 0;-sind(-10 ...
        ) 0 cosd(-10) 0;0 0 0 1]; %-10값만큼 pitch
    orbit_p2=Rx*orbit_p2 + tran_sun; %태양의 이동궤적을 따라간다
    ob_sum2=[ob_sum2;orbit_p2']; %2번째 행성의 이동궤적 그리기 용
    %rotation
    Rz=[cosd(psi*2) -sind(psi*2) 0 0;sind(psi*2) cosd(psi*2) 0 0;0 0 1 0;0 0 0 1]; %psi*2 값만큼 yaw
    Rx=[cosd(-10) 0 sind(-10) 0 ;0 1 0 0;-sind(-10) 0 cosd(-10) 0 ; 0 0 0 1]; %10만큼 pitch
    y_po_mat2=Rx*Rz*po_mat2;

    x_re2=reshape(y_po_mat2(1,:),20,20)+orbit_p2(1);
    y_re2=reshape(y_po_mat2(2,:),20,20)+orbit_p2(2);
    z_re2=reshape(y_po_mat2(3,:),20,20)+orbit_p2(3);
%planet3
    %revoilution
    orbit_p3=[11*cosd(3*psi);11*sind(3*psi);0;1];
    Rx=[cosd(+20) 0 sind(+20) 0 ; 0 1 0 0;-sind(+20) 0 cosd(+20) 0 ; 0 0 0 1];
    orbit_p3=Rx*orbit_p3+tran_sun;
    ob_sum3=[ob_sum3;orbit_p3'];
    %rotation
    Rz=[cosd(psi*5) -sind(psi*5) 0 0;sind(psi*5) cosd(psi*5) 0 0;0 0 1 0;0 0 0 1];
    Rx=[cosd(-30) 0 sind(-30) 0 ;0 1 0 0;-sind(-30) 0 cosd(-30) 0 ; 0 0 0 1];
    y_po_mat3=Rx*Rz*po_mat3;
    x_re3=reshape(y_po_mat3(1,:),20,20)+orbit_p3(1);
    y_re3=reshape(y_po_mat3(2,:),20,20)+orbit_p3(2);
    z_re3=reshape(y_po_mat3(3,:),20,20)+orbit_p3(3);

    clf;view([0 0 90]);
    ax=25; axis([ax 2*ax -ax ax -ax ax]);
    axis square; grid minor; hold on;
    xlabel('x'); ylabel('y'); zlabel('z');
    line(ob_sum1(:,1),ob_sum1(:,2),ob_sum1(:,3),'color','r') %각 궤도의 선 색
    line(ob_sum2(:,1),ob_sum2(:,2),ob_sum2(:,3),'color','g')
    line(ob_sum3(:,1),ob_sum3(:,2),ob_sum3(:,3),'color','b')
    surf(x_re1,y_re1,z_re1,c1);surf(x_re2,y_re2,z_re2,c2);surf(x_re3,y_re3,z_re3,c3) %원그리기
    axis([-ax+1/10*psi ax+1/10*psi -ax ax -ax ax]);
    caxis([0 5]); %컬러의 섹 제한
    pause(0.0000001);
end