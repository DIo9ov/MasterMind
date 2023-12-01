%step 5 (load data)
load('gamesInitialization.mat','gamesInit','nGamesInit')
for k=1:nGamesInit
    games(k)=gamesInit(k)
end


displayGamesList(games, nGamesInit);


%this is the function of step 4 (display games)
function displayGamesList(games, n)
    
    for i=1:n
        fprintf("GAME %i\n", i);
        fprintf("   The secret code is:\n");
        display(games(i).secretCode);
        fprintf("   The attemps are: %i\n", games(i).nGuesses);
        fprintf("   The score is: %i\n", games(i).score);
    end
end