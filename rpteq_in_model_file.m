%% Reporting Equations in Model File 
%
% Reporting equations can be included in a model file, under the heading
% |!reporting_equations|. The is convenient when you need to calculate and
% report a number of variables that are transformations of some other model
% results but do not feed back into the model. Reporting equations are
% mostly treated separately from the rest of the model: for example, the
% reporting equations are not evaluated within a |simulate| command but
% need to be run using the |reporting| command.


%% Clear Workspace 

close all
clear
%#ok<*NOPTS>


%% Look into Model File 
%
% The model file |example.model| contains two transition variables and
% equations, and three reporting equations, which are exactly the same as
% in the other examples in this tutorial. Note that you do not declare
% variables created or used in reporting equations.

edit example.model


%% Read Model File 
%
% Read the model file |Example.model| and create a model object.
% Set standard errors for the two model shocks, solve the model
% and its steady state (because this is a linear model, steady
% state is computed *after* the first-order solution). List
% transition variables, transition equations and reporting
% equations. Retrieve the reporting object (which can then be
% manipulated separately if you wish). Note there is nothing like
% reporting variables in the model object; they are created on
% the fly when running reporting equations.

m = model('example.model', 'Linear=', true);
m.std_eps = 0.05;
m.std_omg = 0.05;
m = solve(m);
m = sstate(m);

get(m, 'xNames').'
get(m, 'xEqtn').'
get(m, 'rEqtn').'
get(m, 'rpteq')


%% Alternative Way of Creating Model File
%
% Yet another way of creating the same model object would be
% importing the reporting equations into a model file using the
% keyword |!import|; see |yet_another_example.model|. The two
% model objects, |m| and |m1|, are the same.

edit yet_another_example.model
m1 = model('yet_another_example.model', 'Linear=', true);
isequal(m, m1)



%% Create Input Database for Simulation 
%
% Create an initial input database (here, a steady-state database) for
% simulating transition equations. The option |'randomShocks=' true| says
% that the two model shocks, |eps| and |omg|, will be drawn
% randomly from a normal distribution with std errors set in the model
% object, |std_eps| and |std_omg|.

startDate = qq(2010, 1);
endDate = qq(2011, 4);

d = sstatedb(m, startDate:endDate, 'ShockFunc=', @randn)
d.eps 
d.omg 


%% Simulate Transition Equations 
%
% Simulate transition equations. The |simulate| command does not do
% anything with reporting equations. The output database, |s|, does not
% include any of the variables created in reporting equations.

s = simulate(m, d, startDate:endDate, 'AppendPresample=', true)


%% Add Initial Conditions for Reporting Equations
%
% Before running the reporting equations, create time series with the
% necessary initial conditions. Use the output database from the previous
% simulation as an input database into the reporting equations. The
% reporting variables |a| and |b| occur with lags in reporintg equations, 
% so they need to be supplied starting values. Also, the variable or
% constant |c| on the right-hand side of the last reporting equation needs
% to be assigned in the input database, too.

s.a = Series(startDate-1, 0.776);
s.b = Series(startDate-1, 0.569);
s.c = 1.1;

s

%% Run Reporting Equations 
%
% Finally, run the reportng equations using the |reporting| command, with
% the model object as its first input argument. This command has exactly
% the same syntax as |rpteq/run| described in the other tutorial files.

s = reporting(m, s, startDate:endDate, 'AppendPresample=', true)

s.growth
s.a
s.b

% ...
%
% Alternatively, retrieve the |rpteq| object from the model object using
% the |get(~)| command, and run the reporting equations using the |run(~)|
% command on it, exactly the same way as in the |rpt_directly_in_mfile|.

q = get(m, 'rpteq');

s1 = run(q, s, startDate:endDate, 'AppendPresample=', true)

s1.growth
s1.a
s1.b

maxabs(s, s1)

