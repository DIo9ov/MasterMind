clc
clear

%missing functionality loading games 
%take vector of games from aula to avoid playing hundreds
%code verifyer moras provjerit
%provjeri koje input variables uzima koja funkcija


game_base = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);

run=1;

nGames=0;
vGames=repmat(game_base,1,250); %figure out a way to preallocate without using repmat function 
user_input="sth";

% loading(); - added file for tasting
while run==1

    menu(1);
    % Fixing error of unintentional enter press------
    while(user_input~="0" && user_input~="1" && user_input~="2" && user_input~="3") 
        user_input=input("","s");
    end
    user_input=str2num(user_input);
    % ----------
    switch user_input

        case 1 %display list of games
            if nGames==0
                fprintf("Sorry there are currently no games loaded.\n\n")
            else
                list_Games(vGames,nGames)
            end

        case 2 %remove game
            if nGames==0
                fprintf("Sorry there are currently no games loaded.\n\n")
            else
                menu(2,nGames)
                game_remove_number=input("");
                vGames=removeGame(vGames,game_remove_number,game_base);
                nGames=nGames-1;
            end

        case 3 %play game
            if nGames<=250
                nGames=nGames+1;
                vGames(1,nGames)=play(game_base);%currently only stores played games one after another might not work for all cases 
            else
                fprintf("Sorry the maximum number of games is already loaded. \n\n")
            end

        case 0
            fprintf("\nThank you for playing the game!")
            run=0;
    end
user_input="sth";
end


function secretCode = generateSecretCode()%check if storing secret code as single number and not array is more favorable

    bag=[1,2,3,4,5,6];

    for i=1:4
        n=randi(7-i);
        secretCode(i)=bag(n);
        bag(n)=[];
    end

    %secretCode=secretCodeV(1)*1000+secretCodeV(2)*100+secretCodeV(3)*10+secretCodeV(4);
    %if uncommented change secretCode(i)=bag(n) to secretCodeV(i)=bag(n)

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
    score=game.score;
    if score~=0
        win=1;
    else 
        win=0;
    end
    
    clc

    fprintf("*\t*\t*\t*\t--\tbk\twh\n")

    for i=1:1:turn
        fprintf("%i\t%i\t%i\t%i\t--\t%i\t%i\n",game.board(i,1),game.board(i,2) ...
            ,game.board(i,3),game.board(i,4),game.feedback(i,1),game.feedback(i,2))
         % disp(game.secretCode); %For test, dont touch
    end

    if win==1
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
        fprintf("Congratulations! Your score is %i\n",game.score)
    elseif win==0 && turn==10
        fprintf("You ran out of boardes and lost the game :(\n")%add functionality to display real code if user has not guessed it
    else
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
    end

end


function game=play(game_base)
    
    game=struct(game_base);
   % game.feedback=5*ones(10,2);
    i=1;
    comp=false;
    game.secretCode = generateSecretCode();

    %game.Secretcode=secretCode; %Copy into structure
    trouble_enter="sth";
    while i<=10 && comp==false
        for j=1:4
            fprintf("Position %i\n",j)
            % Fixing error of unintentional enter press------
            while(trouble_enter~="1" && trouble_enter~="2" && trouble_enter~="3" &&...
                    trouble_enter~="4" && trouble_enter~="5" && trouble_enter~="6") 
              trouble_enter=input("Enter your board(numbers between 1 and 6):","s");
            end
            game.board(i,j)=str2num(trouble_enter);
            trouble_enter="sth";
            % -----
        end
        [white,black] = verifyCode(game.secretCode,game.board(i,:));
        game.feedback(i,1)=black;
        game.feedback(i,2)=white;

        if  game.board(i,:)==game.secretCode
            comp=true;
            game.score=110-10*i;
        end
        game.nGuesses=i;
        displayGame(game);
        i=i+1;
    end
    
    displayGame(game)

end


function vGames = removeGame(vGames,game_remove_number,game_base)

    for i=game_remove_number:1:(249)
        vGames(i)=vGames(i+1);
    end

    vGames(250)=game_base;

end


function menu(menu_numr,nGames)

    switch menu_numr
        case 1
            fprintf("1.Display list of games \n2.Remove game \n3.Play game \n0.Exit\n")
        case 2
            fprintf("Enter the number of the game (1-%i) you want to remove: ",nGames)
        case 3
        case 4
    end

end


function list_Games(vGames,nGames) %might be janky requires further scrutinizing

    % displays secret code, number of guesses and score
    for i=1:1:nGames
        code=vGames(i).secretCode(1)*1000+vGames(i).secretCode(2)*100+vGames(i).secretCode(3)*10+vGames(i).secretCode(4);
        guesses=vGames(i).nGuesses;
        score=vGames(i).score;
        fprintf("--GAME NUMBER %i: \nThe code was:%i \nThe number of guesses:%i \nThe score was:%i \n",i,code,guesses,score)
    end

end

% Testing with external file of games-------------------
% function loading()
%     load('gamesInitialization.mat','gamesInit','nGamesInit')
%     for k=1:nGamesInit
%         games(k)=gamesInit(k)
%     end
% 
% 
%     list_Games(games, nGamesInit);
% end
% ----------------------------
