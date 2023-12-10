





clear;
clc;

%% PREALLOCATING STRUCTURES
nPlayers=0;
maxPlayers=50;
players(1,maxPlayers) = struct('playerId',0,...
                'name','',...
                'surname','',...
                'nGames',0, ...
                'score',0);



maxGames=250;
nGames=0;
cont=1;

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

    
%% LOADING EXTERNAL DATA
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


%% MAIN SCRIPT


cont=1;
while cont==1
    opcion=menuMain();
    switch opcion
        case 0
            cont=0;
        case 1
            [players,nPlayers] = managePlayers (players,nPlayers,maxPlayers);
        case 2
            [games,nGames,players] = manageGames(games,nGames,maxGames,nPlayers,players);
    end
end


%% FUNCTIONS

function opcion=menuMain()
    fprintf ('*****************************************\n');
    fprintf ('myMasterMind: \n');
    fprintf ('*****************************************\n');    
    fprintf ('\t 1. Player management\n');
    fprintf ('\t 2. Game management and Play game\n');
    fprintf ('\t 0. Exit\n');   
    fprintf ('\n');
    opcion=input ('Enter selection: ');
end
 
%FUNCTION TO MANAGE GAMES
 function   [games,nGames,players] = manageGames(games,nGames,maxGames,nPlayers,players)
    cont=1;
    while nGames<=maxGames && cont==1    
        
        opcion=menuGames();
        switch opcion
            case 0
                displayGamesList(games, nGames)
                cont=0;
            case 1
                
                id=input('Enter player Id: ');
                x=true;
                %CHECKING IF THE ID IS VALID
                while x==true
                    if id<=nPlayers
                        x=false;
                        games(nGames+1).playerId= id;
                    else
                        id=input('Player Id not valid, please reenter: ');
                    end
                end    
                nGames=nGames+1;
                games(nGames)=play(games(nGames));    
                %UPDATING SCORE AND NUMBER OF GAMES BY THE PLAYER
                players(id).score = players(id).score+games(nGames).score;
                players(id).nGames = players(id).nGames+1;    
                
                
            case 2
                displayGamesList(games, nGames)
            
            case 3 
                
                playerId= input('Enter the Id of the player: ');
                gamesPlayed=1;
                %WE USE ANOTHER VECTOR OF STRUCTURES ON WHICH WE COPY THE
                %GAMES BY A GIVEN PLAYER
            
                for i=1:nGames
                    if playerId==games(i).playerId
                        gamesplayer(gamesPlayed)=games(i);
                        gamesPlayed=gamesPlayed+1;
                    end
                end
                displayGamesList(gamesplayer, gamesPlayed-1)
                   
            end
    end
    if nGames>maxGames
        fprintf('You have surpassed the maximum number of games\n')
    end    
end


function opcion = menuGames()
    
    keyPress=input('Press enter to see menu...'); 
    fprintf ('*****************************************\n');
    fprintf ('myMasterMind: GESTION DE PARTIDAS\n');
    
    fprintf ('\t 1. Play game\n');
    fprintf ('\t 2. Display all games\n');
    fprintf ('\t 3. Display all games for a player\n');
    fprintf ('\t 0. Exit\n');
    
    fprintf ('\n\n');
    opcion=input ('Enter selection: ');
end


%FUNCTION USED TO PLAY THE GAME
function games=play(games)

    games.secretCode=generateSecretCode();
    cont=1;
    games.nGuesses=0;

    while games.nGuesses<=9 && cont==1
    
        games.nGuesses=games.nGuesses+1;
        %READS THE GUESS FROM PLAYER
        for i = 1:4
            games.board(games.nGuesses,i) = input('Enter number between 1 and 6: ');
        end
    
        %VERIFIES IF THE GUESS IS EQUAL TO THE SECRET CODE
        [black,white] = verifyCode(games.secretCode, games.board(games.nGuesses,:));
        fprintf('Blacks: %i. Whites: %i.\n', black, white)
        
    
        games.feedback(games.nGuesses,1)=black;
        games.feedback(games.nGuesses,2)=white;
        
        if black == 4
            cont=0;
        end
    
    games.score=110-10*games.nGuesses;
    
    end

