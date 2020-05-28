clc
clear all

data = load("Inertial_data.dat");
epoch = data(:, 1);
acc = data(:, 2:3); 
omegaz = data(:,4);

data_n = load("Inertial_data_errors.dat");
acc_n=data_n(:, 2:3); 
omegaz_n = data_n(:,4);
traject = CalcTrajectory_students(acc, omegaz, epoch);
traject_Noise = CalcTrajectory_students(acc_n, omegaz_n, epoch);
figure(1)
plot(traject(:, 1), traject(:, 2), "-r",traject_Noise(:, 1), traject_Noise(:, 2), "-b")
title("trajectory 2D")
legend("No noise", "With noise")
xlabel("x [m]")
ylabel("y [m]")