package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class InstructionsState extends FlxSubState
{

	public function new(BGColor:Int=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		
	}
	
	override public function create():Void 
	{
		super.create();
		
		
		
		var text = new FlxText(200, 50, 0, "Click and drag the answer at the top\nof the screen and use the given piece to\nstart to build a tower. \nSelect which skill you want to practice or\ntest your luck with them all in arcade mode.\nReach 15 metres or answer 20 questions\ncorrectly to win. \nWatch out you only have limited lives!", 50);
		text.setFormat('assets/data/Starjedi.ttf', 20, 0xffffff);
		text.scrollFactor.set();
		add(text);
		
		var okayBtn:FlxButton = new FlxButton(300, 350, "okay", okayPressed);
		okayBtn.loadGraphic('assets/images/button.png', true, 257, 78);
		okayBtn.label.setFormat('assets/data/Starjedi.ttf', 20, 0xffffff, 'center');
		okayBtn.label.offset.set(0, -10);
		add(okayBtn);
	}
	
	public function okayPressed()
	{
		close();
	}
	
	override public function update():Void 
	{
		super.update();
	
	}
	
}