end


%GENERATES SECRET CODE TO PLAY
function secretCode=generateSecretCode()

    colours=[1,2,3,4,5,6];
    secretCode=zeros(1,4);
    for i=1:4

        pos=randi([1,7-i]);
        secretCode(1,i)=colours(1,pos);
        colours(pos)=[];
    end
end

%VERIFIES IF THE GUESS IS CORRECT
function [black,white] = verifyCode(secretCode,guess)
    white=0;
    black=0;
    for i =1:4
        for j=1:4
            if secretCode(i)==guess(j)
                if i==j
                    black=black+1;
                else
                    white=white+1;
                end
            end
        end
    end
    
end

%DISPLAYS NUMBER OF THE GAME,ID OF THE PLAYER, SECRET CODE AND NUMBER OF GUESSES
function displayGamesList(games, nGames)
    for i = 1:nGames
        
        fprintf('Game %i:\n', i)
        fprintf('Player Id was %i\n', games(i).playerId)
        fprintf('Secret code was: %i\t%i\t%i\t%i\t\n',games(i).secretCode)
        fprintf('Number of guesses was: %i\n', games(i).nGuesses)
        fprintf('Final score was: %i\n', games(i).score)
    end
end

% MANAGES PLAYERS
function [players,nPlayers] = managePlayers(players,nPlayers,maxPlayers) 
    cont=1;
    while cont==1 && nPlayers<=maxPlayers 
        opcion = menuPlayers(); 
        switch opcion 
            case 1  %adds a new player
                nPlayers=nPlayers+1; 
                players(nPlayers) = readPlayer(nPlayers); 
                
            case 2  %shows the list of players
                displayPlayer(players, nPlayers); 
            case 3  %shows the list of player but sorted
                
                sortedPlayers = rankPlayers(players, nPlayers); 
                displayPlayer(sortedPlayers, nPlayers); 
            case 4 % shows the desire amount of players sorted
                
                a=input('How many top players do you want to show: '); 
                sortedPlayers = rankPlayers(players, nPlayers); 
                displayPlayer(sortedPlayers, a); 
            case 0
                cont=0;
        end 
    end 
end

% CLASSIFIES PLAYERS ACCORDING TO THEIR OVERALL SCORE
function sortedPlayers=rankPlayers(players,nPlayers)
    
    sortedPlayers = players; 
    
    for i = 1:nPlayers-1 
         for j = 1:nPlayers-i 
             if sortedPlayers(j).score < sortedPlayers(j+1).score 
             aux = sortedPlayers(j); 
             sortedPlayers(j) = sortedPlayers(j+1); 
             sortedPlayers(j+1) = aux; 
             end 
         end 
    end  
end 

%SHOWS THE DATA FOR A GIVEN PLAYER
function displayPlayer(players,nPlayer)
 
     for i=1:nPlayer
        fprintf('Player %i\n',i); 
        fprintf('Name: %s\n',players(i).name); 
        fprintf('Surname: %s\n',players(i).surname); 
        fprintf('Number of games played: %i\n',players(i).nGames); 
        fprintf('Score of the player in the championship: %i\n',players(i).score); 
         
     end 
end 

%READS A NEW PLAYER
function player=readPlayer(nPlayer)  
    player.playerId=nPlayer; 
    player.name=input('Introduce name: ','s'); 
    player.surname=input('Introduce surname: ','s'); 
    player.nGames=input('Introduce the number of games: '); 
    player.score=input('Enter the score: '); 
end 


function opcion=menuPlayers()
    
    keyPress=input('Press enter to see menu...'); 
    
    fprintf ('*****************************************\n');
    fprintf ('myMasterMind: Player management\n');
    fprintf ('*****************************************\n');    
    fprintf ('\t 1. Enter new player\n');
    fprintf ('\t 2. Display list of players\n');
    fprintf ('\t 3. Display ranking of players\n');
    fprintf ('\t 4. Display top players\n');
    fprintf ('\t 0. Back to main menu\n');   
    fprintf ('\n');
    
    opcion=input ('Enter selection: ');
end