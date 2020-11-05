%{
This program solves problems solving for the particular solution of Ax =
b, finding the inverse of a matrix, basis of the column space of a matrix, 
basis of the row space, and finding the row echelon form of a matrix.

Tian Dong, Abhinav Madduri, Aidan Hanna
%}

keywords = whichProgramToRun; %['inverse', 'solution', 'row space', 'row echelon', 'column space'];
if keywords(1,1) == "inverse"
    syms r n c t b d e R det f
    prompt = "Inverse: Enter a square matrix in brackets with spaces separating terms of the same line and semicolons between terms of seperate lines: ";
    A = input(prompt);
    A = isInputCorrect(A, prompt);
    %verifies squareness
    S = size(A);
    if S(1,1) == S(1,2)
        I = eye(S(1,1));
        a = [A I];
        %r=rank, hopefully
        r = S(1,1);
        %f is a surprise tool that will help us later
        f = 1;
        %Finds U, n=row c=column
        c = 1;
        while c < r 
            n = c+1;
            while n < r+1 
                t = a(n,c);
                b = a(c,c);
                a(n,:) = a(n,:)-t/b*a(c,:);
                n = n+1;
            end
            c = c+1;
        end
        %finds D
        while c > 0 
            n = c-1;
            while n > 0 
                t = a(n,c);
                b = a(c,c);
                a(n,:) = a(n,:)-t/b*a(c,:);
                n = n-1;
            end
            c = c-1;
        end
        %D -> I
        d = 1;
        while d < r+1 & f == 1
            e = a(d,d);
            if e == 0
                f = 0;
            end
            if e == Inf
                f = 0;
            end
            if e == -Inf
                f = 0;
            end
            if isnan(e)
                f = 0;
            end
            e = 1/e;
            a(d,:) = e*a(d,:);
            d = d+1;
        end
        %f ==0 if determinant == 0
        if f == 0
            disp("There is no inverse")
        else
            if f == 1
            inverse = a(:,r+1:2*r)
            end
        end
    %for if Mr. Smith doesn't follow instructions
    else
        disp('That matrix is not square')
    end
end
if keywords(1,2) == "solution"
    prompt1 = 'Please enter matrix A (in Ax = b) in the format [r1v1, r1v2; r2v1, etc.]: ';
    A = input(prompt1);
    A = isInputCorrect(A, prompt1)

    prompt2 = 'Please enter matrix b (in Ax = b) in the same format as A with the same number of rows as A: ';
    b = input(prompt2);
    b = isInputCorrect(b, prompt2)

    [e,f] = size(A);
    [g,h] = size(b);

    if e ~= g
        disp('The number of rows in A does not match the number of rows in b!')
        disp('Try again!')
    else
        C = [A,b];
        C = rowEchelon(C);
        D = C(:,1:f);
        B = C(:,f + 1:f + h);
        if findRankOfEchelon(D) < findRankOfEchelon(B)
            disp('There is no solution.');
        else 
            x = A\b
        end
    end
end
if keywords(1,3) == "row space"
    syms m n M N tot zerows rank free zeroc ccount

    prompt = 'Row Space: Enter a matrix in brackets with spaces separating terms of the same line and semicolons between terms of seperate lines: ';
    A = input(prompt);
    A = isInputCorrect(A, prompt);
    A = rowEchelon(A);
    r = findRankOfEchelon(A);
    
    BasisOfRowSpace = A(1:r, :)
end
if keywords(1,4) == "row echelon"
    prompt1 = 'Row Echelon: Please enter matrix A in the format [r1v1, r1v2; r2v1, etc.]: ';
    A = input(prompt1);
    A = isInputCorrect(A, prompt1);
    A = rowEchelon(A)
