game(1:250) = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);

choice="ddz";
nGames=1;

while (choice~="0")

    disp("1. Display list of games");
    disp("2. Remove game");
    disp("3. Play game");
    disp("0. Exit");
    
    % Avoding unwanted input (remark 2.3.1)
    % if choice==char(0a)
    %     choice=-1;
    % end
    while(choice~="0" && choice~="1" && choice~="2" && choice~="3") 
        choice=input("Choose 1-3 or 0: ","s");
    end
    
    switch choice
        case "1"
          % place for ur function
        case "2"
          % place for ur function
        case "3"
          if(nGames<=250)
               % game(nGames).secretCode=generateSecretCode();
               % play(game(1,nGames));
          disp("Hi");
          end 
    end
    
    % Checking choice=0 (exit), otherwise it will run inf -> remark 2.3.1
    if choice~="0"
        choice="ddz";
    end

end 
