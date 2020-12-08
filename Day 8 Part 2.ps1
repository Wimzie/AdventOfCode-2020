$inputFile = Get-Content 'C:\Scripts\AdventOfCode 2020\8\input.txt'

function Boot {
    Param(
        $inputList,
        [switch]$returnIndexList
    )
    $accumulator = 0
    $indexesAlreadyExecuted = @()
    $i = 0

    do {
        if($indexesAlreadyExecuted -contains $i){
            if($returnIndexList){
                return $indexesAlreadyExecuted
            }
            return $false
        }
        
        $instruction = $inputList[$i].Split(' ')[0]
        $quantifier = $inputList[$i].Split(' ')[1]

        if($i -eq ($inputList.Count -1)){
            if($instruction -eq "acc"){
                return $accumulator + $quantifier
            }
            return $accumulator
        }

        $indexesAlreadyExecuted += $i

        switch ($instruction){
            "acc" {
                $i += 1
                $accumulator += $quantifier
            }
            "jmp" {
                $i += $quantifier
            }
            "nop" {
                $i += 1
            }
        }
        
    } while ($true)
}

$indexList = $(Boot -input $inputFile -returnIndexList)

For($j = 0; $j -lt $indexList.Count; $j += 1){
    $newInputList = $inputFile.Clone()
    if($newInputList[$indexList[$j]].Substring(0, 3) -eq "nop"){
        $newInputList[$indexList[$j]] = $newInputList[$indexList[$j]].Replace("nop", "jmp")
        $returnVariable = $(Boot -inputList $newInputList)
    } elseif($newInputList[$indexList[$j]].Substring(0, 3) -eq "jmp"){
        $newInputList[$indexList[$j]] = $newInputList[$indexList[$j]].Replace("jmp", "nop")
        $returnVariable = $(Boot -inputList $newInputList)
    }
    if($returnVariable -and ($returnVariable -ne $false)){
        break
    }
}

Write-Output "Final accumulation: $returnVariable"

