clc
clear
board=zeros(10,4);
displayboard(board);

function secretCode = generateSecretCode ()
bag=[1,2,3,4,5,6];
for i=1:4
    n=randi(7-i);
    secretCode(i)=bag(n);
    bag(n)=[];
end
end


function [white,black] = verifyCode(secretCode,guess)
i=1;
black=0;
white=0;
while i<=4
    j=1;
    rep=false;
    while (j<=4) && (rep==false)
        if i~=j
            if secretCode(i)==guess(j)
                rep=true;
                white=white+1;
            end
        else
            if secretCode(i)==guess(j)
                rep=true;
                black=black+1;
            end
        end
        if rep==false
            
            j=j+1;
        end
    end
    i=i+1;
end
display(white);
display(black);
end

function functionboard=displayboard(board)
    feedback=5*ones(10,2);
    i=1;
    comp=false;
    secretCode = generateSecretCode ()
    while i<=10 && comp==false
        for j=1:4
            fprintf("position %i\n",j)
            board(i,j)=input('enter your guess(numbers between 1 and 6):');
        end
        [white,black] = verifyCode(board(i,:),secretCode);
        feedback(i,1)=black;
        feedback(i,2)=white;
        for y=1:10
            if y==1
                fprintf("*\t*\t*\t*\t--\tbk\twh\n");
            end
            for x=1:7
                if x<=4
                    if board(y,x)==0
                    fprintf("_\t");
                    else 
                    fprintf("%i\t", board(y,x));
                    end   
                elseif x==5
                    fprintf("--\t");
                elseif x==6 && feedback(y,x-5)~=5
                    fprintf('%i\t',feedback(y,x-5))
                elseif x==7 && feedback(y,x-6)~=5
                    fprintf('%i\t',feedback(y,x-5))
                else
                   fprintf("_\t");
                end
            end
            fprintf("\n");
        end

        if  board(i,:)==secretCode
            comp=true;
        end
        score=110-10*i;
        i=i+1;
    end
    fprintf('Congratulations! Your score is %i\n',score)
end