package backend;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import haxe.Json;
import haxe.format.JsonParser;
import backend.Song;

typedef StageFile = {
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;
	var stageUI:String;
	var healthBarOverlay:String;
	var healthBarBg:String;
	var healthBarBgX:Float;
	var healthBarBgY:Float;
	var healthBarOverlayX:Float;
	var healthBarOverlayY:Float;
	var timeBarColor:String;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;
}

class StageData {
	public static function dummy():StageFile
	{
		return {
			directory: "",
			defaultZoom: 0.9,
			isPixelStage: false,
			stageUI: "normal",
			healthBarOverlay: "",
			healthBarBg: "healthBar",
			healthBarBgX: 0,
			healthBarBgY: 0,
			healthBarOverlayX: 0,
			healthBarOverlayY: 0,
			timeBarColor: "0xFFFFFFFF",

			boyfriend: [770, 100],
			girlfriend: [400, 130],
			opponent: [100, 100],
			hide_girlfriend: true,

			camera_boyfriend: [0, 0],
			camera_opponent: [0, 0],
			camera_girlfriend: [0, 0],
			camera_speed: 1
		};
	}

	public static var forceNextDirectory:String = null;
	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		if(SONG.stage != null) {
			stage = SONG.stage;
		} else if(SONG.song != null) {
			switch (SONG.song.toLowerCase().replace(' ', '-'))
			{
				case 'fuck you':
					stage = 'stage';
				case 'whoopee' | 'sansational' | 'final-stretch' | 'burning-in-hell':
					stage = 'hall';
				case 'snake-eyes' | 'technicolor-tussle' | 'knockout':
					stage = 'field';
				default:
					stage = 'stage';
			}
		} else {
			stage = 'stage';
		}

		var stageFile:StageFile = getStageFile(stage);
		if(stageFile == null) { //preventing crashes
			forceNextDirectory = '';
		} else {
			forceNextDirectory = stageFile.directory;
		}
	}

	public static function getStageFile(stage:String):StageFile {
		var rawJson:String = null;
		var path:String = SUtil.getPath() + Paths.getPreloadPath('stages/' + stage + '.json');

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('stages/' + stage + '.json');
		if(FileSystem.exists(modPath)) {
			rawJson = File.getContent(modPath);
		} else if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(Assets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end
		else
		{
			return null;
		}
		return cast Json.parse(rawJson);
	}

	public static function vanillaSongStage(songName):String
	{
		return 'stage';
	}
}