end
if keywords(1,5) == "column space"
    syms m n M N tot zerows rank free zeroc ccount

    prompt = 'Column Space: Enter a matrix in brackets with spaces separating terms of the same line and semicolons between terms of seperate lines: ';
    A = input(prompt);
    A = isInputCorrect(A, prompt);
    B = A;
    A = rowEchelon(A);
    S = size(A);

    M = S(1,1);
    N = S(1,2);

    %finds rows of all 0 aka "zerows"
    m = 1;
    zerows = 0;
    while m < M+1
        tot = 0;
        n = 1;
        while n < N+1 & tot == 0
            tot = tot+A(m,n);
            n = n+1;
        end
        if tot == 0
            zerows = zerows+1;
        end
        m = m+1;
    end
    zerows;

    rank = M-zerows;
    free = N-rank;

    %column space 
    cs = zeros(M,N);
    ccount = 0;
    n = 1;
    %finds pivots by ignoring 0 columns
    while n < N+1
        tot = 0;
        m = 1;
        while m < M+1 & tot == 0
            tot = tot+A(m,n); 
            m = m+1;
        end
        %counts and finds nonzero columns
        if tot ~= 0
            if ccount == 0
                cs = B(:,n);
            elseif ccount < rank
                cs = [cs B(:,n)];
            end
            ccount = ccount+1;
            A(ccount,:) = zeros(1,N);
        end
        n = n+1;
    end
    BasisOfColumnSpace = cs
end

disp('Sources:')
disp('"Prompt." Request User Input - MATLAB, www.mathworks.com/help/matlab/ref/input.html.')
disp('"Function." Create Functions in Files - MATLAB & Simulink, www.mathworks.com/help/matlab/matlab_prog/create-functions-in-files.html.')
disp('"For." Execute Statements If Condition Is True - MATLAB If Elseif Else, www.mathworks.com/help/matlab/ref/if.html.')
disp('"Break." Loop to Repeat Specified Number of Times - MATLAB, www.mathworks.com/help/matlab/ref/for.html.')
disp('"How to Create a Matrix from a Part of Another Matrix?" How to Create a Matrix from a Part of Another Matrix? - MATLAB Answers - MATLAB Central, www.mathworks.com/matlabcentral/answers/153950-how-to-create-a-matrix-from-a-part-of-another-matrix.')
disp('"Logical Operators: Short Circuit." Loop to Repeat When Condition Is True - MATLAB, www.mathworks.com/help/matlab/ref/while.html.')

function x = rowEchelon(A)
    [m,n] = size(A);
    if m > n
        m = n;
    end
    
    i = 1;
    while i <= m
        A = eliminateColumn(A,i);
        i = i + 1;
    end
    x = A;
end

%A is the matrix, d is the column
function x = eliminateColumn(A,d)
    a = findFirstNonZeroRow(A, d);
    [m,~] = size(A);
    if a > d
        b = A(d,:);
        A(d,:) = A(a,:);
        A(a,:) = b;
    end
    while m > d
        if A(m,d) ~= 0 && A(d,d) ~= 0
            c = A(m,d)/A(d,d);
            A(m,:) = A(m,:) - c * A(d,:);
        end
        m = m - 1;
    end
    x = A;
end

function x = findFirstNonZeroRow(A, d)
    [m,~] = size(A);
    i = d;
    % keeps counting until the index does not equal 0
    while A(i,d) == 0
        i = i + 1;
        if i > m
            break
        end
    end
    if i > m
        i = -1;
    end
    x = i;
end

function x = findRankOfEchelon(A)
    [m,n] = size(A);
    if m > n
        m = n;
    end
    
    %keeps counting until the index is not equal to 0
    while A(m,n) == 0 && m > 0
        m = m - 1;
        if m < 1
            break
        end
    end
    x = m;
end

function x = isInputCorrect(y, prompt)
    prompt2 = 'Is this what you entered (this is a yes or no question)? ';
    disp(y)
    str = input(prompt2, 's');
    if contains(str, 'n')
        x = input(prompt);
        isInputCorrect(x, prompt);
    elseif contains(str,'y')
        x = y;
    else
        disp('This is a yes or no question! (Please answer yes or now)');
        x = isInputCorrect(y,prompt);
    end
end

function keys = whichProgramToRun
    prompt = 'What would you like to find? ';
    str = input(prompt, 's');
    keywords = ["inverse", "solution", "row space", "row echelon", "column space"];
    keys = strings(1,length(keywords));
    options = "";
    for n = 1:length(keywords)
        word = keywords(n);
        if contains(word, str)
            keys(n) = word;
        else
            keys(n) = ' ';
        end
        options = options + '"' + word + '",  ';
    end
    options = char(options);
    options = options(1:end-3);
    if ~max(contains(keywords, str))
        disp("Please use one of the keywords: " + options + "!")
        keys = whichProgramToRun;
    end
end