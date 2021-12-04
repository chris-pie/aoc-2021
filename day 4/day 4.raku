my $board_size = 5;
my $number_length = 2;
my $inFile = slurp "day 4.txt";
my @splitInput = split "\n",$inFile, :skip-empty;

my @numbersCalled = split ",", @splitInput[0], :skip-empty;

my @numbersCalledInverted;
my $i = 0;
for @numbersCalled
{
    @numbersCalledInverted[$_] = $i;
    $i++
}

my $rowsLoaded = 0;
my $boardsLoaded = 0;
my @boards = [[]];
for @splitInput[1..*]
{
    if $rowsLoaded == 5
    {
        $rowsLoaded = 0;
        $boardsLoaded += 1;
        @boards[$boardsLoaded] = [];

    }
    my @parsedRow = split " ", @_, :skip-empty;
    my @substitutedRow = [];
    for @parsedRow 
    {
        @substitutedRow.append(@numbersCalledInverted[$_]);
    }

    @boards[$boardsLoaded][$rowsLoaded] = @substitutedRow;
    $rowsLoaded += 1;
}

my @firstBoard = [];
my @lastBoard = [];
my $lowestNumber = Inf;
my $highestNumber = -1;


for @boards -> @board
{
    my $boardMin = Inf;
    for 0..$board_size-1 -> $i
    {

        for 0..$board_size-1 -> $j
        {
            my $localMax = @board[$i].max();
            if $localMax < $lowestNumber
            {
                @firstBoard = @board;
                $lowestNumber = $localMax;
            }
            if $localMax < $boardMin
            {
                $boardMin = $localMax;
            }
        }
        my @transposed = [Z] @board;
        for 0..$board_size-1 -> $j
        {
            my $localMax = @transposed[$i].max();
            if $localMax < $lowestNumber
            {
                @firstBoard = @board;
                $lowestNumber = $localMax;
            }
            if $localMax < $boardMin
            {
                $boardMin = $localMax;
            }
        }
    }
    if $boardMin > $highestNumber
        {
            $highestNumber = $boardMin;
            @lastBoard = @board;
        }
}


my @flatBoard = @firstBoard.List.flat;
my $sum = 0;
for @flatBoard
{
    if $_ > $lowestNumber
    {
        $sum += @numbersCalled[$_];
    }
}

say $sum * @numbersCalled[$lowestNumber];

@flatBoard = @lastBoard.List.flat;
$sum = 0;
for @flatBoard
{
    if $_ > $highestNumber
    {
        $sum += @numbersCalled[$_];
    }
}

say $sum * @numbersCalled[$highestNumber];