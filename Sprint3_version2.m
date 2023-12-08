%Group 47-4
%Ivan Krajtmajer - 100508010
%
%
%

clc
clear

%concerns or bugs notices: (list all bugs when playtesting the game below)
%
%
%

%things to do: 
%-rename vGames into games and check all other variables match up with the
%ones in the project file
%-fix remove game
%-add names and NIAs to the project header
%-add option to load in data
%-check that all headers match up with names given in projec file

%sprint 4 things:
%-add playerId input from user before starting game
%-display list of games from specific player
%-make sure when a game finishes it updates the players who's id was put in
%stats
%-save data into a file when exiting from main menu

%optional:
%-write out real code when player runs out of guesses
%-add clc so that menu is kept clean without clearing neccesary outputs
%-check that no colours are repeated in guess and if so do not count that
%attempt as valid

player_base=struct('playerId',0,'name',"name",'surname',"surname",'nGames',0,'score',0);
game_base = struct('playerId', 0, 'nGuesses',0, 'secretCode',[0 0 0 0], 'board', zeros(10,4), 'feedback',zeros(10,2), ...
    'score',0);

run=1;

nGames=0;
nPlayers=0;
vGames=repmat(game_base,1,250); %figure out a way to preallocate without using repmat function 
players=repmat(player_base,1,50);
id=1;
nPlayers=0;

%loads gama data when testing
%[vGames,nGames]=load('gamesInitialization.mat','gamesInit','nGamesInit');

%loads players when testing 
%load('playersInitialization.mat','gamesInit','nGamesInit')
%nPlayer=;

while run==1

    

    menu(1);
    user_input=input(""); 
    switch user_input

        case 1 %Player management
            %merge into one function that runs in a loop like with games
            %management case 2

            maxPlayers=50; %defines the number of max players for easier customizability later on
            
            [players, nPlayers,sortedPlayers] = managePlayers (players,nPlayers,maxPlayers);
                        
        case 2 %Game management
            if nGames==0
                clc
                fprintf("Sorry there are currently no games loaded.\n\n")
            else
                clc
                [vGames,nGames] = manageGames(vGames,nGames);
            end

        case 3 %play game
            if nGames<=250
                nGames=nGames+1;
                clc
                vGames(1,nGames)=play(game_base);%currently only stores played games one after another might not work for all cases 
            else
                fprintf("Sorry the maximum number of games is already loaded. \n\n")
            end

        case 0
            fprintf("\nThank you for playing the game!")
            run=0;
    end

end

%-------all functions---------
%menus  
function menu(menu_numr,nGames)

    switch menu_numr
        case 1
            
            fprintf("1.Player management \n2.Game management \n3.Play game \n0.Exit\n")
        case 2 %when game management called
            
            fprintf("1.Remove games \n2.Display games \n0.Exit \n")
        case 3 % when remove games called
            clc
            fprintf("Enter the number of the game (1-%i) you want to remove: ",nGames)
        case 4 %when player management called
            
            fprintf("1.Enter new player \n2.Display list of players \n3.Display ranking of players \n4.Display top players \n0.Exit\n")
        case 5 
    end

end

%game management functions
function [vGames,nGames] = manageGames(vGames,nGames) % the main one that utilizes the other two

    flag=0;
    while flag==0 %flag keeps manage games running until user enters 0
        menu(2)
        user_input2=input("");
                    
        if user_input2==1
            menu(3,nGames)
            game_remove_number=input("");
            vGames=removeGame(vGames,game_remove_number,game_base); 
            nGames=nGames-1;
    
        elseif user_input2==2
            list_Games(vGames,nGames)
    
        elseif user_input2==0
            flag=1;
        end
    
    end

end

function vGames = removeGame(vGames,game_remove_number,game_base)

    for i=game_remove_number:1:(249)
        vGames(i)=vGames(i+1);
    end

    vGames(250)=game_base;

end

function list_Games(vGames,nGames) %might be janky requires further scrutinizing

    % displays secret code, number of guesses and score
    for i=1:1:nGames
        code=vGames(i).secretCode(1)*1000+vGames(i).secretCode(2)*100+vGames(i).secretCode(3)*10+vGames(i).secretCode(4);
        guesses=vGames(i).nGuesses;
        score=vGames(i).score;
        fprintf("--GAME NUMBER %i:The code was:%i \nThe number of guesses:%i \nThe score was:%i \n",i,code,guesses,score)
    end

end

%player management functions
function[players, nPlayers,sortedPlayers] = managePlayers (players,nPlayers,maxPlayers)
    
    sortedPlayers=0;
    user_input_players=100;
    while user_input_players~=0
        menu(4)
            user_input_players=input("");
            
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
                    sortedPlayers=listPlayersRanked(players,nPlayers);
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
    
    fprintf("\nName: %s \nSurname: %s, Number of games played: %i \n Total score: %i\n",player.name,player.surname,player.nGames,player.score)

end

function listPlayers(players,nPlayer)
    for i=1:1:nPlayer
        fprintf("Player number %i: \n",i)
        displayPlayer(players(i))
    end
end

function sortedPlayers=listPlayersRanked(players,nPlayers)%rank players outside or in different function to make code more readable
    
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
    for z=1:1:3
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

    while i<=10 && comp==false
        for j=1:4
            fprintf("Position %i\n",j)
            game.board(i,j)=input('Enter your board(numbers between 1 and 6):');
        end
        [white,black] = verifyCode(game.secretCode,game.board(i,:));
        game.feedback(i,1)=black;
        game.feedback(i,2)=white;

        if  game.board(i,:)==game.secretCode
            comp=true;
            game.score=100-10*i;
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


