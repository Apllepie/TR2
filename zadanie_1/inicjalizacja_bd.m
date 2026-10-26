% INICJALIZACJA_BD - Skrypt czyszczący przestrzeń roboczą, dodający ścieżkę i deklarujący zmienne globalne
clear;
clc;
close all;

% Dodanie bieżącej ścieżki do zmiennej PATH
addpath(pwd);

% Deklaracja zmiennych globalnych
global baza A B C D;

% Inicjalizacja struktury przechowującej bazę danych
baza = struct('nazwa', {}, 'A', {}, 'B', {}, 'C', {}, 'D', {});
disp('Inicjalizacja bazy danych zakończona pomyślnie.');

baza = [];
A=  [];
B = [];
C = [];
D = [];