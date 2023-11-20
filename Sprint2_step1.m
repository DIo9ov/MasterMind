game(1:250) = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);
choice=-1;
while (choice~=0)

    disp("1. Display list of games");
    disp("2. Remove game");
    disp("3. Play game");
    disp("0. Exit");
    
    choice=input("Choose 1-3 or 0: ");
    % switch choice:
    %     1 %place for ur function
    %     2 %place for ur function
    %     3 function game=play(game);
    % end

end 
