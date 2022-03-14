import Control.Monad
import Data.List (group, sort)
import Control.Arrow ((&&&))

zipWithDefault :: a -> b -> (a -> b -> c) -> [a] -> [b] -> [c]
zipWithDefault dx _  f []     ys     = zipWith f (repeat dx) ys
zipWithDefault _  dy f xs     []     = zipWith f xs (repeat dy)
zipWithDefault dx dy f (x:xs) (y:ys) = f x y : zipWithDefault dx dy f xs ys

sumWeights :: [Integer] -> [(Integer, Integer)]
sumWeights rolls = sumweights
    where
    combinations = replicateM 3 rolls
    sums = map (foldl (+) 0) combinations
    sumweights = map (head &&& (toInteger . length)) . group . sort $ sums

playGame1 :: Integer -> Integer -> Integer -> Integer -> [Integer] -> Integer -> Integer
playGame1 p1pos p2pos p1score p2score die timesRolled
    | or [(p1score >= 1000), (p2score >= 1000)] = timesRolled * (min p1score p2score)
    | (mod timesRolled 2) == 0 = playGame1 p1posnew p2pos p1scorenew p2score dienew (timesRolled + 3)
    | (mod timesRolled 2) == 1 = playGame1 p1pos p2posnew p1score p2scorenew dienew (timesRolled + 3)
    where
        p1posnew = ((p1pos + diceRolls) `mod` 10)
        p2posnew = ((p2pos + diceRolls) `mod` 10)
        p1scorenew = p1score + p1posnew + 1
        p2scorenew = p2score + p2posnew + 1
        diceRolls = sum (take 3 die)
        dienew = drop 3 die
        
        
        
        
newPos :: Integer -> Integer -> Integer
newPos pos roll = ((pos + roll) `mod` 10)

newScore :: Integer -> Integer -> Integer
newScore score pos = score + pos + 1

weightIfWin maxScore weight score 
    | (score >= maxScore) = weight
    | otherwise = 0

calculateWins :: [(Integer, Integer)] -> Integer -> Integer -> Integer -> [Integer]
calculateWins weights maxScore pos score
    | score >= maxScore = [0]
    | otherwise = currentWins:cumWins
    where
        currentWins = foldl (+) 0 (zipWith (weightIfWin maxScore) (map snd weights) newScoreList)
        cumWins =  foldl (zipWithDefault 0 0 (+)) [0] weightedWins
        newPosList = map (newPos pos) (map fst weights)
        newScoreList = map (newScore score) newPosList
        wins = zipWith (calculateWins weights maxScore) newPosList newScoreList
        weightedWins = zipWith (map . (*)) (map snd weights) wins


    
adjustWins :: [Integer] -> [Integer] -> Integer -> Integer -> ([Integer], [Integer])
adjustWins [] _ _ _ = ([0], [0])
adjustWins _ [] _ _ = ([0], [0])
adjustWins [0] _ _ _ = ([0], [0])
adjustWins _ [0] _ _ = ([0], [0])
adjustWins (p1Win:p1Wins) (p2Win:p2Wins) p1Count p2Count = (p1WinAdjusted:p1WinsAdjusted,p2WinAdjusted:p2WinsAdjusted)
    where
		newCount1 = (p1Count * 27) - p1Win
		newCount2 = (p2Count * 27) - p2Win
		p1WinAdjusted = (p1Win * p2Count)
		p2WinAdjusted = (p2Win * newCount1)
		(p1WinsAdjusted, p2WinsAdjusted) = adjustWins p1Wins p2Wins newCount1 newCount2
    


playGame2 :: Integer -> Integer -> Integer -> Integer
playGame2 p1pos p2pos maxScore =
    max (foldl (+) 0 p1wins) (foldl (+) 0 p2wins)
    where
        rollWeights = sumWeights [1,2,3]
        p1winsFirstPass = calculateWins rollWeights maxScore p1pos 0
        p2winsFirstPass =  calculateWins rollWeights maxScore p2pos 0
        (p1wins, p2wins) = adjustWins p1winsFirstPass p2winsFirstPass 1 1


main = do
    z <- getContents
    let k = lines z
    let p1 = read . (drop 28) . head $ k ::Integer
    let p2 = read . (drop 28) . last $ k ::Integer
    let die1 = [1..100] ++ die1
    putStrLn . show $ playGame1 (p1-1) (p2-1) 0 0 die1 0
    putStrLn . show $ playGame2 (p1-1) (p2-1) 21
    
 