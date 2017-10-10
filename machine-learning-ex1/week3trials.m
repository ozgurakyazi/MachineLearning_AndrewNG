#####
warning ("off");
clear;
the_data = dlmread("multiclassdata.mat");

global x_input= the_data(:, [2 3 4]);
global y_input= the_data(:,1);

x_input = [ones(size(x_input,1),1) x_input];

global temp_y=1;

function output = logistic_reg_function(theta, x_list)

  output = (1 + exp(-([x_list(:,1), x_list(:,2:4).^3 ] * theta))).^-1;
endfunction

function [jval, gradient] = costfunction(theta)
  global x_input;
  global temp_y;
  m = size(x_input,1);
  #hx = (1 + exp(-(x_input * theta))).^-1;

  hx = logistic_reg_function(theta, x_input);

  jval = -1/m*(temp_y' * log(hx) + (1-temp_y)' * log(1-hx) );

  gradient= zeros(4,1);
  gradient(1)= 1/m * x_input(:,1)' * (hx - temp_y);
  gradient(2)= 1/m * (x_input(:,2).^3)' * (hx - temp_y);
  gradient(3)= 1/m * (x_input(:,3).^3)' * (hx - temp_y);
  gradient(4)= 1/m * (x_input(:,4).^3)' * (hx - temp_y);
endfunction

result = zeros(4,4);

for i = 1:4

  temp_y = y_input;
  temp_y(temp_y != i-1)=4;
  temp_y(temp_y == i-1)=1;
  temp_y(temp_y == 4 ) = 0;
  temp_y;
  initialTheta = zeros(4,1);
  options = optimset('GradObj', 'on', 'MaxIter', '100');

  result(i,:) = (fminunc(@costfunction, initialTheta, options))';

end




result



the_zeros = x_input(find(y_input == 0),:);
the_ones = x_input(find(y_input == 1),:);
the_twos = x_input(find(y_input == 2),:);

figure;
plot3(the_zeros(:,[2]),the_zeros(:,3),the_zeros(:,4),'Color',[0.0,0.0,1.0],'.','MarkerSize', 20);
hold on;
plot3(the_ones(:,[2]),the_ones(:,3),the_ones(:,4),'Color',[0.0,1.0,0.0],'.','MarkerSize', 20);
hold on;
plot3(the_twos(:,[2]),the_twos(:,3),the_twos(:,4),'Color',[1.0,0.0,0.0],'.','MarkerSize', 20);
hold on;

x = -1.0:0.1:1.0;
y=x;

[p,q,r] = meshgrid(x,y,x);

points= [ones(size(p(:),1),1), r(:),p(:), q(:)];

temp_res = logistic_reg_function(result',points);



#limi1 = find(temp_res(:,1)<=0.51 & temp_res(:,1)>=0.49);
#limi2 = find(temp_res(:,2)<=0.51 & temp_res(:,2)>=0.49);
#limi3 = find(temp_res(:,3)<=0.51 & temp_res(:,3)>=0.49);


#limi1 = find(temp_res(:,1)>=0.45);
#limi2 = find(temp_res(:,2)>=0.49);
#limi3 = find(temp_res(:,3)>=0.49);
#limi1;


[val, ind] = max([temp_res , ones(size(temp_res,1),1)*0.5]');
limi1 = find(ind == 1);
limi2 = find(ind == 2);
limi3 = find(ind == 3);


plot3(points(limi1,2),points(limi1,3),points(limi1,4),'Color',[0.0,0.0,1.0],'o','MarkerSize', 20);
plot3(points(limi2,2),points(limi2,3),points(limi2,4),'Color',[0.0,1.0,0.0],'-','MarkerSize', 20);
plot3(points(limi3,2),points(limi3,3),points(limi3,4),'Color',[1.0,0.0,0.0],'o','MarkerSize', 20);

#hold on;
#plot(result(1), reulst(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
