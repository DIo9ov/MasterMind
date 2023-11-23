clc
clear
%function expects game structure which stores previous turns and current
%turn data in an array with subfields guess for the player input(every number stored separately),
% win thatcontains the status of the game, black for number of black peg feedback
%and same for white


function displayGame(game)

turn=game.nGuesses;
win=verifyCode(game);%%works only if verifyCode function returns either a one or a zero 

clc

    fprintf("*\t*\t*\t*\t--\tbk\twh\n")

    for i=1:1:turn
        fprintf("%i\t%i\t%i\t%i\t--\t%i\t%i\n",game.board(i,1),game.board(i,2) ...
            ,game.board(i,3),game.board(i,4),game.board(i,5),game.board(i,6))
    end

    if win==1
        score=110-turn*10;
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
        fprintf("Congratulations! Your score is %i",score)
    elseif win==0 && turn==10
        fprintf("You ran out of guesses and lost the game, the secret code was %i",game.secretCode)
    else
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
    end

end
