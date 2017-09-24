package;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class ShadowObj extends FlxSprite
{
	public var imIndex:Int;

	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:Dynamic, imIndex:Int ) 
	{
		super(X, Y, SimpleGraphic);
		
		this.imIndex = imIndex;
	}
	
	override public function update():Void 
	{
		super.update();
		
		x = FlxG.mouse.x-origin.x;
		y = FlxG.mouse.y-origin.y;
	}
	
}