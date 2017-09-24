package;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */

typedef EquationDetails = {
	var firstNum:Int;
	var secondNum:Int;
	var answer:Int;
	var operator:String;
	
	var fakeAnswers:Array<Int>;
}
 
class EquationGenerator
{

	public function new() 
	{
		
	}
	
	public function genFakeSumAnswers(answer:Int, numOfFakes:Int)
	{
		var fakes:Array<Int> = [];
		
		var i:Int = 1;
		while (i < numOfFakes) {
			var randNum:Int = 0;
		    if (Std.random(2) == 0) {
				randNum = answer + Std.random(10);
			} else {
				if (answer == 0) continue;				
				
				randNum = answer - Std.random(10);
				if (randNum < 0) continue;

			}
				
			if (!Lambda.has(fakes, randNum) && randNum != answer) {
				fakes.push(randNum);
			} else {
				i--;
			}
			i++;
		}
		return fakes;
	}
	
	public function genEqn(maxNum:Int, minNum:Int, sign:String, algebra)
	{
		//prevent impossible algebra questions
		if (algebra && minNum == 0) {
			minNum = 1;
		}
		
		
	    var equationDetails = { firstNum:FlxRandom.intRanged(minNum, maxNum),
		                        secondNum:FlxRandom.intRanged(minNum, maxNum),
								operator:sign,
								answer:0,
								fakeAnswers:[]
							  };
							  
	    switch (sign) {
			case '+':
				equationDetails.answer = equationDetails.firstNum + equationDetails.secondNum;
			case '-':
				var ans, first, second = 0;
				first = equationDetails.firstNum;
				second = equationDetails.secondNum;
				ans = first - second;
				if (ans < 0) {
					equationDetails.firstNum = second;
					equationDetails.secondNum = first;
				}
				
				equationDetails.answer = equationDetails.firstNum - equationDetails.secondNum;

				
			case 'x':
				equationDetails.answer = equationDetails.firstNum * equationDetails.secondNum;
			case '÷':
				if (equationDetails.secondNum == 0) equationDetails.secondNum++; //stop dividing by 0
				
				equationDetails.firstNum = equationDetails.firstNum * equationDetails.secondNum;
				
				equationDetails.answer = Math.round(equationDetails.firstNum / equationDetails.secondNum);
	
		}
		if (algebra) {
			
			equationDetails.fakeAnswers = genFakeSumAnswers(equationDetails.secondNum, 3 + 1);
		} else {
			equationDetails.fakeAnswers = genFakeSumAnswers(equationDetails.answer, 3 + 1);
		}
		
		
		return equationDetails;
	}
	
	public function genRandomEquation(sumMax:Int, minNumber:Int, productMax:Int, algebra:Bool)
	{
		var rand = Std.random(4);
				
		switch(rand) {
			case 0:
				return genEqn(sumMax, minNumber, '+', algebra);
			case 1:
				return genEqn(sumMax, minNumber, '-', algebra);
			case 2:
				return genEqn(productMax, minNumber, 'x', algebra);
			case 3:
				return genEqn(productMax, minNumber, '÷', algebra);
		}
		
		return null;
	}
	
	
	/*
	public function genAddition(maxNum:Int)
	{
	    var equationDetails = { firstNum:Std.random(maxNum),
		                        secondNum:Std.random(maxNum),
								operator:"+",
								answer:0,
								fakeAnswers:[]
							  };
		
		equationDetails.answer = equationDetails.firstNum + equationDetails.secondNum;
		
		equationDetails.fakeAnswers = genFakeSumAnswers(equationDetails.answer, 3+1);
		
		return equationDetails;

	}*/

}
