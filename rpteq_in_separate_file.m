%% Reporting Equations in Separate File 
%
% Saving reporting equations in a separate text file, and creating |rpteq|
% objects based on such text files is a convenient option if you, for
% example, have a large number of equations that are used multiple times in
% different places. Otherwise, there is absolutely no difference in how to
% work with an |rpteq| object created directly or from a separate file.


%% Clear Workspace

close all
clear
%#ok<*NOPTS>


%% Look into |example.rpt| File 
%
% Save the three reporting equations (the same equations as in
% |rpteq_directly_in_mfile|) in a separate text file, |example.rpt|; the
% file can have any extension. If you need so, you can use all preparser
% commands in that file, such as |!if|, |!switch|, |!for|,
% |!substitutions|, etc. 

edit example.rpt


%% Create rpteq Object 
%
% Call the |rpteq| command with the name of the file as its first input
% argument. This is practially the only difference from what we're doing in
% |rpteq_directly_in_mfile|.

q = rpteq('example.rpt') 


%% Evaluate Reporting Equations 
%
% The rest of the file works exactly the same as |rpteq_directly_in_mfile|.
% Check out the other file for details on what is going on.

load rpteq_directly_in_mfiles d d1 d2 d3 startDate endDate

g1 = run(q, d, startDate:endDate) 
g1.growth
g1.a
g1.b

g2 = run(q, d, startDate:endDate, 'AppendPresample=', true)
g2.a
g2.b

g3 = run(q, d, startDate:endDate, 'Fresh=', true)


%% Compare Results with Previous File 

maxabs(d1, g1)
maxabs(d2, g2)
maxabs(d3, g3)

