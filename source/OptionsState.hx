package;
import flixel.addons.ui.FlxUIState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * ...
 * @author 
 */
class OptionsState extends FlxUIState
{
	var easyBtn:FlxButton;
	var hardBtn:FlxButton;
	var additionBtn:FlxButton;
	var subtractionBtn:FlxButton;
	var multiplicationBtn:FlxButton;
	var divisionBtn:FlxButton;
	var algebraBtn:FlxButton;
	
	var easyMode:Bool;
	
	var difficulty:Int;
	var difficultyLabel:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		easyMode = true;
		
		difficulty = 1;
		
		var background:FlxSprite = new FlxSprite(0, 0, 'assets/images/menubg.png');
		add(background);
		

		
		var labelColor = 0xffffff;
		var labelOffsetY = -10;
		var labelAlign = 'center';
		var labelSize = 30;
		var labelFont = 'assets/data/Starjedi.ttf';
		var buttonWidth = 257;
		var buttonHeight = 78;
		var buttonImage = 'assets/images/button.png';
		var buttonSound = 'assets/music/Button Click.mp3';
		
		
		difficultyLabel = new FlxText(150, 20, 0, "Difficulty: Beginner");
		difficultyLabel.setFormat(labelFont, 50, labelColor, labelAlign);
		add(difficultyLabel);
		
		var changeButton:FlxButton = new FlxButton(300, 100, "Change", changeDifficulty);
		changeButton.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		changeButton.label.setFormat(labelFont, labelSize, labelColor, labelAlign);
		changeButton.label.offset.set(0, labelOffsetY);
		add(changeButton);
		
		/*easyBtn = new FlxButton(200, 200, "Beginner", easyPressed);
		add(easyBtn);

		
		hardBtn = new FlxButton(400, 200, "Advanced", hardPressed);
		add(hardBtn);*/
		
		additionBtn = new FlxButton(100, 230, "Addition");
		additionBtn.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		additionBtn.label.setFormat(labelFont, labelSize, labelColor, labelAlign);
		additionBtn.label.offset.set(0, labelOffsetY);
		additionBtn.onUp.sound = FlxG.sound.load(buttonSound);
		additionBtn.onUp.sound.onComplete = additionPressed;
		
		add(additionBtn);
		
		subtractionBtn = new FlxButton(100, 330, "Subtraction");
		subtractionBtn.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		subtractionBtn.label.setFormat(labelFont, 28, labelColor, labelAlign);
		subtractionBtn.label.offset.set(0, labelOffsetY);
		subtractionBtn.onUp.sound = FlxG.sound.load(buttonSound);
		subtractionBtn.onUp.sound.onComplete = subtractionPressed;
		add(subtractionBtn);
		
		multiplicationBtn = new FlxButton(500, 230, "Multiplication");
		multiplicationBtn.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		multiplicationBtn.label.setFormat(labelFont, 25, labelColor, labelAlign);
		multiplicationBtn.label.offset.set(0, labelOffsetY);
		multiplicationBtn.onUp.sound = FlxG.sound.load(buttonSound);
		multiplicationBtn.onUp.sound.onComplete = multiplicationPressed;
		
		add(multiplicationBtn);
		
		divisionBtn = new FlxButton(500, 330, "Division");
		divisionBtn.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		divisionBtn.label.setFormat(labelFont, labelSize, labelColor, labelAlign);
		divisionBtn.label.offset.set(0, labelOffsetY);
		divisionBtn.onUp.sound = FlxG.sound.load(buttonSound);
		divisionBtn.onUp.sound.onComplete = divisionPressed;
		
		add(divisionBtn);
		
		algebraBtn = new FlxButton(300, 420, "Mixed");
		algebraBtn.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		algebraBtn.label.setFormat(labelFont, labelSize, labelColor, labelAlign);
		algebraBtn.label.offset.set(0, labelOffsetY);
		algebraBtn.onUp.sound = FlxG.sound.load(buttonSound);
		algebraBtn.onUp.sound.onComplete = algebraPressed;
		add(algebraBtn);
		
		
		
	}
	
	public function changeDifficulty()
	{
		if (difficulty == 1) {
			difficulty = 2;
			difficultyLabel.text = "Difficulty: Advanced";
		} else if (difficulty == 2) {
			difficulty = 1;
			difficultyLabel.text = "Difficulty: Beginner";
		}
	}
	
	public function easyPressed()
	{
		easyMode = true;
		difficulty = 1;
		
	}
	
	public function hardPressed()
	{
		easyMode = false;
		difficulty = 2;

	}
	
	public function additionPressed()
	{
		FlxG.switchState(new PlayState(difficulty, "+"));
	}
	
	public function subtractionPressed()
	{
		FlxG.switchState(new PlayState(difficulty, "-"));
	}
	
	public function multiplicationPressed()
	{
		FlxG.switchState(new PlayState(difficulty, "x"));
	}
	
	public function divisionPressed()
	{
		FlxG.switchState(new PlayState(difficulty, "÷"));
	}
	
	public function algebraPressed()
	{
		FlxG.switchState(new PlayState(difficulty, "a"));
	}
	
	override public function update():Void 
	{
		super.update();
		

		
	}
	
	
}