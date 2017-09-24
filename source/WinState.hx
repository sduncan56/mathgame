package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class WinState extends FlxSubState
{
	var score:Int;
	var won:Bool;
	var nextState:Class<FlxState>;

	public function new(score:Int, won:Bool, BGColor:Int = FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		this.score = score;
		this.won = won;
		
	}
	
	override public function create():Void 
	{
		super.create();
		
		//Copypasting - maybe it should be in a global somewhere, but oh well.
		var labelColour = 0xffffff;
		var labelOffsetY = -10;
		var labelAlign = 'center';
		var labelSize = 30;
		var labelFont = 'assets/data/Starjedi.ttf';
		var buttonWidth = 257;
		var buttonHeight = 78;
		var buttonImage = 'assets/images/button.png';
		var buttonSound = 'assets/music/Button Click.mp3';	
		
		
		var text:String;
		var btnText:String;
		
		if (won) {
			text = "congratulations";
			btnText = "return";
		} else {
			text = "game over";
			btnText = "retry";
		}
		
		//var frame:FlxSprite = new FlxSprite(200, 5, 'assets/images/frame_win.png');
		//add(frame);
		
		//var txt:FlxText = new FlxText(frame.x + 20, frame.y + 50, 300, "congratulations");
		var txt:FlxText = new FlxText(40, 120, 0, text);
		txt.setFormat('assets/data/Starjedi.ttf', 80, 0xffffff, 'center');
		txt.scrollFactor.set();
		add(txt);
		
		var scoreTxt:FlxText = new FlxText(txt.x, txt.y + 150, 0, "Score: "+Std.string(score));
		scoreTxt.setFormat('assets/data/Starjedi.ttf', 60, 0xffffff, 'center');
		add(scoreTxt);
		scoreTxt.scrollFactor.set();
		
		var returnBtn:FlxButton = new FlxButton(400, 280, btnText);
		returnBtn.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		returnBtn.label.setFormat(labelFont, labelSize, labelColour, labelAlign);
		returnBtn.label.offset.set(0, labelOffsetY);
		returnBtn.onUp.sound = FlxG.sound.load(buttonSound);
		returnBtn.onUp.sound.onComplete = returnClicked;

		add(returnBtn);
		
		
		
	}
	
	public function returnClicked()
	{
		close();
	}
	
}