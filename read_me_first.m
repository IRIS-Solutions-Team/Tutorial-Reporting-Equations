%% Reporting Equations 
%
% Reporting equations are an easy way how to evaluate a
% collection of explicit sequential equations. Sequential means
% that the equations can be evaluated one after another, with no
% simultaneity feedback. Explicit means that a right-hand-side
% expression is assigned directly to left-hand side variable.
%
% Reporting equations can be created in three different ways: (i)
% as an `rpteq` object directly within an m-file or command
% prompt, (ii) as an `rpteq` object created by reading a separate
% file describing the equations, or (iii) as
% `!reporting-equations` in model files. This tutorial shows how
% to create and run reporting equations in all three ways.


%% Reporting Equations Directly in M-Files 
% 
% Creating an `rpteq` object directly in an m-file or command prompt is the
% most straightforward way. The reporting equations can be then executed
% immediately, after you create an input database with all necessary
% initial conditions and other variables and constants occuring on the RHS
% of the reporting equations.

% edit rpteq_directly_in_mfiles.m
rpteq_directly_in_mfiles


%% Reporting Equations in Separate File 
%
% Saving reporting equations in a separate text file, and creating `rpteq`
% objects based on such text files is a convenient option if you, for
% example, have a large number of equations that are used multiple times in
% different places. Otherwise, there is absolutely no difference in how to
% work with an `rpteq` object created directly or from a separate file.

% edit rpteq_in_separate_file.m
rpteq_in_separate_file


%% Reporting Equations in Model File 
%
% Reporting equations can be included in a model file, under the heading
% `!reporting_equations`. The is convenient when you need to calculate and
% report a number of variables that are transformations of some other model
% results but do not feed back into the model. Reporting equations are
% mostly treated separately from the rest of the model: for example, the
% reporting equations are not evaluated within a `simulate` command but
% need to be run using the `reporting` command.

% edit rpteq_in_model_file.m
rpteq_in_model_file

