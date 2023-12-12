%Group 46-02
%Ivan Krajtmajer - 100508010
%Lucas González - 100522090
%Dimiter Ionov - 100506562
%Raul Flores Garcia - 100521942

clc
clear



player_base=struct('playerId',0,'name',"name",'surname',"surname",'nGames',0,'score',0);

game_base = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);

run=1;
nGames=0;
nPlayers=0;

maxPlayers=50;
players(1,maxPlayers) = struct('playerId',0,...
                'name','',...
                'surname','',...
                'nGames',0, ...
                'score',0);
maxGames=250;
games(1:maxGames) = struct('nGuesses',0,...
        'secretCode',[0 0 0 0],...
        'playerId',0,...
        'board', zeros(10,4),...
        'feedback',zeros(10,2),...
        'score',0);

gamesplayer(1:maxGames) = struct('nGuesses',0,...
        'secretCode',[0 0 0 0],...
        'playerId',0,...
        'board', zeros(10,4),...
        'feedback',zeros(10,2),...
        'score',0);

id=1;
Id=0;
Id_pass=0;
counter=1;

%loads gama data when testing
load('gamesInitialization.mat','gamesInit','nGamesInit')
nGames=nGamesInit;
for i=1:nGames
    games(i)=gamesInit(i);
end


load('playersInitialization.mat','playersInit','nPlayersInit')
nPlayers=nPlayersInit;
for i=1:nPlayers
    players(i)=playersInit(i);
end
%% 

while run==1

    user_input=menu(1); 
    switch user_input

        case 1 %Player management
            %management case 2
            
            [players, nPlayers,sortedPlayers] = managePlayers (players,nPlayers,maxPlayers);
                        
        case 2 %Game management
            if nGames==0
                clc
                fprintf("Sorry there are currently no games loaded.\n\n")
            else
                clc
                [games,nGames] = manageGames(games,nGames,players);
            end

        case 3 %play game
            if nGames<250
                nGames=nGames+1;

%Conecting players with their games---------------
    % Checking the user's id
                while Id_pass==0
                    fprintf("Enter player Id before starting game:\n");
                    Id=input("Your ID?: ");
                    
                    for i=1:50
                        if players(1,i).playerId==Id
                            Id_pass=1;
                        end
                    end

                    if Id_pass==0
                        fprintf("The player Id you entered is not valid! You can:\n");
                        fprintf("1)Manage players\n");
                        fprintf("2)Go back to the main menu\n");
                        fprintf("3)Enter another Id\n");
                        option=input("");
                        
                        switch option
                            case 1
                                [players, nPlayers,sortedPlayers] = managePlayers (players,nPlayers,maxPlayers);
                            case 2
                                Id_pass=2;
                            case 3
                                Id_pass=0;
                                fprintf("\n")
                        end
                    end
                end

                if Id_pass~=2
                    clc
                    games(1,nGames)=play(game_base);%currently only stores played games one after another might not work for all cases
                    games(1,nGames).playerId=Id;
                    players(1,Id).nGames=players(1,Id).nGames + 1;
                    players(1,Id).score=players(1,Id).score + games(1,nGames).score;
                end
                Id_pass=0;
            
            else
                fprintf("Sorry the maximum number of games is already loaded. \n\n")
            end
% --------------------
        case 0
            fprintf("\nThank you for playing the game!")
            run=0;
            %these lines are for storing the data
            fileName='games.mat';
            save(fileName,'games'); 
            fileName='players.mat';
            save(fileName,'players');
    end

end

%-------all functions---------
%menus  

function option=menu(menu_numr,nGames)

    switch menu_numr
        case 1
            
            option=menuMain();
            % fprintf("1.Player management \n2.Game management \n3.Play game \n0.Exit\n")
        case 2 %when game management called
            
            option = menuGames();
            % fprintf("1.Remove games \n2.Display games \n0.Exit \n")
        case 3 % when remove games called
            clc
            fprintf("Enter the number of the game (1-%i) you want to remove: ",nGames)
        
        case 4 %when player management called
            option=menuPlayers();
            % fprintf("1.Enter new player \n2.Display list of players \n3.Display ranking of players \n4.Display top players \n0.Exit\n")
    end

end

%Menus and options--------------
function option=menuMain()
    fprintf ('*****************************************\n');
    fprintf ('myMasterMind: \n');
    fprintf ('*****************************************\n');    
    fprintf ('\t 1. Player management\n');
    fprintf ('\t 2. Game management\n');
    fprintf ('\t 3. Play game\n');
    fprintf ('\t 0. Exit\n');   
    fprintf ('\n');
    option=input ('Enter selection: ');
    fprintf ('\n');
end

