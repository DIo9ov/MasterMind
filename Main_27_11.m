clc
clear
%board=zeros(10,4);



game = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);

game=play(game);




function secretCode = generateSecretCode ()
bag=[1,2,3,4,5,6];
for i=1:4
    n=randi(7-i);
    secretCode(i)=bag(n);
    bag(n)=[];
end
end


function [white,black] = verifyCode(secretCode,board)
i=1;
black=0;
white=0;
while i<=4
    j=1;
    rep=false;
    while (j<=4) && (rep==false)
        if i~=j
            if secretCode(i)==board(j)
                rep=true;
                white=white+1;
            end
        else
            if secretCode(i)==board(j)
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


function displayGame(game)

turn=game.nGuesses;
if game.score~=0
    win=1;
else 
    win=0;
end
clc

    fprintf("*\t*\t*\t*\t--\tbk\twh\n")

    for i=1:1:turn
        fprintf("%i\t%i\t%i\t%i\t--\t%i\t%i\n",game.board(i,1),game.board(i,2) ...
            ,game.board(i,3),game.board(i,4),game.feedback(i,1),game.feedback(i,2))
    end

    if win==1
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
        fprintf("Congratulations! Your score is %i",game.score)
    elseif win==0 && turn==10
        fprintf("You ran out of boardes and lost the game :(")
    else
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
    end

end


function game=play(game)
   % game.feedback=5*ones(10,2);
    i=1;
    comp=false;
    game.secretCode = generateSecretCode ()
    
    %game.Secretcode=secretCode; %Copy into structure

    while i<=10 && comp==false
        for j=1:4
            fprintf("position %i\n",j)
            game.board(i,j)=input('enter your board(numbers between 1 and 6):');
        end
        [white,black] = verifyCode(game.board(i,:),game.secretCode);
        game.feedback(i,1)=black;
        game.feedback(i,2)=white;
      
        
        %displayGame(game); same ->
        
        % for y=1:10
        %     if y==1
        %         fprintf("*\t*\t*\t*\t--\tbk\twh\n");
        %     end
        %     for x=1:7
        %         if x<=4
        %             if board(y,x)==0
        %             fprintf("_\t");
        %             else 
        %             fprintf("%i\t", board(y,x));
        %             end   
        %         elseif x==5
        %             fprintf("--\t");
        %         elseif x==6 && feedback(y,x-5)~=5
        %             fprintf('%i\t',feedback(y,x-5))
        %         elseif x==7 && feedback(y,x-6)~=5
        %             fprintf('%i\t',feedback(y,x-5))
        %         else
        %            fprintf("_\t");
        %         end
        %     end
        %     fprintf("\n");
        % end
        % 
       
        
        if  game.board(i,:)==game.secretCode
            comp=true;
            game.score=110-10*i;
        end
        game.nGuesses=i;
        displayGame(game);
        i=i+1;
    end
end