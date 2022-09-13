package;

import openfl.filters.ShaderFilter;
import Shaders

class ChromaticAberration extend Shaders
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration());

	public static function setChrome(chromeOffset:Float):Void
	{
		Shaders.shader.data.rOffset.value = [chromeOffset];
		Shaders.shader.data.gOffset.value = [0.0];
		Shaders.shader.data.bOffset.value = [chromeOffset * -1];
	}
}
