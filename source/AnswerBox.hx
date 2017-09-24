package;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.misc.ColorTween;
import lime.graphics.Image;

import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
class AnswerBox extends FlxSprite
{
	public var isAnswer:Bool;
	public var value:Int;
	public var textObj:FlxText;
	
	public var selected:Bool;
	
	private var colorT:ColorTween;

	public function new(value:Int, isAnswer:Bool, textObj:FlxText, X:Float = 0, Y:Float = 0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		this.value = value;
		this.isAnswer = isAnswer;
		this.textObj = textObj;
		
		selected = false;
	
	}
	
	public function wrongAnswerClicked()
	{
		selected = true;
		
		FlxTween.color(this, 1, 0xFFFFFF, 0xee1111, 1, 1, { type:FlxTween.PINGPONG } );
		
		//colorT = new ColorTween()
		//colorT.tween(1, 0xFFFFFF, 0xee1111, 0, 1, this, {type:FlxTween.PINGPONG});
		
	}
	
	public function flashGreen()
	{
		FlxTween.color(this, 1, 0xFFFFFF, 0x11ee11, 1, 1, { type:FlxTween.PINGPONG } );
	}
	
    
	
}