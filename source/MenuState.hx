package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.net.URLRequest;
import openfl.Lib;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var muteButton:FlxButton;
	
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		super.create();
		
		var background:FlxSprite = new FlxSprite(0, 0, 'assets/images/menubg.png');
		add(background);
		
		var fighters:FlxSprite = new FlxSprite(FlxG.width - 300, FlxG.height - 300, 'assets/images/tiefighters.png');
		add(fighters);
		
		var logo:FlxSprite = new FlxSprite(100, 0, 'assets/images/logo.png');
		logo.x = FlxG.width/2-logo.width/2;
		add(logo);
		
		var title:FlxText = new FlxText(0, 50, 0, "tower wars");
		title.setFormat('assets/data/Starjedi.ttf', 100, 0xe7551e);
		title.x = FlxG.width / 2 - title.fieldWidth / 2;
		add(title);
		
		//BUTTONS
		
		var labelColour = 0xffffff;
		var labelOffsetY = -10;
		var labelAlign = 'center';
		var labelSize = 30;
		var labelFont = 'assets/data/Starjedi.ttf';
		var buttonWidth = 257;
		var buttonHeight = 78;
		var buttonImage = 'assets/images/button.png';
		var buttonSound = 'assets/music/Button Click.mp3';
		
		var playButton:FlxButton = new FlxButton(300, 230, "New Game");
		playButton.loadGraphic('assets/images/button.png', true, 257, 78);
		playButton.onUp.sound = FlxG.sound.load(buttonSound);
		playButton.onUp.sound.onComplete = playPressed;
		
		playButton.label.setFormat('assets/data/Starjedi.ttf', 30, labelColour, 'center');
		playButton.label.offset.set(0, -10);
		add(playButton);
		
		var arcadeButton:FlxButton = new FlxButton(300, 320, "Arcade");
		arcadeButton.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		arcadeButton.label.setFormat(labelFont, labelSize, labelColour, labelAlign);
		arcadeButton.label.offset.set(0, labelOffsetY);
		arcadeButton.onUp.sound = FlxG.sound.load(buttonSound);
		arcadeButton.onUp.sound.onComplete = arcadePressed;
		add(arcadeButton);
		
		var websiteButton:FlxButton = new FlxButton(300, 410, "website", websitePressed);
		websiteButton.loadGraphic(buttonImage, true, buttonWidth, buttonHeight);
		websiteButton.label.setFormat(labelFont, labelSize, labelColour, labelAlign);
		websiteButton.label.offset.set(0, labelOffsetY);
		websiteButton.onUp.sound = FlxG.sound.load(buttonSound);
		add(websiteButton);
		
		muteButton = new FlxButton(850, 460, mutePressed);
		//muteButton.onUp.sound = FlxG.sound.load(buttonSound);
		muteButton.loadGraphic('assets/images/mutebtn.png', false);
		add(muteButton);

		
		var badguy:FlxSprite = new FlxSprite(40, 145, 'assets/images/badguyfront.png');
		
		add(badguy);
		
		var deathstar:FlxSprite = new FlxSprite(820, 130, 'assets/images/deathstar.png');
		add(deathstar);
		
		FlxG.sound.playMusic('assets/music/intro.mp3');
		
		//REMOVE THIS
		//FlxG.sound.muted = true;
		
	}
	
	public function playPressed()
	{
		FlxG.switchState(new OptionsState() );
	}
	
	public function arcadePressed()
	{
		FlxG.switchState(new PlayState(2, 'arcade'));
	}
	
	public function websitePressed()
	{
		Lib.getURL(new URLRequest("http://www.accessmaths.co.uk/games"));
	}
	
	
	public function mutePressed()
	{
		if (FlxG.sound.muted) {
			muteButton.loadGraphic('assets/images/mutebtn.png');
			FlxG.sound.muted = false;
			
		} else {
			FlxG.sound.muted = true;
			muteButton.loadGraphic('assets/images/unmutebtn.png');
		}	
	}



	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}
}