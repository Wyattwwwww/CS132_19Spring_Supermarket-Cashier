clc;
clear;
load db_1.mat;
mapp = ManagerUI;
capp = CashierUI;

mapp.database = db;
capp.database = db;
