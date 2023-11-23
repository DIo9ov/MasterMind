clc
clear
%function expects game structure which stores previous turns and current
%turn data in an array with subfields guess for the player input(every number stored separately),
% win thatcontains the status of the game, black for number of black peg feedback
%and same for white
function displayGame(game)

turn=length(game);
win=game(turn).win;

clc

    fprintf("*\t*\t*\t*\t--\tbk\twh\n")

    for i=1:1:turn
        fprintf("%i\t%i\t%i\t%i\t--\t%i\t%i\n",game(i).guess(1),game(i).guess(2) ...
            ,game(i).guess(3),game(i).guess(4),game(i).black,game(i).white)
    end

    if win==1
        score=110-turn*10;
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
        fprintf("Congratulations! Your score is %i",score)
    elseif win==0 && turn==10
        fprintf("You ran out of guesses and lost the game :(")
    else
        for i=turn:1:10
            fprintf("-\t-\t-\t-\t--\t-\t-\n")
        end
    end

end

