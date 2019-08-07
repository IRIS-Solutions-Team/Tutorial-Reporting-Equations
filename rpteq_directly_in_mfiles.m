%% Reporting Equations Directly in M-Files 
% 
% Creating an |rpteq| object directly in an m-file or command
% prompt is the most straightforward way. The reporting equations
% can be then executed immediately, after you create an input
% database with all necessary initial conditions and other
% variables and constants occuring on the RHS of the reporting
% equations.


%% Clear Workspace 

close all
clear
%#ok<*NOPTS>


%% Write Reporting Equations 
%
% Throughout the tutorial, we use the same three reporting equations:
%
%     growth = 100*(y/y{-1}-1);
%     a = c * a{-1}^0.8 * b{-1}^0.2 * exp(e);
%     b = sqrt(b{-1});
%
% Write the equations in a |rpteq| object as a cell array of strings.
% The left-hand side of each equation needs to be the name of a variable
% with no lag or lead. Each equation needs to be ended with a semicolon.
% The right-hand side can include any kind of expression, referring to LHS
% variables, their lags and lead, and other variables. Neither LHS
% variables nor RHS variables are declared in an |rpteq| object.

q = rpteq( { '"Growth" growth = 100*(y/y{-1}-1);', ...
             'a = c * a{-1}^0.8 * b{-1}^0.2 * exp(e);', ...
             'b = sqrt(b{-1});' } );

%% Create Input Database 
%
% The three reporting equations have some lags of LHS variables on the RHS, 
% |a{-1}| and |b{-1}|, as well as some other names, |y|, |e|, |c|. All
% these must be supplied in an input database created or existing before
% the |rpteq| object is evaluated. Note that we don't have to supply the
% variable |growth| in the input database. It will be created and evaluated
% on the fly.

startDate = qq(2010, 1);
endDate = qq(2011, 4);

d = struct( );
d.y = 10+Series(startDate-1:endDate, @rand);
d.a = Series(startDate-4:startDate-1, 0.776);
d.b = Series(startDate-4:startDate-1, 0.569);
d.e = Series(startDate:endDate, @randn)*0.5;
d.c = 1.1;

%% Evaluate Reporting Equations 
%
% Call the |run| command to evaluate the reporting equations. The equations
% are evaluated one by one, period by period, i.e. in the following order
%
% # first equation, first period, 
% # second equation, first period, 
% # third equation, first period, 
% # first equation, second period, 
% # second equation, second period, 
% # third equation, second period, ..., etc.
%
% By default, the output database, |d1|, only contains values for LHS
% variables on the evaluation range, |startDate:endDate|, plus all
% necessary lags and leads (depending on the occurence of lags and leads of
% the LHS variables on the RHS of the reporting equations). This means that
% |growth| is returned only for |startDate:endDate|,  while |a| and |b| are
% returned for |startDate-1:endDate|. Any other values supplied in the
% input database for these variables will be simply discarded; see options
% |AppendPresample=| and |AppendPostSample=| in the next section to change
% this behavior.

d1 = run(q, d, startDate:endDate)

d1.growth 
d1.a 
d1.b 


%% Control Contents of Output Database 
%
% Use the following options to control the contents of the output database
% returned by the |run(~)| command:
%
% * |AppendPresample=| and/or |AppendPostsample| when set to |true| add
% pre-sample and/or post-sample values from the input database to the output
% database; this is similar to the same options in |model/simulate|. Note
% the difference between |d1.a| and |d2.a|: the latter includes values
% prior to |startDate-1| (the same for |d1.b| and |d2.b|).
%
% * |Fresh=| when set to |true| causes the output database to include only
% time series for LHS variables; all other entries found in the input
% database will be discarded. The output database |d3| hence does not
% include |y|, |e| or |c|.

d2 = run(q, d, startDate:endDate, 'dbOverlay=', true)
d2.a
d2.b

d3 = run(q, d, startDate:endDate, 'fresh=', true)


%% Save Input and Output Data for Further Use 

save rpteq_directly_in_mfiles.mat d d1 d2 d3 startDate endDate