function option = menuGames()
    
    % to avoid overwriting previous results with menu
    keyPress=input('Press enter to see menu...'); 
    fprintf("\n");
    fprintf ('*****************************************\n');
    fprintf ('myMasterMind: Game management\n');
    
    fprintf ('\t 1. Display list of games\n');
    fprintf ('\t 2. Remove game\n');
    fprintf ('\t 3. Display all games played by an ID\n');%
    fprintf ('\t 0. Back\n');
    
    fprintf ('\n\n');
    option=input ('Enter selection: ');
    fprintf ('\n');
end

function option=menuPlayers()
    
    % to avoid overwriting previous results with menu
    keyPress=input('Press enter to see menu...'); 
    fprintf("\n");
    % display menu
    fprintf ('*****************************************\n');
    fprintf ('myMasterMind: Player management\n');
    fprintf ('*****************************************\n');    
    fprintf ('\t 1. Enter new player\n');
    fprintf ('\t 2. Display list of players\n');
    fprintf ('\t 3. Display ranking of players\n');
    fprintf ('\t 4. Display top players\n');
    fprintf ('\t 0. Back\n');   
    fprintf ('\n');
    % get user selection
    option=input ('Enter selection: ');
    fprintf ('\n');
end
%-----------------------

%game management functions
function [games,nGames,players] = manageGames(games,nGames,players) % the main one that utilizes the other two
counter=1;
    flag=0;
    while flag==0 %flag keeps manage games running until user enters 0
        
        user_input2=menu(2);
                    
        if user_input2==2 && nGames~=0
            menu(3,nGames)
            game_remove_number=input("");
            [games,players]=removeGame(games,game_remove_number,players); 
            nGames=nGames-1;
    
        elseif user_input2==2 && nGames==0
            fprintf("Sorry there are currently no games loaded.");
        
        elseif user_input2==1 && nGames~=0
            displayGamesList(games,nGames)
        
        elseif user_input2==1 && nGames==0
            fprintf("Sorry there are currently no games loaded.");
        elseif user_input2==3 && nGames~=0 %lists all games from player of id
            Id=input("What is the ID?: ");
            playerGames(Id,players,nGames,games)

        elseif user_input2==3 && nGames==0
            disp("Sorry, there are currently no games loaded.");

        elseif user_input2==0
            flag=1;
        end
    
    end

end

function playerGames(Id,players,nGames,games)%makes temporary variable with all games from one player and then displays that list of games

  games_of_player=struct('nGuesses',0, ...
      'secretCode',[0 0 0 0], ...
      'playerId',zeros(1,players(1,Id).nGames), ...
      'board', zeros(10,4), ...
      'feedback',zeros(10,2), ...
      'score',zeros(1,players(1,Id).nGames));

    for z=1:1:(players(1,Id).nGames)
       games_of_player(1,z)=struct('nGuesses',0, ...
      'secretCode',[0 0 0 0], ...
      'playerId',0, ...%
      'board', zeros(10,4), ...
      'feedback',zeros(10,2), ...
      'score',0); %
    end

    validId=0;
    switch Id
        case {players(1,:).playerId}
            counter=1;
            for k=1:1:nGames
                if games(1,k).playerId==players(1,Id).playerId
                    games_of_player(1,counter)=games(1,k);
                    counter=counter+1;
                end
            end

            fprintf("Name and surname of player:%s %s \n\n",players(1,Id).name,players(1,Id).surname)

            for i=1:1:(players(1,Id).nGames)
                fprintf("----GAME NUMBER %i----\n",i)
                %fprintf("The secrert code:%i
                %\n",games_of_player(1,i).secretCode) figure out how to
                %display secret code(optional)
                fprintf("The score:%i \n",games_of_player(1,i).score)
            end
            validId=1;
    end
    
    if validId==0
    
        fprintf("Sorry that is not a valid player Id. \n")

    end


end

function [games,players] = removeGame(games,game_remove_number,players)

    game_id=games(game_remove_number).playerId;
    game_points=games(game_remove_number).score;

    for i=game_remove_number:1:(249)
        games(i)=games(i+1);
    end

    new_number_of_games=players(game_id).nGames -1;
    players(game_id).nGames=new_number_of_games;
    
    new_points_of_player=players(game_id).score-game_points;
    players(game_id).score=new_points_of_player;

    games(250) = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);

end

function displayGamesList(games,nGames) %might be janky requires further scrutinizing

    % displays secret code, number of guesses and score
    for i=1:1:nGames
        code=games(i).secretCode(1)*1000+games(i).secretCode(2)*100+games(i).secretCode(3)*10+games(i).secretCode(4);
        guesses=games(i).nGuesses;
        score=games(i).score;
        fprintf("--GAME NUMBER %i:\n The code was:%i \nThe number of guesses:%i \nThe score was:%i \n",i,code,guesses,score)
    end

end

