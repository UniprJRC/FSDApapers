function addDEP2path(DEProot)
%Add the folder DEProot to path
%
%  Required input arguments:
%
%  Optional input arguments:
%
%    DEProot:   path of the folder which contains this package. String.
%               A string containing the path which contains the root folder
%               of this package. The function works in both Windows and
%               Unix file systems.
%               Example - 'D:\home\ArticleReplicabilityCodes'
%               Data Types - char
%
%  Output:
%
%   Add a series of folders to the MATLAB search path
%
% More About:
%
% Function addDEP2path adds to path the following subfolders, which are necessary 
% to replicate the figures of the article.
%
% root of DEProot
% DEProot\mex       contains the c functions and the generated mex files
% DEProot\fsda      contains functions not strictly related to the article,
%                   taken from the FSDA toolbox
% DEProot\mc        contains the functions for the medcouple, taken from
%                   the LIBRA toolbox and other third parties.
% DEProot\robstat   contains robust routines used to demonstrate the
%                   efficiency of simpleselect and its weighted form
%
% In order to check that the previous folders have been added to path click
% on Home|Set Path
%
% Examples:
%
%{
%
       addDEP2path('/Users/perrodo/ufficio_1_ARTICOLI/fixedpivotSelect/ArticleReplicabilityCodes')
%
%      or
%
       addDEP2path('.')
%}

%{
        % The expression fileparts(which('addDEP2path.m')) locates the main
        % folder where this folder is installed
        addDEP2path(fileparts(which('addDEP2path.m')))
%}

%{
    % to find dependencies type:
   [fList1,pList1] = matlab.codetools.requiredFilesAndProducts('Figure1_NumberOfElemtaryOperation.m');
   [fList2,pList2] = matlab.codetools.requiredFilesAndProducts('Figure3_ComputationalTime.m');
   [fList3,pList3] = matlab.codetools.requiredFilesAndProducts('Figure4_FSM_MCD_TIME_testing.m');
   [fList4,pList4] = matlab.codetools.requiredFilesAndProducts('Figure5_W_check_obj.m');
   [fList5,pList5] = matlab.codetools.requiredFilesAndProducts('Figure5_W_check_position.m');
   [fList6,pList6] = matlab.codetools.requiredFilesAndProducts('Figure5_W_check_time.m');
   [fList7,pList7] = matlab.codetools.requiredFilesAndProducts('Table1_medc_test.m');
    fList1(:)
    fList2(:)
    fList3(:)
    fList4(:)
    fList5(:)
    fList6(:)
    fList7(:)

%}

%% Beginning of code

if nargin<1
    DEProot= fileparts(which('addDEP2path.m'));
end

f=filesep;


addp=[DEProot ';' ...
    DEProot f 'dep_mex;' ...
    DEProot f 'dep_fsda;' ...
    DEProot f 'dep_mc;' ...
    DEProot f 'dep_robstat;'];

path(addp,path);
try
    % disp('REMARK: Remember to save the added folders to path in the MATLAB window')
    % disp(['In the menu ' '''Home|Set path''' ' click on the button '  '''Save'''])
    % Save current path for future sessions
    savepath
catch
    warning('FSDA:addDEP2path:ReadOnly','Could not save modified path permanently.');
end

end
