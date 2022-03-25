function [kE , nuOP , nuFor , AModified] = quickselectDIVAnalysis(A,n,k)

%  This function modifies quickselectFS in order to store the number of
%  elementary operations. It is called by other functions. We consider as
%  elementary operations:

%   1. Assignment,
%   2. Comparison,
%   3. Array Access,
%   4. Mathematical Operations:
%      4.1 Additions/Subtractions,
%      4.4 Divisions.
%   5. Swap
%   6. All: #1+#2+#3+#4.

nuOP(1)=0;
nuOP(2)=0;
nuOP(3)=0;
nuOP(4)=0;
nuOP(5)=0;
nuOP(6)=0;
 
% We also store the number of iteration inside the "for"
% cycle and then the number of "while' execution.
nuFor=[];
iFor=1;

left=1;
right=n;
position=-1;

% Store and return the vector A modify by the algorithm.
AFinal=[];

% #assignment
nuOP(1)=nuOP(1)+3;
% -----------------

while (position~=k)           % (left < right) && (position~=k)
    
    % #comparison
      nuOP(2)=nuOP(2)+1;      % +2
    % -----------------
    
    % The logical operation "and" is (=~) equivalent to addition
    % operations.
    % #mathematical operations
    nuOP(4)=nuOP(4)+1;
    % -----------------
    
    pivot=A(k);
   
    A(k)=A(right);
    A(right)=pivot;
    % #array access
    nuOP(3)=nuOP(3)+4;
    % -----------------
    % #assignment
    nuOP(1)=nuOP(1)+3;
    % -----------------
    % #swap
    nuOP(5)=nuOP(5)+1;
    % -----------------
    
    position=left;
    % #assignment
    nuOP(1)=nuOP(1)+1;
    % -----------------
       
    for i=left:right
        
        if(A(i)<pivot)
            buffer=A(i);
            A(i)=A(position);
            A(position)=buffer;
            % #array access
            nuOP(3)=nuOP(3)+4;
            % -----------------
            % #assignment
            nuOP(1)=nuOP(1)+3;
            % -----------------
            % #swap
            nuOP(5)=nuOP(5)+1;
            % -----------------
            
            position=position+1;
            % #mathematical operations
            nuOP(4)=nuOP(4)+1;
            % -----------------
        end
        % #array access
          nuOP(3)=nuOP(3)+1;
        % -----------------
        % #comparison
          nuOP(2)=nuOP(2)+1;
        % -----------------
    end
    % for (i=left; i<=rigth; i=i+1)
    % #assignment
    nuOP(1)=nuOP(1)+1;
    % -----------------
    % #comparison
    % nuOP(2)=nuOP(2)+ (right-left); % I'm not shure!!!
    % -----------------
    % #mathematical operations
    nuOP(4)=nuOP(4)+ (right-left);
    % -----------------
    
    % Count the number of cycle 'for' execution (the length of nuFor)
    % and the number of iteration for each 'for' execution.
    nuFor(iFor)=(right+1)-left;
    iFor=iFor+1;
    
    A(right)=A(position);
    A(position)=pivot;
    % #array access
    nuOP(3)=nuOP(3)+3;
    % -----------------
    % #assignment
    nuOP(1)=nuOP(1)+2;
    % -----------------
    % #swap
    nuOP(5)=nuOP(5)+2/3;
    % -----------------
    
    if  (position < k)
        left  = position + 1;
        % #mathematical operations
        nuOP(4)=nuOP(4)+1;
        % -----------------
    else
        right = position - 1;
        % #mathematical operations
        nuOP(4)=nuOP(4)+1;
        % -----------------
    end
    % #comparison
    nuOP(2)=nuOP(2)+1;
    % -----------------
end

% #mathematical operations
nuOP(4)=nuOP(4)+1;
% -----------------

% Some usefull information ...
% disp (' ');
% disp ([num2str(left) '  ' num2str(right)]);
% disp (' ');
% disp ([num2str(position) '  ' num2str(k)]);
% disp (' ');
  AModified=A;

kE=A(k);
% #array access
nuOP(3)=nuOP(3)+1;
% -----------------
% #assignment
nuOP(1)=nuOP(1)+1;
% -----------------

% Remouve (eventual) decimal fro number of swapping.
nuOP(5)=ceil(nuOP(5));

% #ALL
nuOP(6)=nuOP(1)+nuOP(2)+nuOP(3)+nuOP(4);
% -----------------