%player management functions
function[players, nPlayers,sortedPlayers] = managePlayers (players,nPlayers,maxPlayers)
    
    sortedPlayers=0;
    user_input_players=100;
    while user_input_players~=0
        % menu(4)
        user_input_players=menu(4);
        
            
            if user_input_players==1 && nPlayers>=maxPlayers
                fprintf("Sorry the maximum number of players is already loaded. \n")
            
            elseif user_input_players==1 && nPlayers<maxPlayers %enters new player is positions available
                players(nPlayers+1)=readPlayer(nPlayers+1);
                nPlayers=nPlayers+1;
            
            elseif user_input_players==2 %display list of players
                if nPlayers==0
                    clc
                    fprintf("Sorry there are currently no players loaded.\n\n")
                else
                    listPlayers(players,nPlayers)
                end

            elseif user_input_players==3 %display ranking of players
                if nPlayers==0
                    clc
                    fprintf("Sorry there are currently no players loaded.\n\n")
                else
                    listRankings(players,nPlayers)
                end

            elseif user_input_players==4 %display top 3 players
                if nPlayers==0
                    clc
                    fprintf("Sorry there are currently no players loaded.\n\n")
                else
                    flag=0;
                    while flag==0
                        top_players=input("Input the number of top players you want to list: ");
                        if top_players<=nPlayers
                            flag=1;
                        else
                            fprintf("Sorry there are only %i players loaded \n",nPlayers)
                        end
                    end
                    sortedPlayers=listPlayersRanked(players,nPlayers,top_players);
                end
            end
    end
end

function player=readPlayer(id)

    name=input("Input your name:","s");
    surname=input("Input your surname:","s");
    player=struct('playerId',id,'name',name,'surname',surname,'nGames',0,'score',0);

end

function displayPlayer(player)
    
    fprintf("\nName: %s \nSurname: %s,\nID: %i, \nNumber of games played: %i \nTotal score: %i\n",player.name,player.surname,player.playerId,player.nGames,player.score)

end

function listPlayers(players,nPlayer)
    for i=1:1:nPlayer
        fprintf("Player number %i: \n",i)
        displayPlayer(players(i))
    end
end

function sortedPlayers=listPlayersRanked(players,nPlayers,top_players)%rank players outside or in different function to make code more readable
    
    players_rankings=zeros(1,nPlayers); %gives ranking of players in order of id, change so it takes variable nPlayers
    i=1;
    num_above=0;
    while i<=nPlayers
        for j=1:1:nPlayers
          if players(i).score<players(j).score
            num_above=num_above+1;
          elseif players(i).score==players(j).score && players(i).nGames>players(j).nGames
            num_above=num_above+1;
          end
        end
        players_rankings(i)=1+num_above;
        num_above=0;
        i=i+1;
    end

    sortedPlayers=bubble_sort(players_rankings,players,nPlayers);
    

    fprintf("The top three players are: \n")
    for z=1:1:top_players
        fprintf("Player #%i with %i points \n",sortedPlayers(z).playerId,sortedPlayers(z).score)
    end

end

function listRankings(players,nPlayers)%ranks according to score if there is a tie player with less games ranked above
   
    players_rankings=zeros(1,nPlayers); %gives ranking of players in order of id, change so it takes variable nPlayers
    i=1;
    num_above=0;
    while i<=nPlayers
        for j=1:1:nPlayers
          if players(i).score<players(j).score
            num_above=num_above+1;
          elseif players(i).score==players(j).score && players(i).nGames>players(j).nGames
            num_above=num_above+1;
          end
        end
        players_rankings(i)=1+num_above;
        num_above=0;
        i=i+1;
    end

    for k=1:1:nPlayers
        fprintf("Player #%i ranking: %i \n",k,players_rankings(k))
    end

end

function sorted=bubble_sort(players_rankings,players,nPlayers)
    
    combination_for_sort=struct('players_rankings',players_rankings,'players',players); 
    %makes a temporary array that appends player records and player 
    %rankings to allow bubble sort to work
    
    N=nPlayers;
    i=1; 
    swap=true;

    while i<=N-1 && swap == true
        swap=false;
        for j=1:N-i
            if combination_for_sort.players_rankings(j)>combination_for_sort.players_rankings(j+1)
                %swaps rankings
                aux_ranking=combination_for_sort.players_rankings(j);
                combination_for_sort.players_rankings(j)=combination_for_sort.players_rankings(j+1);
                combination_for_sort.players_rankings(j+1)=aux_ranking;
                %swaps position of player in new structure
                %combination_for_sort
                aux_player=combination_for_sort.players(j);
                combination_for_sort.players(j)=combination_for_sort.players(j+1);
                combination_for_sort.players(j+1)=aux_player;
                
                swap=true;
            end
        end
    i=i+1;
    end

    sorted=combination_for_sort.players;

end

%play game functions
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
            while(trouble_enter~="1" && trouble_enter~="2" && trouble_enter~="3" &&...
            trouble_enter~="4" && trouble_enter~="5" && trouble_enter~="6") 
            trouble_enter=input("Enter your board(numbers between 1 and 6):","s");
            end
            game.board(i,j)=str2num(trouble_enter);
            trouble_enter="sth";
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
    end
    % disp(game.secretCode) % Really important line for testing. Dont% touch!
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