package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import haxe.ds.Vector;
import haxe.Json;
import nape.geom.Ray;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.ShapeList;
import openfl.display.BitmapData;
import openfl.geom.Point;
import nape.callbacks.*;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState; 

import openfl.Assets;

import nape.phys.BodyType;

import EquationGenerator;


    typedef ImData = {
	    var bitmapData:BitmapData;
		var shapes:Array<Polygon>;
    }
 

class PlayState extends FlxNapeState
{
	
	var answerBoxes:Array<AnswerBox>;
	
	var objShadow:ShadowObj;
	
	var objGraphics:Array<ImData>;
	
	var stackObjects:Array<StackObj>;
	
	var highestObjY:Float;
	var scaleCount:Int;
	
	var floor:FlxNapeSprite;
		
	var wrongAnswerInput:Bool;
	var wrongAnswerTimer:FlxTimer;
	
    var equationGenerator:EquationGenerator;

	var eqnText:FlxText;
	
	var scale:Float;
	var zooming:Bool;
	var zoomCeiling:Float;
	
	var eqnCam:FlxCamera;
	
	var zoomer:Float;
	
	var scroller:FlxObject;
	
	var waitTimer:FlxTimer;
	var stackHeight:Float;
	
	var heightDisplay:FlxText;
	
	var badguy:FlxSprite;
	var badguyArm:FlxSprite;
	
	var difficulty:Int;
	var mode:String;
	
	var questionFrame:FlxSprite;
	var muteButton:FlxButton;
	
	var winState:WinState;
	var correctAnswers:Int;
	var correctAnswersTxt:FlxText;
	
	var lives:Int;
	var livesTxt:FlxText;
	var objColType:CbType;
	
	public function new(difficulty:Int, mode:String)
	{
		super();
		
		this.difficulty = difficulty;
		this.mode = mode;
	}
	

			

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		super.create();

		stackHeight = 0;
		correctAnswers = 0;
		
		lives = 5;
		
		scale = 1.0;
		zooming = false;
		zoomCeiling = 400;
		zoomer = 1;
		
		objShadow = null;
		stackObjects = new Array();
		
		//napeDebugEnabled = true;
		
		var background:FlxSprite = new FlxSprite(0, 0, 'assets/images/resizedbg.png');
		background.scrollFactor.set(0, 0);
		add(background);
		
		FlxNapeState.space.gravity.setxy(0, 500);
		
		objGraphics = loadPhysShapes('assets/data/physobjects');
		
		floor = new FlxNapeSprite(500, FlxG.height-30, 'assets/images/floor.png');
		

		floor.body.gravMass = 0;
		floor.body.allowMovement = false;
		floor.body.allowRotation = false;
		
		floor.setBodyMaterial(0, 1, 1, 20, 0.1);
		
		add(floor);
		/*
		eqnCam = new FlxCamera(0, 0, FlxG.width, 200, 1);
		FlxG.cameras.add(eqnCam);
		FlxG.camera.setPosition(0, 0);*/

		equationGenerator = new EquationGenerator();
		
		
		
		scroller = new FlxObject(FlxG.width / 2, FlxG.height / 2);
		FlxG.camera.follow(scroller, FlxCamera.STYLE_LOCKON);
		
		//this timer delays the zoom checking, which is useful so we're not zooming up and down whenever the slightest thing happens
		waitTimer = new FlxTimer(1, checkZoom, 0);
		
		heightDisplay = new FlxText(FlxG.width - 100, FlxG.height - 100, 0, "0 "+"metres", 20);
		heightDisplay.scrollFactor.set(0, 0);
		heightDisplay.setFormat('assets/data/arial.ttf', 20, 0xffffff, 'center');
		add(heightDisplay);
		
		
		var guyBMD:BitmapData = Assets.getBitmapData('assets/images/smallbadguyside.png');
		badguy = new FlxSprite(5, FlxG.height-guyBMD.height, guyBMD);
		badguyArm = new FlxSprite(badguy.x + badguy.width - 30, badguy.y + 120, 'assets/images/badguyarm.png');
		badguyArm.origin.set(0, badguyArm.height / 2);
		
		add(badguyArm);
		add(badguy);
		
		
		questionFrame = new FlxSprite(20, 20, 'assets/images/questionframe.png');
		questionFrame.scrollFactor.set();
		add(questionFrame);
		
		FlxG.sound.playMusic('assets/music/In Game Music.mp3');
		
		correctAnswersTxt = new FlxText(150, questionFrame.y + questionFrame.height + 10, 0, "Correct: 0");
		correctAnswersTxt.setFormat('assets/data/Starjedi.ttf', 20, 0xffffff, 'center', FlxText.BORDER_OUTLINE);
		correctAnswersTxt.scrollFactor.set();
		add(correctAnswersTxt);
		
		livesTxt = new FlxText(152, correctAnswersTxt.y + 20, 0, "Lives: " + Std.string(lives));
		livesTxt.setFormat('assets/data/Starjedi.ttf', 20, 0xffffff, 'center', FlxText.BORDER_OUTLINE);
		livesTxt.scrollFactor.set();
		add(livesTxt);
		
		objColType = new CbType();
		
		floor.body.cbTypes.add(objColType);
		
		var intListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, objColType, objColType, coll);
		FlxNapeState.space.listeners.add(intListener);
		
		
		
		addUIButtons();
		
		createNewEquation();
		
		
		//FlxG.debugger.visible = true;
		//scale = 2;
	}
	
	public function addUIButtons()
	{
		var buttonX = questionFrame.x + questionFrame.width + 13;
		
		var homeBtn:FlxButton = new FlxButton(buttonX, questionFrame.y, homePressed);
		homeBtn.loadGraphic('assets/images/homebtn.png', false);
		add(homeBtn);
		
		var instBtn:FlxButton = new FlxButton(buttonX, questionFrame.y + 50, instPressed);
		instBtn.loadGraphic('assets/images/askbtn.png', false);
		add(instBtn);
		
		var reloadBtn:FlxButton = new FlxButton(buttonX, questionFrame.y + 100, reloadPressed);
		reloadBtn.loadGraphic('assets/images/reloadbtn.png', false);
		add(reloadBtn);
		
		muteButton = new FlxButton(850, 460, mutePressed);
		muteButton.loadGraphic('assets/images/mutebtn.png', false);
		add(muteButton);
	}
	
	public function coll(collision:InteractionCallback)
	{
		//this works, but too many collisions
		//FlxG.sound.play('assets/music/piecestouch.mp3');
	}
	
	public function homePressed()
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(new MenuState());
		});
		
	}
	
	public function instPressed()
	{
		var intructionState = new InstructionsState(0xee333355);
		openSubState(intructionState);
	}
	
	public function reloadPressed()
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(new PlayState(difficulty, mode));
		});
		
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


	
	public function createNewEquation(?algebra:Bool=false)
	{
		//var eqnDetails:EquationDetails = equationGenerator.genRandomEquation(40, 12, algebra);
		var maxNum:Int = 0;
		var minNum:Int = 0;
		
		if (difficulty == 1 && mode == "+" || mode == "-") {
			maxNum = 50;
		} else if (difficulty == 2 && mode == "+" || mode == "-") {
			maxNum = 500;
		} else if (difficulty == 1 && (mode == "x" || mode == "÷")) {
			maxNum = 12;
		} else if (difficulty == 2 && (mode == "x" || mode == "÷")) {
			maxNum = 15;
			minNum = 7;
		} else if (difficulty == 1 && mode == "a") {
			algebra = true;
			maxNum = 50;
		} else if (difficulty == 2 && mode == "a") {
			algebra = true;
			maxNum = 500;
		} else if (mode == "arcade") {
			maxNum = 50;
			var rand:Int = Std.random(2);
			if (rand == 0) {
				algebra = true;
			} else {
				algebra = false;
			}
		}
		var eqnDetails:EquationDetails;
		if (mode == "arcade") {
			eqnDetails = equationGenerator.genRandomEquation(maxNum, minNum, 12, algebra);
		} else if (!algebra) {
			eqnDetails = equationGenerator.genEqn(maxNum, minNum, mode, false);
		} else {
			eqnDetails = equationGenerator.genRandomEquation(maxNum, minNum, 12, true);
		}
		
		
		if (algebra) {
			eqnText = new FlxText(questionFrame.x + 25, questionFrame.y + 55, 230, eqnDetails.firstNum + " " + eqnDetails.operator + " " + "?" + " =" + " " + eqnDetails.answer, 40);
			eqnText.setFormat('assets/data/arial.ttf', 30, 0xffffff, 'center');
			eqnDetails.answer = eqnDetails.secondNum; //change answer to the second number so as not to have to add another 'if algebra' below, as the current value for answer isn't used again. Be aware though.
		} else {
			eqnText = new FlxText(questionFrame.x + 25, questionFrame.y + 45, 230, eqnDetails.firstNum + " " + eqnDetails.operator + " " + eqnDetails.secondNum, 50);
			eqnText.setFormat('assets/data/arial.ttf', 50, 0xffffff, 'center');
		}
		
		//eqnText.color = FlxColor.CRIMSON;
		
		
		eqnText.scrollFactor.set(0, 0);
		
		add(eqnText);
		
		
		//eqnText.camera = eqnCam;
		
		answerBoxes = [];
		
		var ansBoxX:Float = questionFrame.x+questionFrame.width+70;
		var ansBoxY:Float = questionFrame.y+15;
		var ansPos:Int = Std.random(eqnDetails.fakeAnswers.length + 1);

		var allAnswers:Array<Int> = eqnDetails.fakeAnswers;
		allAnswers.insert(ansPos, eqnDetails.answer);
		
		for (answer in allAnswers) {
			var truth:Bool = false;
			var value:Int = -1;
			if (answer == eqnDetails.answer) {
				truth = true;
			}
			
			var ansTxt:FlxText = new FlxText(ansBoxX+14, ansBoxY+25, 75, Std.string(answer));
			
			
			var box = new AnswerBox(answer, truth, ansTxt, ansBoxX, ansBoxY, Assets.getBitmapData('assets/images/answerbox.png'));
			
			ansTxt.setFormat('assets/data/arial.ttf', 40, 0xffffff, 'center');
			
			box.scrollFactor.set(0, 0);
			ansTxt.scrollFactor.set(0, 0);

			
			add(box);
			add(ansTxt);
			
			
			answerBoxes.push(box);
			
			ansBoxX += box.width+20;
			
			//box.camera = eqnCam;
			//ansTxt.camera = eqnCam;
			
		}
	}
	
	public function cleanEquation()
	{
		for (box in answerBoxes) {
			box.exists = false;
			remove(box.textObj);
		
			remove(box);
			
		}
		remove(eqnText);
	}
	
	public function wrongAnswerEventOver(Timer:FlxTimer)
	{
	    wrongAnswerInput = false;
		cleanEquation();
		createNewEquation();
	}
	
	public function wrongAnswer(box:AnswerBox)
	{
		lives--;
		
		wrongAnswerInput = true;
		
		box.wrongAnswerClicked();
		
		wrongAnswerTimer = new FlxTimer(4, wrongAnswerEventOver, 1);
		
		for (b in answerBoxes) {
			if (b.isAnswer) {
				b.flashGreen();
			}
		}
	}
	
	public function correctAnswer(box:AnswerBox)
	{
		correctAnswers++;
		correctAnswersTxt.text = "Correct: " + Std.string(correctAnswers);
		createObjShadow(box.x, box.y);
	}
	
	public function handleMouse()
	{
		if (FlxG.mouse.justPressed) {
			if (wrongAnswerInput) return;
			
			for (box in answerBoxes) {
				if (box.pixelsOverlapPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y))) {
					if (box.isAnswer && objShadow == null) {
						correctAnswer(box);
					} else if (!box.isAnswer && objShadow == null) {
						wrongAnswer(box);
						break;
					}
				}
			}
		}
		
		if (FlxG.mouse.justReleased) {
			if (objShadow != null) {
				spawnStackObj(FlxG.mouse.x, FlxG.mouse.y);
				remove(objShadow);
				objShadow = null;
				cleanEquation();
				createNewEquation();
			}
		}
		
		//rotate arm to face mouse
		var angle = FlxAngle.angleBetweenMouse(badguyArm, true);
		
		if (angle > -46 && angle < 18) {
			badguyArm.angle = angle;
		}
		
	}
	
	public function loadPhysShapes(filename:String)
	{
		var file = Assets.getText(filename);
		
		var json = Json.parse(file);
		
		var polygons:Array<Polygon> = [];
		
		var rBodies:Array<Dynamic> = cast json.rigidBodies;
		
		var objects:Array<ImData> = [];
		
		for (jBody in rBodies) {
			var jPolygons:Array<Dynamic> = cast jBody.polygons;
			
			var imData:ImData = {
				bitmapData:Assets.getBitmapData("assets" + jBody.imagePath.substr(2)),
				shapes:[]
			}
		
			
			var width:Float = imData.bitmapData.width;
			var height:Float = imData.bitmapData.height;
			
			for (jPoly in jPolygons) {
				var jVerticies:Array<Dynamic> = cast jPoly;
				
				var points:Array<Vec2> = [];
				
				for (jVert in jVerticies) {
					points.push(new Vec2(width * jVert.x, (height * jVert.y*(width/height)*-1)+height));
				}
				
				
				imData.shapes.push(new Polygon(points));
			}
			objects.push(imData);
		}
		
		return objects;
		
	}
	
	public function adjustPointsForOrigin(shapes:Array<Polygon>, origin:FlxPoint)
	{
		var adjustedShapes:Array<Polygon> = [];
		for (shape in shapes) {
			var points:Array<Vec2> = [];
			for (point in shape.localVerts) {
				var p:Vec2 = new Vec2(point.x - origin.x, point.y - origin.y);
				points.push(p);
				
			}
			adjustedShapes.push(new Polygon(points));
		}
		return adjustedShapes;
	}
	
	public function spawnStackObj(x:Float, y:Float)
	{
		
		
		var imData:ImData = objGraphics[objShadow.imIndex];
		
		var stackObj = new StackObj(x, y, imData.bitmapData, false);
		
		var body = new Body(BodyType.DYNAMIC, new Vec2(x, y));
		
		var shapes:Array<Polygon> = adjustPointsForOrigin(imData.shapes, stackObj.origin);
		
		for (shape in shapes) {
			body.shapes.add(shape);
		}
		
		stackObj.addPremadeBody(body);
		
		stackObj.physicsEnabled = true;
		
		stackObj.body.setShapeMaterials(new Material(0.0, 1.0, 1.0, 10, 0.1));
				
		stackObj.body.position.setxy(x, y);
		
		stackObj.body.cbTypes.add(objColType);
		add(stackObj);
		stackObjects.push(stackObj);
		
		
		
	}
	
	public function createObjShadow(x:Float, y:Float)
	{
		var imIndex:Int = Std.random(objGraphics.length);
		var bitmap:BitmapData = objGraphics[imIndex].bitmapData;
		
		objShadow = new ShadowObj(x-bitmap.width/2, y-bitmap.height/2, bitmap, imIndex);
		objShadow.alpha = 0.5;
		add(objShadow);
	}

    public function findStackHeight()
	{
		var y:Float = FlxG.height-floor.height-1;
		var step:Float = 100;
		var anchorSet:Bool = false;		
		
		var resultMod:Float = 0;
		while (true) {
			var ray:Ray = new Ray(new Vec2(0, y), new Vec2(1, 0));
			
			var rayResult = FlxNapeState.space.rayCast(ray);
			
			if (rayResult == null) {
				break;
			} else if (rayResult.shape.body.interactingBodies().empty() || rayResult.shape.body.velocity.y >= 20 || rayResult.shape.body.velocity.y <= -20) {
				resultMod += step;
				y -= step;
			} else {
				y -= step;
			}
			
		}
		
		//0 is the top of the screen - if we go above 0, keep it positive
		if (y <= 0) {
			return FlxG.height + Math.abs(y)-resultMod;
			
			
		}
		
		return FlxG.height-floor.height-1-y-resultMod;
	}
	
	
	public function zoomFinished(tween:FlxTween )
	{
		zooming = false;

	}

	

	
	public function checkZoom(timer:FlxTimer)
	{
		var height = Math.floor((stackHeight + 50) / 100);
		

		
		if (height >= 15 || correctAnswers >= 20 && mode != 'arcade') {
			waitTimer.cancel();
			winState= new WinState(height, true, 0xee333355);
		    winState.closeCallback = homePressed;	
			openSubState(winState);
		}
		
		 else if (lives <= 0) {
			waitTimer.cancel();
			winState = new WinState(height, false, 0xee333355);
			winState.closeCallback = reloadPressed;
			openSubState(winState);
		}
		
		
		if (height == 1) {
			heightDisplay.text = Std.string(height+" metre");
		} else {
			heightDisplay.text = Std.string(height+" metres");
		}
		
		
		if (zooming) return;
		
	
		//if any objects are moving, don't zoom.
		/*for (obj in stackObjects) {
			if (obj.body.velocity.y < -1 || obj.body.velocity.y > 1 ||
			    obj.body.velocity.x < -1 || obj.body.velocity.x > 1) {
				return;
			}
		}*/
		
		if (stackHeight >= zoomCeiling && !zooming) {
			
			zooming = true;
			zoomCeiling += 150;

			FlxTween.tween(scroller, { y:scroller.y-150 }, 1, {complete:zoomFinished});
		} else if (stackHeight < zoomCeiling-150 && !zooming && zoomCeiling > 400) {
			zooming = true;
			

			zoomCeiling -= 150;
			FlxTween.tween(scroller, { y:scroller.y+150 }, 1, {complete:zoomFinished});
		}
	}
	
	public function cleanObjects() 
	{
		var i = stackObjects.length;
		while (i-- > 0) {
			if (stackObjects[i].body.position.y > floor.y + 100) {
				stackObjects[i].destroy();
				stackObjects.splice(i, 1);
				lives--;
				FlxG.camera.shake(0.01, 0.2);
				FlxG.sound.play('assets/music/Tower Crash.mp3');
			}
		}

	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		
		handleMouse();
		
		stackHeight = findStackHeight();
		
		cleanObjects();
		
		livesTxt.text = "Lives: " + Std.string(lives);
						
		
	}
}